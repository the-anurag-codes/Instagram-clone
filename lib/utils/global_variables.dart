import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/explore_screen.dart';
import 'package:instagram_clone/screens/notification_screen.dart';
import '../screens/feed_screen.dart';
import '../screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

const webScreenSize = 600;

List<Widget> navigationItems = [
    const FeedScreen(),
    const ExploreScreen(),
    const AddPostScreen(),
    const NotificationScreen(),
    ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,),
];