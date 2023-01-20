import 'user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const List commentWriter = ["Anonymous", "Writer"];

class Comment {
  bool writerFlag = false;
  // User writer = User();
  String body = "Wow that is amazing!";
  late DateTime time;
  DocumentReference<Map<String, dynamic>>? commentReference;

  Comment(
      {bool? isPostWriter,
      String? content,
      DateTime? timestamp,
      DocumentReference<Map<String, dynamic>>? firebaseDocRef}) {
    writerFlag = isPostWriter ?? writerFlag;
    body = content ?? body;
    time = timestamp ?? DateTime.now();
    commentReference = firebaseDocRef;
  }

  String writerToString() => writerFlag ? "Writer" : "Anonymous";

  static Future<Comment> fromCommentRef(
      DocumentReference<Map<String, dynamic>> commentRef) async {
    DocumentSnapshot<Map<String, dynamic>> commentData = await commentRef.get();

    return Comment(
      isPostWriter: commentData.get('writerFlag'),
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
