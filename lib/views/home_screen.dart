import 'package:flutter/material.dart';
import '../controllers/post_controller.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  PostController controller1 = PostController(Post(
    postWriter: User(userName: "John Doe", userSchool: School.HKUST),
  ));
  PostController controller2 = PostController(
      Post(postWriter: User(userName: "Apple Seed", userSchool: School.CUHK)));

  Widget postUI(PostController controller) {
    return Container(
        decoration: BoxDecoration(color: Colors.blue[50]),
        margin: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: MediaQuery.of(context).size.width * 0.05,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Text(
                controller.post.timestamp.toString(),
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
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      controller.incrementLike();
                    });
                  },
                  heroTag: null,
                  child: const Icon(Icons.favorite),
                ),
                const SizedBox(width: 10),
                Text('${controller.post.likes}'),
              ],
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the PostListPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'login');
              },
              icon: const Icon(Icons.person))
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              postUI(controller1),
              postUI(controller2),
            ],
          ),
        ),
      ),
    );
  }
}
