import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:social/components/controllers/authcontroller.dart";
import "package:social/components/screens/home/delegates/searchcommunity.dart";
import "package:social/components/screens/home/drawers/communitylist.dart";
import "package:social/components/screens/home/drawers/userprofiledrawer.dart";
import "package:social/core/constants.dart";
import "package:social/themes/themehandler.dart";

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _pageNo = 0;
  void openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void onPageChange(int page) {
    setState(() {
      _pageNo = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDataProvider)!;
    final currentTheme = ref.watch(themeDataProvider);
    final isGuest = !user.isAuthenticated;
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
      body: IndexedStack(
        index: _pageNo,
        children: Constants.tabWidgets,
      ),
      drawer: const CommunityLists(),
      endDrawer: isGuest ? null : const ProfileDrawer(),
      bottomNavigationBar: isGuest
          ? null
          : CupertinoTabBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.all(16),
                    child: Icon(Icons.home),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.all(16),
                    child: Icon(Icons.add),
                  ),
                  label: '',
                ),
              ],
              activeColor: currentTheme.iconTheme.color,
              backgroundColor: currentTheme.dialogBackgroundColor,
              onTap: onPageChange,
              currentIndex: _pageNo,
            ),
    );
  }
}
