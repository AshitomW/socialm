import "dart:io";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:dotted_border/dotted_border.dart";
import "package:social/components/controllers/communityController.dart";
import "package:social/components/model/communitymodel.dart";
import "package:social/core/error_text.dart";
import "package:social/core/imagepicker.dart";
import "package:social/core/loader.dart";
import "package:social/core/images.dart";
import "package:social/themes/colorscheme.dart";

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({super.key, required this.name});

  @override
  ConsumerState<EditCommunityScreen> createState() => _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;
  void selectBannerImage() async {
    final result = await pickImage();
    if (result != null) {
      setState(() {
        bannerFile = File(result.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final result = await pickImage();
    if (result != null) {
      setState(() {
        profileFile = File(result.files.first.path!);
      });
    }
  }

  void saveChanges({required Community community}) {
    ref.read(communityControllerProvider.notifier).editCommunity(
        profilepic: profileFile, bannerpic: bannerFile, community: community, context: context);
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(communityControllerProvider);
    return ref.watch(getCommunityByNameProvider(widget.name)).when(
        data: (community) => Scaffold(
              appBar: AppBar(
                title: const Text("Edit Community"),
                centerTitle: false,
                actions: [
                  TextButton(
                    onPressed: () {
                      saveChanges(community: community);
                    },
                    child: const Text("Save"),
                  ),
                ],
              ),
              body: isLoading
                  ? const Loader()
                  : SizedBox(
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
                                color: Colorscheme.darkModeAppTheme.textTheme.bodyMedium!.color!,
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
                                      : NetworkImage(community.avatar),
                                  radius: 32,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
            ),
        error: (error, stackTract) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
