import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:social/components/providers/fb_providers.dart';
import 'package:social/core/failure.dart';
import 'package:social/core/firebase_constants.dart';
import 'package:social/core/typdef.dart';
import "package:fpdart/fpdart.dart";
import "package:social/components/model/community.dart";

final communityServiceProvider = Provider((ref) {
  return CommunityService(firestore: ref.watch(firestoreProvider));
});

class CommunityService {
  final FirebaseFirestore _firestore;
  CommunityService({required FirebaseFirestore firestore}) : _firestore = firestore;

  FutureVoid createCommunity(Community community) async {
    try {
      var communityDocument = await _communities.doc(community.name).get();
      if (communityDocument.exists) {
        throw "Community with same name already exists!";
      }
      return right(_communities.doc(community.name).set(community.toMap()));
    } on FirebaseException catch (error) {
      return left(Failure(message: error.message!));
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communitiesCollection);
}
