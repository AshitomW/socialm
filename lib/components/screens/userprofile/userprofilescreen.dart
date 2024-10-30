import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:routemaster/routemaster.dart";
import "package:social/components/controllers/authcontroller.dart";
import "package:social/components/controllers/communityController.dart";
import "package:social/core/loader.dart";

import "../../../core/error_text.dart";

class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({super.key, required this.uid});

  void navigateToEditProfile(BuildContext context) {
    Routemaster.of(context).push("/edit-profile/$uid");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when(
          data: (user) {
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 250,
                    floating: true,
                    snap: true,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(user.banner, fit: BoxFit.cover),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(20).copyWith(bottom: 80),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(user.profilePicture),
                            radius: 45,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(20),
                          child: OutlinedButton(
                            onPressed: () {
                              navigateToEditProfile(context);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 25, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text("Edit Profile"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(
                              "u/${user.name}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ]),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              "${user.score} Points",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            thickness: 2,
                          )
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: const Center(child: Text("Displaying Posts")),
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
