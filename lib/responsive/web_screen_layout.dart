import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/colors.dart';
import '../utils/global_variables.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page){
    pageController.jumpToPage(page);
    setState(() {
      _page = page;
    });
  }

  void onPageChanged(int page){
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.only(bottom: 8),
            onPressed: () => navigationTapped(0),
            icon: Icon(
              Icons.home,
              size: 26,
              color: _page == 0? primaryColor : secondaryColor,
            ),
          ),
          IconButton(
            padding: EdgeInsets.only(bottom: 8),
            onPressed: () => navigationTapped(1),
            icon: Icon(
              Icons.search,
              size: 26,
              color: _page == 1? primaryColor : secondaryColor,
            ),
          ),
          IconButton(
            padding: EdgeInsets.only(bottom: 8),
            onPressed: () => navigationTapped(2),
            icon: Icon(
              Icons.add_a_photo,
              size: 26,
              color: _page == 2? primaryColor : secondaryColor,
            ),
          ),
          IconButton(
            padding: EdgeInsets.only(bottom: 8),
            onPressed: () => navigationTapped(3),
            icon: Icon(
              Icons.favorite,
              size: 26,
              color: _page == 3? primaryColor : secondaryColor,
            ),
          ),
          IconButton(
            padding: EdgeInsets.only(bottom: 8, right: 8),
            onPressed: () => navigationTapped(4),
            icon: Icon(
              Icons.person,
              size: 26,
              color: _page == 4? primaryColor : secondaryColor,
            ),
          )
        ],
      ),
      body: PageView(
        children: navigationItems,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
    );
  }
}
