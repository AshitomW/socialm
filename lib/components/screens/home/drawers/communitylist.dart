import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:routemaster/routemaster.dart";
import "package:social/components/controllers/authcontroller.dart";
import "package:social/components/controllers/communityController.dart";
import "package:social/components/widgets/button.dart";
import "package:social/core/error_text.dart";
import "package:social/core/images.dart";
import "package:social/core/loader.dart";

class CommunityLists extends ConsumerWidget {
  const CommunityLists({super.key});

  void navigateToCommunity(BuildContext context) {
    Scaffold.of(context).closeDrawer();
    Routemaster.of(context).push("/create_community");
  }

  void navigateToCommunityProfile(BuildContext context, String communityName) {
    Routemaster.of(context).push("/r/$communityName");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataProvider)!;
    final isGuest = !user.isAuthenticated;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            isGuest
                ? SignInButton(
                    labelString: "Sign In With Google",
                    imageUrl: Images.googleIcon,
                    isFromLogIn: false,
                  )
                : ListTile(
                    title: const Text("Create Community"),
                    leading: const Icon(Icons.add),
                    onTap: () => navigateToCommunity(context),
                  ),
            if (!isGuest) ...[
              ref.watch(userCommunityProvider(user.uid)).when(
                  data: (data) => Expanded(
                        child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              final community = data[index];
                              return ListTile(
                                onTap: () => navigateToCommunityProfile(context, community.name),
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
            ]
          ],
        ),
      ),
    );
  }
}
