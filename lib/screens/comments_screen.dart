import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/colors.dart';
import '../widgets/comment_tile.dart';

class CommentScreen extends StatefulWidget {
  final snap;

  const CommentScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MyUser user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: mobileBackgroundColor,
        title: const Text("Comments", style: TextStyle(fontWeight: FontWeight.bold),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          RotationTransition(
            turns: const AlwaysStoppedAnimation(-25 / 360),
            child: IconButton(
              padding: const EdgeInsets.only(bottom: 8),
              onPressed: () {},
              icon: const Icon(
                Icons.send,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .doc(widget.snap["postId"])
            .collection("comments").orderBy('datePosted', descending: true,)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => CommentTile(snap: snapshot.data!.docs[index].data(),),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(user.photoUrl),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: "Add a comment...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await FirestoreMethods().postComment(
                  _commentController.text,
                  user.uid,
                  widget.snap["postId"],
                  user.photoUrl,
                  user.username,
                );
                setState(() {
                  _commentController.text = '';
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Text(
                  'Post',
                  style: TextStyle(
                    color: blueColor.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
