import 'package:flutter/material.dart';

class CommentBox extends StatefulWidget {
  @override
  CommentBoxState createState() => CommentBoxState();
}

class CommentBoxState extends State<CommentBox> {
  var userEnterMessage = '';

  @override
  Widget build(BuildContext context) {
    return Container(
        // margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  // labelText: 'Write your comment',
                  hintText: 'Write your comment',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    userEnterMessage = value;
                  });
                },
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(primary: Colors.blue),
              onPressed: userEnterMessage.trim().isEmpty ? null : () {},
              child: Text("Post"),
            ),
            // IconButton(
            //   onPressed: userEnterMessage.trim().isEmpty ? null : () {},
            //   icon: Icon(Icons.send),
            //   color: Colors.blue,
            // ),
          ],
        ));
  }
}
