import 'package:flutter/material.dart';

class PostWritePage extends StatefulWidget {
  const PostWritePage({Key? key, required this.title}) : super(key: key);

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<PostWritePage> createState() => PostWritePageState();
}

class PostWritePageState extends State<PostWritePage> {
  final TextEditingController title = TextEditingController();
  final TextEditingController content = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "Category",
            ),
            Container(
              height: 50,
              child: ListView(
                itemExtent: 150,
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: const Center(
                        child: Text(
                      'Relationship',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: const Center(
                        child: Text(
                      'Just Talk',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: const Center(
                        child: Text(
                      'Academic',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text("Title"),
            TextField(
                controller: title,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Write Your Title Here",
                )),
            SizedBox(
              height: 50,
            ),
            Text("Content"),
            TextField(
                controller: content,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Write Your Contents Here",
                )),
          ],
        ),
      ),
    );
  }
}
