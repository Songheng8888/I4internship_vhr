import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vhr_project/firebase_options.dart';
import 'package:vhr_project/login_page/login_screen.dart';
import 'package:vhr_project/user_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Firebase.initializeApp();

  // WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text(
                'Welcome to VHR',
                style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      } else if (snapshot.hasError) {}
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VHR Clone App',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          primarySwatch: Colors.blue,
        ),
        home: UserState(),
      );
    });
  }
}
