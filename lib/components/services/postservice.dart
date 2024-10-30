import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:fpdart/fpdart.dart';
import 'package:social/components/model/communitymodel.dart';
import 'package:social/components/model/postmodel.dart';
import 'package:social/components/providers/fb_providers.dart';
import 'package:social/core/failure.dart';
import 'package:social/core/firebase_constants.dart';
import 'package:social/core/typdef.dart';

final postServiceProvider = Provider((ref) {
  return PostService(firestore: ref.watch(firestoreProvider));
});

class PostService {
  final FirebaseFirestore _firestore;
  const PostService({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _posts => _firestore.collection(FirebaseConstants.postsCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (error) {
      throw error.message!;
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }
}
