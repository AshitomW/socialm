import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:social/components/providers/fb_providers.dart";
import "package:social/components/model/usermodel.dart";
import "package:social/core/firebase_constants.dart";
import "package:social/core/images.dart";

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
  AuthService(
      {required FirebaseFirestore firestore,
      required FirebaseAuth auth,
      required GoogleSignIn googleSignIn})
      : _fireStore = firestore,
        _auth = auth,
        _googleSignIn = googleSignIn;

  void signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuthentication = await googleUser?.authentication;
      final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuthentication?.accessToken,
        idToken: googleAuthentication?.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credentials);
      UserModel userModel = UserModel(
        name: userCredential.user!.displayName ?? "No Name",
        profilePicture: userCredential.user!.photoURL ?? Images.avatarDefault,
        banner: Images.bannerDefault,
        uid: userCredential.user!.uid,
        isAuthenticated: true,
        score: 0,
        awards: [],
      );

      await _users.doc(userModel.uid).set(userModel.toMap());
    } catch (error) {
      print(error);
    } // Throw error in error handlers
  }
}