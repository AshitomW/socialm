import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:social/components/controllers/authcontroller.dart';
import 'package:social/components/controllers/userprofilecontroller.dart';
import 'package:social/components/model/commentmodel.dart';
import 'package:social/components/model/communitymodel.dart';
import 'package:social/components/model/postmodel.dart';
import 'package:social/components/services/postservice.dart';
import 'package:social/components/services/storagerepo.dart';
import "package:flutter/material.dart";
import 'package:social/components/widgets/errorSnack.dart';
import 'package:social/core/enums.dart';
import 'package:uuid/uuid.dart';

final postControllerProvider = StateNotifierProvider<PostController, bool>((ref) {
  final postService = ref.watch(postServiceProvider);
  final storageRepoProvider = ref.watch(firebaseStorageProvider);
  return PostController(
    postService: postService,
    ref: ref,
    storageRepository: storageRepoProvider,
  );
});

final userPostProvider = StreamProvider.family((ref, List<Community> communities) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPosts(communities);
});

final getPostByIdProvider = StreamProvider.family((ref, String postId) {
  return ref.read(postControllerProvider.notifier).getPostById(postId);
});

final getPostCommentProvider = StreamProvider.family((ref, String postId) {
  return ref.read(postControllerProvider.notifier).fetchPostComments(postId);
});

class PostController extends StateNotifier<bool> {
  final PostService _postservice;
  final StorageRepository _storageRepository;
  final Ref _ref;
  PostController(
      {required PostService postService,
      required Ref ref,
      required StorageRepository storageRepository})
      : _postservice = postService,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void shareText({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String description,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userDataProvider)!;
    final Post post = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      typeOfPost: "Text",
      createdAt: DateTime.now(),
      awards: [],
      description: description,
    );

    final result = await _postservice.addPost(post);
    _ref.read(userProfileControllerProvider.notifier).updateUserScore(UserScore.textPost);
    state = false;
    result.fold((failure) => showSnackBar(context, failure.message), (success) {
      showSnackBar(context, "Posted Successfully");
      Routemaster.of(context).pop();
    });
  }

  void shareLinkPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String link,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userDataProvider)!;
    final Post post = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      typeOfPost: "Link",
      createdAt: DateTime.now(),
      awards: [],
      link: link,
    );

    final result = await _postservice.addPost(post);
    _ref.read(userProfileControllerProvider.notifier).updateUserScore(UserScore.linkPost);
    state = false;
    result.fold((failure) => showSnackBar(context, failure.message), (success) {
      showSnackBar(context, "Posted Successfully");
      Routemaster.of(context).pop();
    });
  }

  void shareImage({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required File? file,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userDataProvider)!;
    final imageResult = await _storageRepository.storeFile(
        path: 'posts/${selectedCommunity.name}', id: postId, file: file);

    imageResult.fold((failure) => showSnackBar(context, failure.message), (dataUrl) async {
      final Post post = Post(
        id: postId,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        typeOfPost: "Image",
        createdAt: DateTime.now(),
        awards: [],
        link: dataUrl,
      );
      final result = await _postservice.addPost(post);
      _ref.read(userProfileControllerProvider.notifier).updateUserScore(UserScore.imagePost);
      state = false;
      result.fold((failure) => showSnackBar(context, failure.message), (success) {
        showSnackBar(context, "Posted Successfully");
        Routemaster.of(context).pop();
      });
    });
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postservice.fetchUserPost(communities);
    }
    return Stream.value([]);
  }

  void deletePost(Post post, BuildContext context) async {
    final result = await _postservice.deletePost(post);
    _ref.read(userProfileControllerProvider.notifier).updateUserScore(UserScore.deletePost);
    result.fold((failure) => showSnackBar(context, "Could not delete the post. Try again later !"),
        (success) => showSnackBar(context, "Successfully deleted the post"));
  }

  void upvote(Post post) async {
    final user = _ref.read(userDataProvider);
    _postservice.upvote(post, user!.uid);
  }

  void downvote(Post post) async {
    final user = _ref.read(userDataProvider)!;
    _postservice.downvote(post, user.uid);
  }

  Stream<Post> getPostById(String postId) {
    return _postservice.getPostById(postId);
  }

  void addComment({required BuildContext context, required String text, required Post post}) async {
    final user = _ref.read(userDataProvider)!;
    Comment comment = Comment(
      id: const Uuid().v1(),
      text: text,
      createdAt: DateTime.now(),
      postId: post.id,
      username: user.name,
      profilePic: user.profilePicture,
    );
    final result = await _postservice.addComment(comment);
    _ref.read(userProfileControllerProvider.notifier).updateUserScore(UserScore.comment);
    result.fold((failure) => showSnackBar(context, failure.message), (success) => null);
  }

  Stream<List<Comment>> fetchPostComments(String postId) {
    return _postservice.getCommentsOfPost(postId);
  }

  void awardPost({
    required Post post,
    required String award,
    required BuildContext context,
  }) async {
    final user = _ref.read(userDataProvider)!;
    final res = await _postservice.awardPost(post, award, user.uid);
    res.fold((failure) => showSnackBar(context, failure.message), (success) {
      _ref.read(userProfileControllerProvider.notifier).updateUserScore(UserScore.awardPost);
      _ref.read(userDataProvider.notifier).update((state) {
        state?.awards.remove(award);
        return state;
      });
      Routemaster.of(context).pop();
    });
  }
}
