import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/search_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../utils/colors.dart';
import '../utils/global_variables.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 35,
          child: TextField(
            readOnly: true,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              fillColor: Colors.white.withOpacity(0.2),
              prefixIcon: Icon(
                Icons.search,
                color: primaryColor,
              ),
              hintText: 'Search',
              hintStyle: TextStyle(fontSize: 18),
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection("posts").get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // return StaggeredGridView.countBuilder(
          //   crossAxisCount: 3,
          //   itemCount: (snapshot.data! as dynamic).docs.length,
          //   itemBuilder: (context, index) => Image.network(
          //     (snapshot.data! as dynamic).docs[index]["postUrl"],
          //   ),
          //   staggeredTileBuilder: (index) =>
          //   MediaQuery
          //       .of(context)
          //       .size
          //       .width > webScreenSize ? StaggeredTile.count(
          //     (index % 7 == 0) ? 1 : 1,
          //     (index % 7 == 0) ? 1 : 1,
          //   ) :StaggeredTile.count(
          //     (index % 7 == 0) ? 2 : 1,
          //     (index % 7 == 0) ? 2 : 1,
          //   ),
          //   mainAxisSpacing: 2,
          //   crossAxisSpacing: 2,
          // );

          return GridView.builder(
            padding: MediaQuery.of(context).size.width > webScreenSize
                ? const EdgeInsets.symmetric(horizontal: 16)
                : null,
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: (snapshot.data! as dynamic).docs.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              DocumentSnapshot snap =
              (snapshot.data! as dynamic).docs[index];
              return Image.network(
                snap["postUrl"],
                fit: BoxFit.cover,
              );
            },
          );
        },
      ),
    );
  }
}
