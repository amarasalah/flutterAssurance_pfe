import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// import 'package:insurance_pfe/auth/signup.dart';
import 'package:insurance_pfe/views/editProfile.dart';

import 'package:insurance_pfe/views/homepage.dart';
import 'package:insurance_pfe/views/auth/login.dart';
import 'package:insurance_pfe/views/auth/signup.dart';
// import 'package:insurance_pfe/views/auth/login.dart';

import 'package:insurance_pfe/views/root_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/Onboboarding/onboarding_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text("Error initializing app"),
              ),
            ),
          );
        } else {
          final onboarding = snapshot.data as bool;
          return MyAppContent(onboarding: onboarding);
        }
      },
    );
  }

  Future<bool> _initializeApp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("onboarding") ?? false;
  }
}

class MyAppContent extends StatelessWidget {
  final bool onboarding;

  const MyAppContent({Key? key, required this.onboarding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: Text("Error: ${snapshot.error}")),
            ),
          );
        } else {
          if (!onboarding) {
            return MaterialApp(
              home: OnboardingView(),
              debugShowCheckedModeBanner: false,
            );
          } else if (snapshot.hasData && snapshot.data!.emailVerified) {
            return MaterialApp(
              home: RootScreen(),
              debugShowCheckedModeBanner: false,
            );
          } else {
            return MaterialApp(
              home: Login(),
              debugShowCheckedModeBanner: false,
            );
          }
        }
      },
    );
  }
}
