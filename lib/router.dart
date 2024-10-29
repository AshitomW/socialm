import "package:routemaster/routemaster.dart";
import "package:social/components/screens/community/create_community.dart";
import "package:social/components/screens/home/homescreen.dart";
import "package:social/components/screens/auth/startuplogin.dart";
import "package:flutter/material.dart";

final loggedOutRoute = RouteMap(routes: {
  "/": (_) => const MaterialPage(child: Startuplogin()),
});

final loggedInRoute = RouteMap(routes: {
  "/": (_) => const MaterialPage(child: HomeScreen()),
  "/create_community": (_) => const MaterialPage(child: CreateCommunity()),
});
