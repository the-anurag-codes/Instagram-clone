import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../screens/comments_screen.dart';
import '../utils/global_variables.dart';
import 'like_animation.dart';

class PostCard extends StatefulWidget {
  final snap;

  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore
          .instance
          .collection("posts")
          .doc(widget.snap["postId"])
          .collection("comments")
          .get();
      commentLen = snap.docs.length;
    } catch(e){
      showSnakBar(e.toString(), context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final MyUser user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    return Container(
      // Boundary needed for web
      decoration: BoxDecoration(
        border: Border.all(
          color: width > webScreenSize ? Colors.white.withOpacity(0.2) : mobileBackgroundColor,
        ),
        color: mobileBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          // HEADER Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                              child: ListView(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shrinkWrap: true,
                                children: ["Delete",]
                                    .map((e) => InkWell(
                                          onTap: () async{
                                            await FirestoreMethods().deletePost(widget.snap["postId"]);
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            child: Text(e),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ));
                  },
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
          ),

          // IMAGE Section
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                widget.snap["postId"],
                user.uid,
                widget.snap['likes'],
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'],
                    fit: BoxFit.contain,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 100,
                      shadows: [
                        Shadow(
                            color: Colors.black,
                            blurRadius: 0.4,
                            offset: Offset.zero),
                      ],
                    ),
                    duration: const Duration(milliseconds: 400),
                    isAnimating: isLikeAnimating,
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                )
              ],
            ),
          ),

          // LIKE COMMENT Section
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap["likes"].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    widget.snap["likes"].contains(user.uid)
                        ? await FirestoreMethods().dislikePost(
                            widget.snap["postId"],
                            user.uid,
                            widget.snap['likes'],
                          )
                        : await FirestoreMethods().likePost(
                            widget.snap["postId"],
                            user.uid,
                            widget.snap['likes'],
                          );
                  },
                  icon: widget.snap["likes"].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                        ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentScreen(
                        snap: widget.snap,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
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
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_border),
                  ),
                ),
              ),
            ],
          ),

          // DESCRIPTION Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.bold),
                  child: Text(
                    "${widget.snap['likes'].length} likes",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 8),
                  width: double.infinity,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: widget.snap["username"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: " ${widget.snap["caption"]}",
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'View all ${commentLen} comments',
                      style: TextStyle(color: secondaryColor, fontSize: 16),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 2, bottom: 4),
                  child: Text(
                    DateFormat.yMMMd().format(
                      widget.snap["datePublished"].toDate(),
                    ),
                    style: TextStyle(color: secondaryColor, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
