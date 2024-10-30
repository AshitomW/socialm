import "package:routemaster/routemaster.dart";
import "package:social/components/screens/community/addmoderatorscreen.dart";
import "package:social/components/screens/community/community_profile.dart";
import "package:social/components/screens/community/create_community.dart";
import "package:social/components/screens/community/edit_community.dart";
import "package:social/components/screens/community/mod_tools.dart";
import "package:social/components/screens/home/homescreen.dart";
import "package:social/components/screens/auth/startuplogin.dart";
import "package:flutter/material.dart";
import "package:social/components/screens/userprofile/userprofilescreen.dart";

final loggedOutRoute = RouteMap(routes: {
  "/": (_) => const MaterialPage(child: Startuplogin()),
});

final loggedInRoute = RouteMap(
  routes: {
    "/": (_) => const MaterialPage(child: HomeScreen()),
    "/create_community": (_) => const MaterialPage(child: CreateCommunity()),
    "/r/:name": (route) => MaterialPage(
          child: CommunityProfile(name: route.pathParameters["name"]!),
        ),
    "/modtools/:name": (route) => MaterialPage(
          child: ModToolsScreen(name: route.pathParameters["name"]!),
        ),
    "/editcommunity/:name": (route) => MaterialPage(
          child: EditCommunityScreen(name: route.pathParameters["name"]!),
        ),
    "/add-mod/:name": (route) => MaterialPage(
          child: AddModScreen(communityName: route.pathParameters["name"]!),
        ),
    "/u/:uid": (route) => MaterialPage(
          child: UserProfileScreen(uid: route.pathParameters["uid"]!),
        ),
  },
);
