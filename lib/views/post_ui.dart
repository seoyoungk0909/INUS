import 'package:flutter/material.dart';
import '../controllers/post_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

Widget postListView(List<Widget> children) {
  return SingleChildScrollView(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    ),
  );
}

Widget postUI(BuildContext context, PostController controller,
    {Function? setState}) {
  return Container(
    decoration: BoxDecoration(color: Theme.of(context).cardColor),
    margin: EdgeInsets.symmetric(
      vertical: 20,
      horizontal: MediaQuery.of(context).size.width * 0.05,
    ),
    child: Column(
      children: [
        contentUI(context, controller),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () {
                if (setState != null) {
                  setState(controller.incrementLike);
                } else {
                  controller.incrementLike;
                }
              },
              heroTag: null,
              child: const Icon(Icons.favorite),
            ),
            const SizedBox(width: 10),
            Text('${controller.post.likes}'),
          ],
        ),
      ],
    ),
  );
}

Widget contentUI(BuildContext context, PostController controller) {
  return GestureDetector(
    onTap: () => Navigator.pushNamed(context, 'post_detail',
        arguments: {'post': controller.post}),
    child: Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Text(
            timeago.format(DateTime.now().subtract(
                DateTime.now().difference(controller.post.timestamp))),
            style: const TextStyle(fontSize: 12),
          ),
        ),
        //title
        Text(
          controller.post.title,
          style: const TextStyle(fontSize: 24),
        ),
        Text(
            '${controller.post.writer.name}, ${controller.getPostWriterSchool()}'),
        const Divider(),
        //main content
        Text(
          controller.post.text,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    ),
  );
}
