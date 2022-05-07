import 'package:flutter/material.dart';
import 'package:lichi_test/src/authentication/authentication_service.dart';
import 'package:provider/provider.dart';
import 'src/authentication/authentification_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthenticationService>(
        create: (_) => AuthenticationService(FirebaseAuth.instance),
    ),
          
          StreamProvider(
              create: (context) => context.read<AuthenticationService>().authStateChanges,
              initialData: null)
        ],
    child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: AuthenticationWrapper(),
    ));
  }
}
