import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/global_variables.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MediaQuery.of(context).size.width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
        title: const Text("Activity", style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: const Center(
        child: Text("Notifications will come soon..."),
      ),
    );
  }
}
