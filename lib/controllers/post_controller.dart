import '../models/post_model.dart';

class PostController {
  Post post = Post();

  void incrementLike() => post.likes++;
  void decrementLike() {
    post.likes--;
    if (post.likes < 0) post.likes = 0;
  }

  PostController(this.post);

  String getPostWriterSchool() => post.getWriterSchool();
}
