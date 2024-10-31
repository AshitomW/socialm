import "package:any_link_preview/any_link_preview.dart";
import "package:flutter/material.dart";

import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:routemaster/routemaster.dart";
import "package:social/components/controllers/authcontroller.dart";
import "package:social/components/controllers/communityController.dart";
import "package:social/components/controllers/postcontroller.dart";
import "package:social/components/model/postmodel.dart";
import "package:social/core/constants.dart";
import "package:social/core/error_text.dart";
import "package:social/core/images.dart";
import "package:social/core/loader.dart";
import "package:social/themes/colorscheme.dart";
import "package:social/themes/themehandler.dart";

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  void deletePost(WidgetRef ref, BuildContext context) async {
    ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  void upVotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).upvote(post);
  }

  void downVotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).downvote(post);
  }

  void navigateToUserProfile(BuildContext context) {
    Routemaster.of(context).push("/u/${post.uid}");
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push("/r/${post.communityName}");
  }

  void navigateToPost(BuildContext context) {
    Routemaster.of(context).push("/post/comments/${post.id}");
  }

  void awardPost(WidgetRef ref, String award, BuildContext context) async {
    ref.read(postControllerProvider.notifier).awardPost(post: post, award: award, context: context);
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
                                  GestureDetector(
                                    onTap: () => navigateToCommunity(context),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        post.communityProfilePic,
                                      ),
                                      radius: 16,
                                    ),
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
                                        GestureDetector(
                                          onTap: () => navigateToUserProfile(context),
                                          child: Text(
                                            "u/${post.username}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
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
                                ),
                            ],
                          ),
                          if (post.awards.isNotEmpty) ...[
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: 25,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: post.awards.length,
                                itemBuilder: (context, index) {
                                  final award = post.awards[index];
                                  return Image.asset(
                                    Images.awards[award]!,
                                    height: 20,
                                  );
                                },
                              ),
                            ),
                          ],
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      upVotePost(ref);
                                    },
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
                                    onPressed: () {
                                      downVotePost(ref);
                                    },
                                    icon: Icon(
                                      Constants.down,
                                      size: 30,
                                      color: post.downvotes.contains(user.uid)
                                          ? Colorscheme.blueColor
                                          : null,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      navigateToPost(context);
                                    },
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
                              ),
                              ref.watch(getCommunityByNameProvider(post.communityName)).when(
                                    data: (community) {
                                      if (community.moderators.contains(user.uid)) {
                                        return IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.add_moderator),
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                    error: (error, stackTrace) => ErrorText(
                                      error: error.toString(),
                                    ),
                                    loading: () => const Loader(),
                                  ),
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                              child: Padding(
                                                padding: const EdgeInsets.all(16),
                                                child: GridView.builder(
                                                  shrinkWrap: true,
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 4),
                                                  itemCount: user.awards.length,
                                                  itemBuilder: (context, index) {
                                                    final award = user.awards[index];
                                                    return GestureDetector(
                                                      onTap: () {
                                                        awardPost(ref, award, context);
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(16.0),
                                                        child: Image.asset(Images.awards[award]!),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ));
                                  },
                                  icon: const Icon(Icons.card_giftcard_outlined))
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
