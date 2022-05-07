import 'package:flutter/material.dart';
import 'package:lichi_test/src/pages/user_page.dart';

import 'news_page.dart';


class HomeTabPage extends StatelessWidget {
  const HomeTabPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            bottom: const TabBar(
              labelStyle: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
              indicatorColor: Colors.black,
              tabs: [Tab(text: "News",), Tab(text: "Profile")],
            ),
            backgroundColor: Colors.grey,
            title: const Text("Hello!",
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.black,
              ),),
        ),
        backgroundColor: Colors.grey,
        body: const TabBarView(
          children: [
            NewsPage(),
            UserPage(),
          ],
        ),
      ),
    );
  }
}
