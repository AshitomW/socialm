import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:social/components/controllers/authcontroller.dart';
import 'package:social/components/model/communitymodel.dart';
import 'package:social/components/model/postmodel.dart';
import 'package:social/components/services/postservice.dart';
import 'package:social/components/services/storagerepo.dart';
import "package:flutter/material.dart";
import 'package:social/components/widgets/errorSnack.dart';
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
      state = false;
      result.fold((failure) => showSnackBar(context, failure.message), (success) {
        showSnackBar(context, "Posted Successfully");
        Routemaster.of(context).pop();
      });
    });
  }
}
