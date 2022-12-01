import 'package:flutter/material.dart';
import '../controllers/post_controller.dart';
import '../models/post_model.dart';

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
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(controller.post.text),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("views • "),
                Text(controller.post.views.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
