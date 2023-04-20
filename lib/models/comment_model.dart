import 'package:cloud_firestore/cloud_firestore.dart';

const List commentWriter = ["Anonymous", "Writer"];

class Comment {
  bool writerFlag = false;
  // User writer = User();
  String body = "Wow that is amazing!";
  late DateTime time;
  DocumentReference<Map<String, dynamic>>? commentReference;
  DocumentReference<Map<String, dynamic>>? writerReference;
  bool deleted = false;
  final String deletedMessage = "This message was deleted";

  Comment(
      {bool? isPostWriter,
      String? content,
      DateTime? timestamp,
      DocumentReference<Map<String, dynamic>>? firebaseDocRef,
      DocumentReference<Map<String, dynamic>>? writerRef,
      bool? commentDeleted}) {
    writerFlag = isPostWriter ?? writerFlag;
    body = content ?? body;
    time = timestamp ?? DateTime.now();
    commentReference = firebaseDocRef;
    writerReference = writerRef;
    deleted = commentDeleted ?? deleted;
  }

  String writerToString() => writerFlag ? "Writer" : "Anonymous";

  static Future<Comment> fromCommentRef(
      DocumentReference<Map<String, dynamic>> commentRef) async {
    DocumentSnapshot<Map<String, dynamic>> commentData = await commentRef.get();

    bool deleted = false;
    DocumentReference<Map<String, dynamic>>? writerRef;
    try {
      deleted = commentData.get('deleted');
      writerRef = commentData.get('writer');
    } catch (e) {}

    return Comment(
      isPostWriter: commentData.get('writerFlag'),
      content: commentData.get('body'),
      timestamp: (commentData.get('time') as Timestamp).toDate(),
      firebaseDocRef: commentRef,
      commentDeleted: deleted,
      writerRef: writerRef,
    );
  }

  static Future<List<Comment>> getCommentsFromFirebase(
      List commentList, DocumentSnapshot postData) async {
    List<Comment> comments = [];
    for (DocumentReference<Map<String, dynamic>> commentRef in commentList) {
      comments.add(await Comment.fromCommentRef(commentRef));
    }
    // CollectionReference<Map<String, dynamic>> commentCollection =
    //     FirebaseFirestore.instance.collection('post_comment');

    // Query<Map<String, dynamic>> firebaseQuery =
    //     commentCollection.orderBy('time', descending: true).limit(20);

    // QuerySnapshot<Map<String, dynamic>> firebaseComments =
    //     await firebaseQuery.get();

    // for (QueryDocumentSnapshot<Map<String, dynamic>> fbComment
    //     in firebaseComments.docs) {
    //   comments.add(await Comment.fromCommentRef(fbComment.reference));
    // }

    return comments;
  }
}
