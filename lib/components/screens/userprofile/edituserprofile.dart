import "package:dotted_border/dotted_border.dart";
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:social/components/controllers/authcontroller.dart";
import "package:social/components/controllers/userprofilecontroller.dart";
import "package:social/core/error_text.dart";
import "package:social/core/images.dart";
import "dart:io";
import "package:social/core/imagepicker.dart";
import "package:social/components/model/communitymodel.dart";
import "package:social/core/loader.dart";
import "package:social/themes/colorscheme.dart";

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScreen({super.key, required this.uid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerFile;
  File? profileFile;

  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ref.read(userDataProvider)!.name);
  }

  void selectBannerImage() async {
    final result = await pickImage();
    if (result != null) {
      setState(() {
        bannerFile = File(result.files.first.path!);
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void selectProfileImage() async {
    final result = await pickImage();
    if (result != null) {
      setState(() {
        profileFile = File(result.files.first.path!);
      });
    }
  }

  void saveProfile() {
    ref.read(userProfileControllerProvider.notifier).editProfile(
          profilepic: profileFile,
          bannerpic: bannerFile,
          context: context,
          name: nameController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    return ref.watch(getUserDataProvider(widget.uid)).when(
        data: (community) => Scaffold(
              appBar: AppBar(
                title: const Text("Edit Profile"),
                centerTitle: false,
                actions: [
                  TextButton(
                    onPressed: saveProfile,
                    child: const Text("Save"),
                  ),
                ],
              ),
              body: isLoading
                  ? const Loader()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 220,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: selectBannerImage,
                                    child: DottedBorder(
                                      radius: const Radius.circular(10),
                                      borderType: BorderType.RRect,
                                      dashPattern: const [10, 4],
                                      strokeCap: StrokeCap.round,
                                      color:
                                          Colorscheme.darkModeAppTheme.textTheme.bodyMedium!.color!,
                                      child: Container(
                                        width: double.infinity,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: bannerFile != null
                                            ? Image.file(bannerFile!)
                                            : community.banner.isEmpty ||
                                                    community.banner == Images.bannerDefault
                                                ? const Center(
                                                    child: Icon(Icons.camera_alt),
                                                  )
                                                : Image.network(community.banner),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    left: 20,
                                    child: GestureDetector(
                                      onTap: selectProfileImage,
                                      child: CircleAvatar(
                                        backgroundImage: profileFile != null
                                            ? FileImage(profileFile!)
                                            : NetworkImage(community.profilePicture),
                                        radius: 32,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: "Name",
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(18),
                            ),
                          )
                        ],
                      ),
                    ),
            ),
        error: (error, stackTract) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
