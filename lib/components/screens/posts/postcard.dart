import "package:any_link_preview/any_link_preview.dart";
import "package:flutter/material.dart";
import "package:flutter_link_previewer/flutter_link_previewer.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:social/components/controllers/authcontroller.dart";
import "package:social/components/controllers/postcontroller.dart";
import "package:social/components/model/postmodel.dart";
import "package:social/core/constants.dart";
import "package:social/themes/colorscheme.dart";
import "package:social/themes/themehandler.dart";

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  void deletePost(WidgetRef ref, BuildContext context) async {
    ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.typeOfPost == "Image";
    final isTypeLink = post.typeOfPost == "Link";
    final isTypeText = post.typeOfPost == "Text";

    final currentTheme = ref.watch(themeDataProvider);
    final user = ref.watch(userDataProvider)!;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: currentTheme.drawerTheme.backgroundColor,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      post.communityProfilePic,
                                    ),
                                    radius: 16,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "r/${post.communityName}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "u/${post.username}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (post.uid == user.uid)
                                IconButton(
                                  onPressed: () {
                                    deletePost(ref, context);
                                  },
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              post.title,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (isTypeImage)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: double.infinity,
                              child: Image.network(
                                post.link!,
                                fit: BoxFit.contain,
                              ),
                            ),
                          if (isTypeLink)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: AnyLinkPreview(
                                link: post.link!,
                                key: ValueKey(post.link!),
                              ),
                            ),
                          if (isTypeText)
                            Container(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Text(
                                  post.description!,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Constants.up,
                                      size: 30,
                                      color: post.upvotes.contains(user.uid)
                                          ? Colorscheme.redColor
                                          : null,
                                    ),
                                  ),
                                  Text(
                                    "${post.upvotes.length - post.downvotes.length == 0 ? "Vote" : post.upvotes.length - post.downvotes.length}",
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Constants.down,
                                      size: 30,
                                      color: post.upvotes.contains(user.uid)
                                          ? Colorscheme.blueColor
                                          : null,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.comment),
                                  ),
                                  Text(
                                    "${post.commentCount == 0 ? "Comment" : post.commentCount}",
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
