import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:social/components/controllers/authcontroller.dart";
import "package:social/components/controllers/communityController.dart";
import "package:social/core/error_text.dart";
import "package:social/core/loader.dart";

class AddModScreen extends ConsumerStatefulWidget {
  final String communityName;
  const AddModScreen({super.key, required this.communityName});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModScreenState();
}

class _AddModScreenState extends ConsumerState<AddModScreen> {
  Set<String> modUids = {};
  bool initalizeMod = true;
  void addUid(String uid) {
    setState(() {
      modUids.add(uid);
    });
  }

  void removeUid(String uid) {
    setState(() {
      modUids.remove(uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.communityName)).when(
          data: (community) => ListView.builder(
              itemCount: community.members.length,
              itemBuilder: (context, index) {
                final member = community.members[index];

                return ref.watch(getUserDataProvider(member)).when(
                    data: (user) {
                      if (community.moderators.contains(member) && initalizeMod) {
                        modUids.add(member);
                      }
                      initalizeMod = false;
                      return CheckboxListTile(
                        value: modUids.contains(user.uid),
                        onChanged: (val) {
                          if (val!) {
                            addUid(user.uid);
                          } else {
                            removeUid(user.uid);
                          }
                        },
                        title: Text(user.name),
                      );
                    },
                    error: (error, stackTrace) => ErrorText(error: error.toString()),
                    loading: () => const Loader());
              }),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
