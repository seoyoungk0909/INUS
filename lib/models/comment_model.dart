import 'user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const List commentWriter = ["Anonymous", "Writer"];

class Comment {
  bool writerFlag = false;
  String writer = "Anonymous";
  String body = "Wow that is amazing!";
  late DateTime time;
  DocumentReference<Map<String, dynamic>>? commentReference;

  Comment(
      {bool? isPostWriter,
      String? commentWriter,
      String? content,
      DateTime? timestamp,
      DocumentReference<Map<String, dynamic>>? firebaseDocRef}) {
    writerFlag = isPostWriter ?? writerFlag;
    writer = commentWriter ?? writer;
    body = content ?? body;
    time = timestamp ?? DateTime.now();
    commentReference = firebaseDocRef;
  }

  static Future<Comment> fromCommentRef(
      DocumentReference<Map<String, dynamic>> commentRef) async {
    DocumentSnapshot<Map<String, dynamic>> commentData = await commentRef.get();
    User commentWriter = await User.fromUserRef(commentData['writer']);

    return Comment(
      isPostWriter: commentData.get('writerFlag') == true
          ? true
          : false, // TODO: check writer
      commentWriter:
          commentData.get('writerFlag') == true ? "Writer" : "Anonymous",
      content: commentData.get('body'),
      timestamp: (commentData.get('time') as Timestamp).toDate(),
      firebaseDocRef: commentRef,
    );
  }

  static Future<List<Comment>> getCommentsFromFirebase(
      List<DocumentReference> commentList, DocumentSnapshot postData) async {
    List<Comment> comments = [];
    CollectionReference<Map<String, dynamic>> commentCollection =
        FirebaseFirestore.instance.collection('comments');

    Query<Map<String, dynamic>> firebaseQuery =
        commentCollection.orderBy('time', descending: true).limit(20);

    QuerySnapshot<Map<String, dynamic>> firebaseComments =
        await firebaseQuery.get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> fbComment
        in firebaseComments.docs) {
      comments.add(await Comment.fromCommentRef(fbComment.reference));
    }

    return comments;
  }
}
