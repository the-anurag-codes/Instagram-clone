import 'dart:typed_data';

import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Upload post
  Future<String> uploadPost(
    String caption,
    Uint8List file,
    String username,
    String uid,
    String profImage,
  ) async {
    String res = "Some error occurred";

    try {
      String postUrl = await StorageMethods().uploadImageToStorage(
        'posts',
        file,
        true,
      );

      String postId = Uuid().v1();

      Post post = Post(
        caption: caption,
        uid: uid,
        postId: postId,
        username: username,
        postUrl: postUrl,
        datePublished: DateTime.now(),
        profImage: profImage,
        likes: [],
      );

      _firestore.collection("posts").doc(postId).set(post.toJson());
      res = "Success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (!likes.contains(uid)) {
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> dislikePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayRemove([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComment(
    String comment,
    String uid,
    String postId,
    String profilePic,
    String username,
  ) async {
    try {
      if (comment.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection("posts")
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          "comment": comment,
          "uid": uid,
          "username": username,
          "profilePic": profilePic,
          "commentId": commentId,
          "postId": postId,
          "datePosted": DateTime.now(),
          "commentLikes": [],
        });
      } else {
        print("Comment is empty");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> likeComment(
      String postId, String uid, List commentLikes, String commentId) async {
    try {
      if (commentLikes.contains(uid)) {
        await _firestore
            .collection("posts")
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update(
          {
            "commentLikes": FieldValue.arrayRemove([uid]),
          },
        );
      } else{
        await _firestore
            .collection("posts")
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update(
          {
            "commentLikes": FieldValue.arrayUnion([uid]),
          },
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId) async{
    try {
      await _firestore.collection("posts").doc(postId).delete();
    } catch(e){
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async{
    try {
      DocumentSnapshot snap = await _firestore.collection("users").doc(uid).get();
      List following = (snap.data()! as dynamic)["following"];

      if(following.contains(followId)){
        await _firestore.collection("users").doc(followId).update({
          "followers": FieldValue.arrayRemove([uid]),
        });

        await _firestore.collection("users").doc(uid).update({
          "following": FieldValue.arrayRemove([followId]),
        });
      } else {
        await _firestore.collection("users").doc(followId).update({
          "followers": FieldValue.arrayUnion([uid]),
        });

        await _firestore.collection("users").doc(uid).update({
          "following": FieldValue.arrayUnion([followId]),
        });
      }

    } catch(e){
      print(e.toString());
    }
  }
}
