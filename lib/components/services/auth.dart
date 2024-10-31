import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:social/components/providers/fb_providers.dart";
import "package:social/components/model/usermodel.dart";
import "package:social/core/failure.dart";
import "package:social/core/firebase_constants.dart";
import "package:social/core/images.dart";
import "package:social/core/typdef.dart";
import "package:fpdart/fpdart.dart";

final authServiceProvider = Provider(
  (ref) => AuthService(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthService {
  final FirebaseFirestore _fireStore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  CollectionReference get _users => _fireStore.collection(FirebaseConstants.userCollection);

  Stream<User?> get authStateChange => _auth.authStateChanges();
  AuthService(
      {required FirebaseFirestore firestore,
      required FirebaseAuth auth,
      required GoogleSignIn googleSignIn})
      : _fireStore = firestore,
        _auth = auth,
        _googleSignIn = googleSignIn;

  FutureEither<UserModel> signInWithGoogle(bool isFromLogin) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuthentication = await googleUser?.authentication;
      final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuthentication?.accessToken,
        idToken: googleAuthentication?.idToken,
      );
      UserCredential userCredential;
      if (isFromLogin) {
        userCredential = await _auth.signInWithCredential(credentials);
      } else {
        userCredential = await _auth.currentUser!.linkWithCredential(credentials);
      }
      UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: userCredential.user!.displayName ?? "No Name",
          profilePicture: userCredential.user!.photoURL ?? Images.avatarDefault,
          banner: Images.bannerDefault,
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          score: 0,
          awards: ["til", "gold", "platinum"],
        );
        await _users.doc(userModel.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (error) {
      throw error.message!;
    } catch (error) {
      return left(
        Failure(
          message: error.toString(),
        ),
      );
    } // Throw error in error handlers
  }

  Stream<UserModel> getUserData(String uid) {
    return _users
        .doc(uid)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  FutureEither<UserModel> signInAsGuest() async {
    try {
      var userCredential = await _auth.signInAnonymously();
      UserModel userModel;

      userModel = UserModel(
        name: "Guest",
        profilePicture: Images.avatarDefault,
        banner: Images.bannerDefault,
        uid: userCredential.user!.uid,
        isAuthenticated: false,
        score: 0,
        awards: [],
      );
      await _users.doc(userModel.uid).set(userModel.toMap());

      return right(userModel);
    } on FirebaseException catch (error) {
      throw error.message!;
    } catch (error) {
      return left(
        Failure(
          message: error.toString(),
        ),
      );
    } // Throw error in error handlers
  }
}
