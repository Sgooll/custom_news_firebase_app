import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lichi_test/src/pages/sign_in_page.dart';
import 'package:lichi_test/src/pages/tab_home_page.dart';
import 'package:provider/provider.dart';


class AuthenticationWrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final fireBaseUser = context.watch<User?>();

    if(fireBaseUser != null){
      return const HomeTabPage();
    }
    return SignInPage();
  }
}