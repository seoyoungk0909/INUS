import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';

class PostController {
  Post post = Post();

  void incrementView() {
    post.views++;
    post.firebaseDocRef?.update({"viewCount": FieldValue.increment(1)});
  }

  PostController(this.post);

  String getPostWriterSchool() => post.getWriterSchool();
}
