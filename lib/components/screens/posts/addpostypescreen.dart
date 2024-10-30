import "dart:io";

import "package:dotted_border/dotted_border.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter/material.dart";
import "package:social/components/controllers/authcontroller.dart";
import "package:social/components/controllers/communityController.dart";
import "package:social/components/controllers/postcontroller.dart";
import "package:social/components/model/communitymodel.dart";
import "package:social/components/widgets/errorSnack.dart";
import "package:social/core/error_text.dart";

import "package:social/core/imagepicker.dart";
import "package:social/core/loader.dart";

import "package:social/themes/themehandler.dart";

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String postType;
  const AddPostTypeScreen({super.key, required this.postType});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  File? bannerFile;
  List<Community> communities = [];
  Community? selectedCommunity;

  @override
  void dispose() {
    titleController.dispose();
    linkController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void selectBannerImage() async {
    final result = await pickImage();
    if (result != null) {
      setState(() {
        bannerFile = File(result.files.first.path!);
      });
    }
  }

  void sharePost() {
    if (widget.postType == "Image" && bannerFile != null && titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImage(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            file: bannerFile,
          );
    } else if (widget.postType == "Text" && titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareText(
            context: context,
            title: titleController.text,
            selectedCommunity: selectedCommunity ?? communities[0],
            description: descriptionController.text.trim(),
          );
    } else if (widget.postType == "Link" &&
        titleController.text.isNotEmpty &&
        linkController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
          context: context,
          title: titleController.text.trim(),
          selectedCommunity: selectedCommunity ?? communities[0],
          link: linkController.text.trim());
    } else {
      showSnackBar(context, "Please Enter All The Fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.postType == "Image";
    final isTypeLink = widget.postType == "Link";
    final isTypeText = widget.postType == "Text";
    final userData = ref.watch(userDataProvider);
    final currentTheme = ref.watch(themeDataProvider);
    final isLoading = ref.watch(postControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.postType),
        actions: [
          TextButton(
            onPressed: sharePost,
            child: const Text("Share"),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    maxLength: 50,
                    decoration: InputDecoration(
                      hintText: "Enter Title Here",
                      fillColor: currentTheme.canvasColor,
                      filled: true,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(18),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (isTypeImage)
                    GestureDetector(
                      onTap: selectBannerImage,
                      child: DottedBorder(
                        radius: const Radius.circular(10),
                        borderType: BorderType.RRect,
                        dashPattern: const [10, 4],
                        strokeCap: StrokeCap.round,
                        color: currentTheme.textTheme.bodyMedium!.color!,
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: bannerFile != null
                              ? Image.file(bannerFile!)
                              : const Center(
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 40,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  if (isTypeText)
                    TextField(
                      controller: descriptionController,
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintText: "Enter Description here",
                        filled: true,
                        fillColor: currentTheme.canvasColor,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(18),
                      ),
                    ),
                  if (isTypeLink)
                    TextField(
                      controller: linkController,
                      decoration: InputDecoration(
                        hintText: "Enter Link Here",
                        filled: true,
                        fillColor: currentTheme.canvasColor,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(18),
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Select Community",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                  ),
                  ref.watch(userCommunityProvider(userData!.uid)).when(
                        data: (data) {
                          communities = data;
                          if (data.isEmpty) {
                            return const SizedBox();
                          }
                          return DropdownButton(
                            menuWidth: double.infinity,
                            value: selectedCommunity ?? data[0],
                            items: data
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedCommunity = val;
                              });
                            },
                          );
                        },
                        error: (error, stackTract) => ErrorText(error: error.toString()),
                        loading: () => const Loader(),
                      ),
                ],
              ),
            ),
    );
  }
}
