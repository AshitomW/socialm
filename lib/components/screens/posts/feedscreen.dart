import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:social/components/controllers/authcontroller.dart";
import "package:social/components/controllers/communityController.dart";
import "package:social/components/controllers/postcontroller.dart";
import "package:social/components/screens/posts/postcard.dart";
import "package:social/core/error_text.dart";
import "package:social/core/loader.dart";

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataProvider)!;
    final isGuest = !user.isAuthenticated;

    if (!isGuest) {
      return ref.watch(userCommunityProvider(user.uid)).when(
          data: (communities) {
            return ref.watch(userPostProvider(communities)).when(
                data: (posts) {
                  return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return PostCard(post: post);
                      });
                },
                error: (error, stackTrace) {
                  return ErrorText(error: error.toString());
                },
                loading: () => const Loader());
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader());
    }

    return ref.watch(guestPostProvider).when(
        data: (posts) {
          return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostCard(post: post);
              });
        },
        error: (error, stackTrace) {
          return ErrorText(error: error.toString());
        },
        loading: () => const Loader());
  }
}
