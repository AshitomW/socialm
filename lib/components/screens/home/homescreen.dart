import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:social/components/controllers/authcontroller.dart";
import "package:social/components/screens/home/delegates/searchcommunity.dart";
import "package:social/components/screens/home/drawers/communitylist.dart";
import "package:social/components/screens/home/drawers/userprofiledrawer.dart";

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              openDrawer(context);
            },
            icon: const Icon(Icons.menu),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchCommunityDelegate(ref: ref));
            },
            icon: const Icon(Icons.search),
          ),
          Builder(builder: (context) {
            return IconButton(
              onPressed: () => displayEndDrawer(context),
              icon: CircleAvatar(
                backgroundImage: NetworkImage(user.profilePicture),
                radius: 18,
              ),
            );
          })
        ],
      ),
      drawer: const CommunityLists(),
      endDrawer: const ProfileDrawer(),
    );
  }
}
