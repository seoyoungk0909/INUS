import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../controllers/post_controller.dart';
import '../models/comment_model.dart';
import '../models/post_model.dart';
import '../utils/color_utils.dart';
import 'components/post_ui.dart';
import 'components/comment_ui.dart';
import 'components/comment_box.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({Key? key, required this.title}) : super(key: key);

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<PostDetailPage> createState() => PostDetailPageState();
}

class PostDetailPageState extends State<PostDetailPage> {
  Future<List<Comment>> getCommentsFromRefs(commentRefs) async {
    List<Comment> comments = [];
    for (DocumentReference<Map<String, dynamic>> ref in commentRefs) {
      comments.add(await Comment.fromCommentRef(ref));
    }
    return comments;
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    PostController controller = PostController(arguments['post'] ?? Post());
    bool saved = arguments['saved'] ?? false;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0.0,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'report',
                      arguments: {'post': controller.post});
                },
                icon: SvgPicture.asset('assets/icons/Report.svg'))
          ],
        ),
        body: Column(
          children: [
            // post detail
            Expanded(
              child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      PostUI(
                          controller: controller, isDetail: true, saved: saved),
                      // comment list
                      // Expanded(
                      StreamBuilder(
                        stream: controller.post.firebaseDocRef?.snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<
                                    DocumentSnapshot<Map<String, dynamic>>>
                                snap) {
                          if (snap.data == null) {
                            return Center(
                                child: CircularProgressIndicator(
                                    color: ApdiColors.themeGreen));
                          }
                          List commentRefs = snap.data!.get('comments');
                          if (commentRefs.isEmpty) {
                            return const Padding(
                                padding: EdgeInsets.only(top: 40),
                                child: Center(child: Text("No Comments")));
                          }
                          return FutureBuilder(
                              future: getCommentsFromRefs(commentRefs),
                              builder: (context,
                                  AsyncSnapshot<List<Comment>> snapshot) {
                                if (snapshot.data == null) {
                                  return const SizedBox
                                      .shrink(); // empty widget
                                }
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, idx) {
                                    return CommentUI(
                                        snapshot.data![idx], context,
                                        first: idx == 0);
                                  },
                                );
                              });
                        },
                      ),
                    ],
                  )),
            ),

            // comment write
            CommentBox(controller: controller),
          ],
        ),
      ),
    );
  }
}
