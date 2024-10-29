import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:routemaster/routemaster.dart";
import "package:social/components/controllers/communityController.dart";
import "package:social/core/error_text.dart";
import "package:social/core/loader.dart";

class CommunityLists extends ConsumerWidget {
  const CommunityLists({super.key});

  void navigateToCommunity(BuildContext context) {
    Scaffold.of(context).closeDrawer();
    Routemaster.of(context).push("/create_community");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: const Text("Create Community"),
              leading: const Icon(Icons.add),
              onTap: () => navigateToCommunity(context),
            ),
            ref.watch(userCommunityProvider).when(
                data: (data) => Expanded(
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            final community = data[index];
                            return ListTile(
                              onTap: () {},
                              leading: CircleAvatar(
                                radius: 15,
                                backgroundImage: NetworkImage(community.avatar),
                              ),
                              title: Text("r/${community.name}"),
                            );
                          }),
                    ),
                error: (error, stackTrace) => ErrorText(error: error.toString()),
                loading: () => const Loader()),
          ],
        ),
      ),
    );
  }
}
