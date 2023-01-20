import 'user_model.dart';
import 'comment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const List postCategory = ["썸*연애", "19+", "블라블라", "아카데믹", "생활정보", "속보"];

class Post {
  User writer = User();
  String title = "Biden Ends Infrastructure Talks With Senate GOP Group";
  String category = "블라블라";
  String text =
      "Earth is the third planet from the Sun and the only astronomical object known to harbor life. Earth is the third planet from the Sun and the only astronomical object known to harbor life. Earth is the third planet from the Sun and the only astronomical object known to harbor life. Earth is the third planet from the Sun and the only astronomical object known to harbor life.";
  late DateTime timestamp;
  int views = 0;
  DocumentReference<Map<String, dynamic>>? firebaseDocRef;
  List<Comment> comments = [];

  Post(
      {User? postWriter,
      String? postTitle,
      String? content,
      DateTime? time,
      int? postViews,
      List<Comment>? commentList,
      DocumentReference<Map<String, dynamic>>? docRef}) {
    writer = postWriter ?? writer;
    title = postTitle ?? title;
    text = content ?? text;
    timestamp = time ?? DateTime.now();
    views = postViews ?? views;
    // comments = commentList ?? comments;

    if (commentList != null && commentList.isNotEmpty) {
      for (Comment comment in commentList) {
        comments.add(comment);
      }
    }
    firebaseDocRef = docRef;
  }

  String getWriterSchool() => writer.getSchool();

  // factory for posts
  static Future<Post> fromDocRef(
      DocumentReference<Map<String, dynamic>> firebaseDoc) async {
    DocumentSnapshot<Map<String, dynamic>> postData = await firebaseDoc.get();
    List commentList = postData.get('comments') as List;
    List<Comment> comments = [];
    if (commentList.isNotEmpty) {
      comments = await Comment.getCommentsFromFirebase(commentList, postData);
    }

    User postWriter = await User.fromUserRef(postData.get('user'));

    return Post(
        postWriter: postWriter,
        postTitle: postData.get('title'),
        content: postData.get('content'),
        time: (postData.get('time') as Timestamp).toDate(),
        postViews: postData.get('viewCount'),
        commentList: comments,
        docRef: firebaseDoc);
  }

  // factory for list of posts
  static Future<List<Post>> getPostsFromFirebase({bool popular = false}) async {
    List<Post> posts = [];
    CollectionReference<Map<String, dynamic>> postCollection =
        FirebaseFirestore.instance.collection('post');

    Query<Map<String, dynamic>> firebaseQuery;
    if (popular) {
      firebaseQuery = postCollection
          .orderBy('time', descending: true)
          .orderBy('viewCount', descending: true)
          .limit(20);
    } else {
      firebaseQuery =
          postCollection.orderBy('time', descending: true).limit(20);
    }

    QuerySnapshot<Map<String, dynamic>> firebasePosts =
        await firebaseQuery.get(const GetOptions(source: Source.cache));

    for (QueryDocumentSnapshot<Map<String, dynamic>> fbPost
        in firebasePosts.docs) {
      posts.add(await Post.fromDocRef(fbPost.reference));
    }
    return posts;
  }
}
