import 'user_model.dart';

const List postCategory = ["썸*연애", "19+", "블라블라", "아카데믹", "생활정보", "속보"];

class Post {
  User writer = User();
  String title = "Biden Ends Infrastructure Talks With Senate GOP Group";
  String category = "블라블라";
  String text =
      "Earth is the third planet from the Sun and the only astronomical object known to harbor life. Earth is the third planet from the Sun and the only astronomical object known to harbor life. Earth is the third planet from the Sun and the only astronomical object known to harbor life. Earth is the third planet from the Sun and the only astronomical object known to harbor life.";
  late DateTime timestamp;
  int views = 0;
  List comments = [];

  Post({User? postWriter, String? postTitle, String? content}) {
    writer = postWriter ?? writer;
    title = postTitle ?? title;
    text = content ?? text;
    timestamp = DateTime.now();
  }

  String getWriterSchool() => writer.school.toString().split('.').last;
}
