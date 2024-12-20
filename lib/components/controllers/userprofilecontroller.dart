import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:social/components/controllers/authcontroller.dart';
import 'package:social/components/model/communitymodel.dart';
import 'package:social/components/model/postmodel.dart';
import 'package:social/components/model/usermodel.dart';
import 'package:social/components/services/storagerepo.dart';
import 'package:social/components/services/userprofile.dart';
import 'package:social/components/widgets/errorSnack.dart';
import 'package:social/core/enums.dart';

final getUserPostProvider = StreamProvider.family((ref, String uid) {
  return ref.read(userProfileControllerProvider.notifier).getUserPosts(uid);
});

final userProfileControllerProvider = StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileService = ref.watch(userProfileServiceProvider);
  final storageRepoProvider = ref.watch(firebaseStorageProvider);
  return UserProfileController(
    userProfileService: userProfileService,
    ref: ref,
    storageRepository: storageRepoProvider,
  );
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileService _userprofileservice;
  final StorageRepository _storageRepository;
  final Ref _ref;
  UserProfileController(
      {required UserProfileService userProfileService,
      required Ref ref,
      required StorageRepository storageRepository})
      : _userprofileservice = userProfileService,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void editProfile({
    required File? profilepic,
    required File? bannerpic,
    required BuildContext context,
    required String name,
  }) async {
    state = true;
    UserModel user = _ref.read(userDataProvider)!;
    if (profilepic != null) {
      final results = await _storageRepository.storeFile(
        path: "users/profile",
        id: user.uid,
        file: profilepic,
      );
      results.fold(
        (error) => showSnackBar(context, error.message),
        (dataUrl) => user = user.copyWith(profilePicture: dataUrl),
      );
    }
    if (bannerpic != null) {
      final results = await _storageRepository.storeFile(
        path: "users/banner",
        id: user.uid,
        file: bannerpic,
      );
      results.fold(
        (error) => showSnackBar(context, error.message),
        (dataUrl) => user = user.copyWith(banner: dataUrl),
      );
    }

    user = user.copyWith(name: name);

    final results = await _userprofileservice.editUserProfile(user);
    state = false;
    results.fold((error) => showSnackBar(context, error.message), (sucess) {
      showSnackBar(context, "Successfully Updated Your Profile");
      _ref.read(userDataProvider.notifier).update((state) => user);
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Post>> getUserPosts(String uid) {
    return _userprofileservice.getUserPosts(uid);
  }

  void updateUserScore(UserScore score) async {
    UserModel user = _ref.watch(userDataProvider)!;
    user = user.copyWith(score: user.score + score.score);

    final res = await _userprofileservice.updateUserScore(user);
    res.fold((l) => null, (r) => _ref.read(userDataProvider.notifier).update((state) => user));
  }
}
