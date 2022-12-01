import '../models/post_model.dart';

class PostController {
  Post post = Post();

  void incrementView() => post.views++;

  PostController(this.post);

  String getPostWriterSchool() => post.getWriterSchool();
}
