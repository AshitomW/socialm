import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:routemaster/routemaster.dart";
import "package:social/components/controllers/authcontroller.dart";
import "package:social/components/controllers/communityController.dart";
import "package:social/components/screens/posts/postcard.dart";
import "package:social/core/error_text.dart";
import "package:social/core/loader.dart";
import "package:social/components/model/communitymodel.dart";

class CommunityProfile extends ConsumerWidget {
  final String name;
  const CommunityProfile({required this.name, super.key});

  void navigateToModTools(context) {
    Routemaster.of(context).push("/modtools/$name");
  }

  void joinCommunity(
      {required WidgetRef ref, required Community community, required BuildContext context}) {
    ref.read(communityControllerProvider.notifier).joinCommunity(community, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataProvider)!;
    final isGuest = !user.isAuthenticated;
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
          data: (community) {
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 150,
                    floating: true,
                    snap: true,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(community.banner, fit: BoxFit.cover),
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Align(
                            alignment: Alignment.topLeft,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(community.avatar),
                              radius: 35,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(
                              "r/${community.name}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            if (!isGuest)
                              community.moderators.contains(user.uid)
                                  ? OutlinedButton(
                                      onPressed: () => navigateToModTools(context),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsetsDirectional.symmetric(
                                            horizontal: 25, vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: const Text("Mod tools"),
                                    )
                                  : OutlinedButton(
                                      onPressed: () {
                                        joinCommunity(
                                            ref: ref, community: community, context: context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsetsDirectional.symmetric(
                                            horizontal: 25, vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: Text(
                                          community.members.contains(user.uid) ? "Joined" : "Join"),
                                    ),
                          ]),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              "${community.members.length} Members",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: ref.watch(communityProfilePostProvider(community.name)).when(
                  data: (posts) {
                    return ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return PostCard(post: post);
                        });
                  },
                  error: (error, stackTrace) {
                    return ErrorText(error: error.toString());
                  },
                  loading: () => const Loader()),
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
