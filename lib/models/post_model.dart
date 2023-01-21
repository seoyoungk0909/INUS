import 'dart:math';

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
  List commentRefs = [];

  Post(
      {User? postWriter,
      String? postTitle,
      String? postCategory,
      String? content,
      DateTime? time,
      int? postViews,
      List<Comment>? commentList,
      List? commentRefList,
      DocumentReference<Map<String, dynamic>>? docRef}) {
    writer = postWriter ?? writer;
    title = postTitle ?? title;
    category = postCategory ?? category;
    text = content ?? text;
    timestamp = time ?? DateTime.now();
    views = postViews ?? views;
    commentRefs = commentRefList ?? commentRefs;
    // comments = commentList ?? comments;

    if (commentList != null && commentList.isNotEmpty) {
      for (Comment comment in commentList) {
        comments.add(comment);
      }
    }
    firebaseDocRef = docRef;
  }

  String getWriterSchool() => writer.getSchool();

  int numComments() => max(comments.length, commentRefs.length);

  // factory for posts
  static Future<Post> fromDocRef(
      {DocumentReference<Map<String, dynamic>>? firebaseDoc,
      QueryDocumentSnapshot<Map<String, dynamic>>? firebaseSnap,
      bool lazyLoadComment = true}) async {
    DocumentSnapshot<Map<String, dynamic>> postData;

    if (firebaseSnap == null) {
      assert(firebaseDoc != null);
      postData = await firebaseDoc!.get();
    } else {
      postData = firebaseSnap;
      firebaseDoc ??= postData.reference;
    }

    List commentRefList = postData.get('comments') as List;
    List<Comment> comments = [];
    if (!lazyLoadComment && commentRefList.isNotEmpty) {
      comments =
          await Comment.getCommentsFromFirebase(commentRefList, postData);
    }

    User postWriter = await User.fromUserRef(postData.get('user'));

    return Post(
        postWriter: postWriter,
        postTitle: postData.get('title'),
        postCategory: postData.get('category'),
        content: postData.get('content'),
        time: (postData.get('time') as Timestamp).toDate(),
        postViews: postData.get('viewCount'),
        commentList: comments,
        commentRefList: commentRefList,
        docRef: firebaseDoc);
  }

  Future<bool> loadComments() async {
    if (commentRefs.isNotEmpty && firebaseDocRef != null) {
      DocumentSnapshot<Map<String, dynamic>> postData =
          await firebaseDocRef!.get();
      comments = await Comment.getCommentsFromFirebase(commentRefs, postData);
      return true;
    }
    return false;
  }

  // factory for list of posts
  static Future<List<Post>> getPostsFromFirebase({bool popular = false}) async {
    List<Post> posts = [];
    Query<Map<String, dynamic>> firebaseQuery = getPostsQuery(popular: popular);

    QuerySnapshot<Map<String, dynamic>> firebasePosts =
        await firebaseQuery.get(const GetOptions(source: Source.cache));

    for (QueryDocumentSnapshot<Map<String, dynamic>> fbPost
        in firebasePosts.docs) {
      posts.add(await Post.fromDocRef(firebaseDoc: fbPost.reference));
    }
    return posts;
  }

  static Query<Map<String, dynamic>> getPostsQuery({bool popular = false}) {
    CollectionReference<Map<String, dynamic>> postCollection =
        FirebaseFirestore.instance.collection('post');
    Query<Map<String, dynamic>> firebaseQuery =
        postCollection.orderBy('time', descending: true).limit(20);
    if (popular) {
      firebaseQuery = firebaseQuery.orderBy('viewCount', descending: true);
    }
    return firebaseQuery;
  }
}
