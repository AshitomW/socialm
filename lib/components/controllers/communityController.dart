import 'package:flutter/material.dart';
import "package:social/components/model/postmodel.dart";

import "package:social/components/services/storagerepo.dart";
import "dart:io";

import "package:routemaster/routemaster.dart";
import "package:social/components/controllers/authcontroller.dart";
import 'package:social/components/services/community.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:social/components/model/communitymodel.dart";
import "package:social/components/widgets/errorSnack.dart";
import "package:social/core/images.dart";
import "package:social/core/typdef.dart";

final userCommunityProvider = StreamProvider.family((ref, String uid) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities(uid);
});

final searchCommunityProvider = StreamProvider.family((ref, String query) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.searchCommunity(query);
});

final communityControllerProvider = StateNotifierProvider<CommunityController, bool>((ref) {
  final communityService = ref.watch(communityServiceProvider);
  final storageRepoProvider = ref.watch(firebaseStorageProvider);
  return CommunityController(
    communityService: communityService,
    ref: ref,
    storageRepository: storageRepoProvider,
  );
});

final communityProfilePostProvider = StreamProvider.family((ref, String communityName) {
  return ref.read(communityControllerProvider.notifier).getCommunityPosts(communityName);
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref.watch(communityControllerProvider.notifier).getCommunityByName(name);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityService _communityservice;
  final StorageRepository _storageRepository;
  final Ref _ref;
  CommunityController(
      {required CommunityService communityService,
      required Ref ref,
      required StorageRepository storageRepository})
      : _communityservice = communityService,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userDataProvider)?.uid ?? "";
    Community community = Community(
      id: name,
      name: name,
      banner: Images.bannerDefault,
      avatar: Images.avatarDefault,
      members: [uid],
      moderators: [uid],
    );

    final results = await _communityservice.createCommunity(community);
    state = false;
    results.fold((error) => showSnackBar(context, error.message), (success) {
      showSnackBar(context, "Community Created Succesfully");
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Community>> getUserCommunities(String uid) {
    // final uid = _ref.read(userDataProvider)!.uid;
    return _communityservice.getUserCommunities(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityservice.getCommunityByName(name);
  }

  void editCommunity({
    required File? profilepic,
    required File? bannerpic,
    required Community community,
    required BuildContext context,
  }) async {
    state = true;
    if (profilepic != null) {
      final results = await _storageRepository.storeFile(
        path: "communities/profile",
        id: community.name,
        file: profilepic,
      );
      results.fold(
        (error) => showSnackBar(context, error.message),
        (dataUrl) => community = community.copyWith(avatar: dataUrl),
      );
    }
    if (bannerpic != null) {
      final results = await _storageRepository.storeFile(
        path: "communities/banner",
        id: community.name,
        file: bannerpic,
      );
      results.fold(
        (error) => showSnackBar(context, error.message),
        (dataUrl) => community = community.copyWith(banner: dataUrl),
      );
    }
    final results = await _communityservice.editCommunity(community);
    state = false;
    results.fold((error) => showSnackBar(context, error.message), (sucess) {
      showSnackBar(context, "Successfully Updated Community Profile");
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityservice.searchCommunity(query);
  }

  void joinCommunity(Community community, BuildContext context) async {
    final user = _ref.read(userDataProvider)!;
    final isUserAMember = community.members.contains(user.uid);
    FutureVoid result;
    if (isUserAMember) {
      result = _communityservice.leaveCommunity(community.name, user.uid);
    } else {
      result = _communityservice.joinCommunity(community.name, user.uid);
    }
    (await result).fold((error) => showSnackBar(context, error.message), (success) {
      if (isUserAMember) {
        showSnackBar(context, "Community Left Sucessfully");
      } else {
        showSnackBar(context, "Joined Community Sucessfully");
      }
    });
  }

  void addModeratorToCommunity(String communityName, List<String> uids,
      {required BuildContext context}) async {
    final result = await _communityservice.addModeratorToCommunity(communityName, uids);
    result.fold((failure) => showSnackBar(context, failure.message),
        (success) => Routemaster.of(context).pop());
  }

  Stream<List<Post>> getCommunityPosts(String communityName) {
    return _communityservice.getCommunityPosts(communityName);
  }
}
