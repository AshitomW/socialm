import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:social/components/model/postmodel.dart';
import 'package:social/components/providers/fb_providers.dart';
import 'package:social/core/failure.dart';
import 'package:social/core/firebase_constants.dart';
import 'package:social/core/typdef.dart';
import "package:fpdart/fpdart.dart";
import "package:social/components/model/communitymodel.dart";

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
      throw error.message!;
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communitiesCollection);
  CollectionReference get _posts => _firestore.collection(FirebaseConstants.postsCollection);

  Stream<List<Community>> getUserCommunities(String uid) {
    return _communities.where('members', arrayContains: uid).snapshots().map((event) {
      List<Community> communities = [];
      for (var document in event.docs) {
        communities.add(Community.fromMap(document.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }

  Stream<Community> getCommunityByName(String name) {
    return _communities
        .doc(name)
        .snapshots()
        .map((event) => Community.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid editCommunity(Community community) async {
    try {
      return right(_communities.doc(community.name).update(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communities
        .where(
          "name",
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots()
        .map((event) {
      List<Community> communities = [];
      for (var community in event.docs) {
        communities.add(Community.fromMap(community.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }

  FutureVoid joinCommunity(String communityName, String userId) async {
    try {
      return right(_communities.doc(communityName).update({
        "members": FieldValue.arrayUnion([userId])
      }));
    } on FirebaseException catch (error) {
      throw error.message!;
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }

  FutureVoid leaveCommunity(String communityName, String userId) async {
    try {
      return right(_communities.doc(communityName).update({
        "members": FieldValue.arrayRemove([userId])
      }));
    } on FirebaseException catch (error) {
      throw error.message!;
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }

  FutureVoid addModeratorToCommunity(String communityName, List<String> uids) async {
    try {
      return right(_communities.doc(communityName).update({
        "moderators": uids,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Stream<List<Post>> getCommunityPosts(String communityName) {
    return _posts
        .where("communityName", isEqualTo: communityName)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Post.fromMap(e.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }
}
