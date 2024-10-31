import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:social/components/controllers/authcontroller.dart";
import "package:social/components/controllers/postcontroller.dart";
import "package:social/components/model/postmodel.dart";
import "package:social/components/screens/posts/postcard.dart";
import "package:social/components/widgets/commentcard.dart";
import "package:social/core/error_text.dart";
import "package:social/core/loader.dart";
import "package:social/themes/themehandler.dart";

class CommentScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentScreen({super.key, required this.postId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void addComment(Post post) {
    ref
        .read(postControllerProvider.notifier)
        .addComment(context: context, text: commentController.text.trim(), post: post);

    setState(() {
      commentController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeDataProvider);
    final user = ref.watch(userDataProvider)!;
    final isGuest = !user.isAuthenticated;
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
          data: (post) {
            return Column(
              children: [
                PostCard(post: post),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  enabled: isGuest ? false : true,
                  onSubmitted: (val) => addComment(post),
                  controller: commentController,
                  maxLength: 50,
                  decoration: InputDecoration(
                    hintText: isGuest ? "Sign In To Comment" : "Enter Title Here",
                    fillColor: currentTheme.canvasColor,
                    filled: true,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(18),
                  ),
                ),
                ref.watch(getPostCommentProvider(widget.postId)).when(
                    data: (comments) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (BuildContext context, int index) {
                            final comment = comments[index];
                            return Commentcard(comment: comment);
                          },
                        ),
                      );
                    },
                    error: (error, stackTrace) {
                      return ErrorText(error: error.toString());
                    },
                    loading: () => const Loader())
              ],
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
