import 'package:aus/views/comment_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../controllers/post_controller.dart';
import '../models/post_model.dart';
import 'post_ui.dart';
import 'comment_ui.dart';

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
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    PostController controller = PostController(arguments['post'] ?? Post());
    bool saved = arguments['saved'] ?? false;

    if (controller.post.comments.length != controller.post.commentRefs.length) {
      controller.post.loadComments();
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {},
              icon: SvgPicture.asset('assets/icons/Report.svg'))
        ],
      ),
      body: Column(
        children: [
          postUI(context, controller, isDetail: true, saved: saved),
          Expanded(
            child: FutureBuilder(
              future: controller.post.loadComments(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }
                return controller.post.comments.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                            itemCount: controller.post.comments.length,
                            itemBuilder: (context, idx) {
                              return CommentUI(controller.post.comments[idx]);
                            }))
                    : const Padding(
                        padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                        child: Center(child: Text("No Comments")));
              },
            ),
          ),
          CommentBox(),
        ],
      ),
    );
  }
}
