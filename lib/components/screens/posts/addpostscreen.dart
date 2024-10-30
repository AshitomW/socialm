import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:social/themes/themehandler.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigateToPostType(BuildContext context, String type) {
    Routemaster.of(context).push("/post/$type");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double cardDimension = 120;
    const double iconSize = 60;
    final currentTheme = ref.watch(themeDataProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              navigateToPostType(context, "Image");
            },
            child: SizedBox(
              width: cardDimension,
              height: cardDimension,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 16,
                color: currentTheme.canvasColor,
                child: const Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: iconSize,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              navigateToPostType(context, "Text");
            },
            child: SizedBox(
              width: cardDimension,
              height: cardDimension,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 16,
                color: currentTheme.canvasColor,
                child: const Center(
                  child: Icon(
                    Icons.font_download,
                    size: iconSize,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              navigateToPostType(context, "Link");
            },
            child: SizedBox(
              width: cardDimension,
              height: cardDimension,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 16,
                color: currentTheme.canvasColor,
                child: const Center(
                  child: Icon(
                    Icons.link_outlined,
                    size: iconSize,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
