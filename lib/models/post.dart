import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String caption;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  Post({
    required this.caption,
    required this.uid,
    required this.postId,
    required this.username,
    required this.postUrl,
    required this.datePublished,
    required this.profImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
    "username": username,
    "uid": uid,
    "caption": caption,
    "postId": postId,
    "postUrl": postUrl,
    "datePublished": datePublished,
    "profImage": profImage,
    "likes": likes,
  };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    print(snapshot);

    return Post(
      postId: snapshot["postId"],
      uid: snapshot["uid"],
      caption: snapshot["caption"],
      postUrl: snapshot["postUrl"]!,
      username: snapshot["username"],
      datePublished: snapshot["datePublished"],
      profImage: snapshot["profImage"],
      likes: snapshot["likes"],
    );
  }
}
