import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          postUI(context, controller, isDetail: true),
          controller.post.comments.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                      itemCount: controller.post.comments.length,
                      itemBuilder: (context, idx) {
                        return CommentUI(controller.post.comments[idx]);
                      }))
              : const Padding(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Center(child: Text("No Comments"))),
        ],
      ),
    );
  }
}
