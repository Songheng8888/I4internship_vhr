import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vhr_project/jobs/jobs_screen.dart';
import 'package:vhr_project/login_page/login_screen.dart';

class UserState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.data == null) {
            print('user is not logged in yet');
            return Login();
          } else if (userSnapshot.hasData) {
            print('user is already logged in yet');
            return JobScreen();
          } else if (userSnapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text(
                  'An error has been occurred. Try again later',
                ),
              ),
            );
          } else if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: Text(
                'Someting went wrong',
              ),
            ),
          );
        },
      );
  }
}
