import 'package:flutter/material.dart';
import 'package:lichi_test/src/authentication/authentication_service.dart';
import 'package:lichi_test/src/pages/register_page.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign in"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              width: 150,
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  labelText: "Email",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              width: 150,
              child: TextField(
                controller: passwordController,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  labelText: "Password",
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<AuthenticationService>().signIn(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );
              },
              child: const Text("Sign in")
            ),
            ElevatedButton(
                onPressed: () => Navigator.push(context,
        MaterialPageRoute(builder: (context) => const RegisterPage())),
                child: const Text("Register"),
            ),

          ],
        ),
      )
    );
  }
}