import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import 'like_animation.dart';

class CommentTile extends StatefulWidget {
  final snap;

  const CommentTile({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  @override
  Widget build(BuildContext context) {
    final MyUser user = Provider.of<UserProvider>(context).getUser;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(
              widget.snap["profilePic"],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snap["username"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: " ${widget.snap["comment"]}",
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(
                        widget.snap["datePosted"].toDate(),
                      ),
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            ),
          ),
          LikeAnimation(
            isAnimating: widget.snap["commentLikes"].contains(user.uid),
            smallLike: true,
            child: Container(
              padding: EdgeInsets.all(8),
              child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods().likeComment(
                      widget.snap["postId"],
                      user.uid,
                      widget.snap['commentLikes'],
                      widget.snap['commentId'],
                    );
                  },
                  icon: widget.snap["commentLikes"].contains(user.uid)
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 16,
                        )
                      : Icon(
                          Icons.favorite_border,
                          size: 16,
                        )),
            ),
          ),
        ],
      ),
    );
  }
}
