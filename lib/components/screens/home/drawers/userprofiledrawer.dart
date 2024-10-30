import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:routemaster/routemaster.dart";
import "package:social/components/controllers/authcontroller.dart";
import "package:social/core/enums.dart";
import "package:social/themes/themehandler.dart";

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});
  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logOut();
  }

  void navigateToUserProfile(BuildContext context, String uid) {
    Routemaster.of(context).push("/u/$uid");
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeDataProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataProvider)!;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.profilePicture),
              radius: 70,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "u/${user.name}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text("My Profile"),
              leading: const Icon(Icons.person),
              onTap: () => {navigateToUserProfile(context, user.uid)},
            ),
            ListTile(
              title: const Text("Logout"),
              leading: const Icon(
                Icons.logout,
                color: Colors.redAccent,
              ),
              onTap: () => logOut(ref),
            ),
            ListTile(
              title: const Text("Dark Mode"),
              trailing: Switch.adaptive(
                  value: ref.watch(themeDataProvider.notifier).currentTheme == Thememode.dark
                      ? true
                      : false,
                  onChanged: (val) {
                    toggleTheme(ref);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
