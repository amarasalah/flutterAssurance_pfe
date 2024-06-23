// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:insurance_pfe/auth/login.dart';
import 'package:insurance_pfe/auth/signup.dart';
import 'package:insurance_pfe/insuranceScreens/car_insurance.dart';
import 'package:insurance_pfe/insuranceScreens/healthinsurance.dart';
import 'package:insurance_pfe/historique.dart';
import 'package:insurance_pfe/homepage.dart';
import 'package:insurance_pfe/insuranceScreens/home_insurance.dart';
import 'package:insurance_pfe/insuranceScreens/life_insurance.dart';
import 'package:insurance_pfe/nos_agences.dart';
import 'package:insurance_pfe/notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Onboboarding/onboarding_view.dart';
import 'editProfile.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('fr_FR', null);
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

class MyAppContent extends StatefulWidget {
  final bool onboarding;
  const MyAppContent({super.key, required this.onboarding});

  @override
  State<MyAppContent> createState() => _MyAppContentState();
}

class _MyAppContentState extends State<MyAppContent> {
  @override
  void initState() {
    super.initState();
    _listenToAuthState();
  }

  void _listenToAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print(
            '================================== User is currently signed out!');
      } else {
        print('================================== User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[50],
          titleTextStyle: TextStyle(
            color: Colors.orange,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.orange),
        ),
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: _determineHome(),
      routes: {
        "signup": (context) => SignUp(),
        "login": (context) => Login(),
        "homepage": (context) => Homepage(),
        "editProfile": (context) => EditProfile(),
        "nosagences": (context) => Nosagences(),
        "historique": (context) => HistoriqueScreen(),
        "health": (context) => HealthInsurance(),
        "life": (context) => LifeInsurance(),
        "home": (context) => HomeInsurance(),
        "car": (context) => CarInsurance(),
        "notifications": (context) => NotificationScreen()
      },
    );
  }

  Widget _determineHome() {
    if (!widget.onboarding) {
      return OnboardingView();
    } else {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.emailVerified) {
        return Homepage();
      } else {
        return Login();
      }
    }
  }
}
