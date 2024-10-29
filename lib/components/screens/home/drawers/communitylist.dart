import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:routemaster/routemaster.dart";

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
          ],
        ),
      ),
    );
  }
}
