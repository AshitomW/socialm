import 'package:flutter/material.dart';
import "package:routemaster/routemaster.dart";
import "package:social/components/controllers/authcontroller.dart";
import 'package:social/components/services/community.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:social/components/model/communitymodel.dart";
import "package:social/components/widgets/errorSnack.dart";
import "package:social/core/images.dart";

final userCommunityProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

final communityControllerProvider = StateNotifierProvider<CommunityController, bool>((ref) {
  final communityService = ref.watch(communityServiceProvider);
  return CommunityController(communityService: communityService, ref: ref);
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref.watch(communityControllerProvider.notifier).getCommunityByName(name);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityService _communityservice;
  final Ref _ref;
  CommunityController({required CommunityService communityService, required Ref ref})
      : _communityservice = communityService,
        _ref = ref,
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

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userDataProvider)!.uid;
    return _communityservice.getUserCommunities(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityservice.getCommunityByName(name);
  }
}
