import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';

class PostController {
  Post post = Post();

  void incrementView() {
    post.views++;
    post.firebaseDocRef?.update({"viewCount": FieldValue.increment(1)});
    post.points++;
    post.firebaseDocRef?.update({"points": FieldValue.increment(1)});
  }

  void incrementReport() {
    post.reportCount++;
    post.firebaseDocRef?.update({"reportCount": FieldValue.increment(1)});
    post.points -= 20;
    post.firebaseDocRef?.update({"points": FieldValue.increment(-20)});
  }

  void postSave() {
    post.saveCount++;
    post.firebaseDocRef?.update({"saveCount": FieldValue.increment(1)});
    post.points += 10;
    post.firebaseDocRef?.update({"points": FieldValue.increment(10)});
  }

  void postSaveCancel() {
    post.saveCount--;
    post.firebaseDocRef?.update({"saveCount": FieldValue.increment(-1)});
    post.points -= 10;
    post.firebaseDocRef?.update({"points": FieldValue.increment(-10)});
  }

  void addComment(DocumentReference newComment) {
    post.firebaseDocRef?.update({
      'comments': FieldValue.arrayUnion([newComment])
    });
    post.commentRefs.add(newComment);
    post.points += 5;
    post.firebaseDocRef?.update({"points": FieldValue.increment(5)});
  }

  void addReport(DocumentReference newReport) {
    post.firebaseDocRef?.update({
      'reports': FieldValue.arrayUnion([newReport])
    });
  }

  // void updatePoints() {
  // int views = post.views;
  // int comments = 5 * post.numComments();
  // int save = 10 * post.saveCount;

  // int reportCount = 20 * post.reportCount;
  // int category = (post.category == '19+') ? 50 : 0;
  // Duration diff = DateTime.now().difference(post.timestamp);
  // int dayPercent = (1 - (0.01 * diff.inDays)) as int;
  // int point = (post.points) * dayPercent;

  // // int point =
  // //     ((views + comments + save) - (reportCount + category)) * dayPercent;
  // post.points = point;
  // post.firebaseDocRef?.update({"points": point});
  // }

  void lazyDeletePost() {
    post.deleted = true;
    post.firebaseDocRef?.update({'deleted': true});
  }

  PostController(this.post);

  String getPostWriterSchool() => post.getWriterSchool();
}
