import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../services/notification_service.dart';

class HealthInsuranceController {
  late PageController pageController;
  int currentPage = 0;
  Map<String, dynamic> formData = {};

  // Controllers for form inputs
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  late String selectedOption = 'Celibataire';

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  HealthInsuranceController() {
    pageController = PageController();
    _initializeLocalNotifications();
    _requestPermission();
    _setupFirebaseMessagingListeners();
  }

  void dispose() {
    pageController.dispose();
    nameController.dispose();
    ageController.dispose();
    birthDateController.dispose();
  }

  void _requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void _initializeLocalNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _setupFirebaseMessagingListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _saveNotificationToFirestore(message);
      NotificationService.showNotification(
          flutterLocalNotificationsPlugin, message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _saveNotificationToFirestore(message);
      NotificationService.showNotification(
          flutterLocalNotificationsPlugin, message);
    });
  }

  Future<void> _saveNotificationToFirestore(RemoteMessage message) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('notifications').add({
          'userId': user.uid,
          'title': message.notification?.title ?? 'No title',
          'body': message.notification?.body ?? 'No body',
          'timestamp': Timestamp.now(),
          'icon': 'notifications',
          'color': 'blue',
          'isRead': false,
          'status': 'new',
        });
      } catch (e) {
        print("Error saving notification to Firestore: $e");
      }
    } else {
      print("No user is logged in");
    }
  }

  void nextPage() {
    if (currentPage < 4) {
      currentPage++;
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      submitData();
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      currentPage--;
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  int calculateTotal() {
    int total = 0;
    total += (formData['is_student_score'] ?? 0) as int;
    total += (formData['has_children_score'] ?? 0) as int;
    total += 100; // Assuming the third step is always worth 100
    total += 100; // Assuming the fourth step is always worth 100
    return total;
  }

  void submitData() async {
    formData['name'] = nameController.text;
    formData['age'] = ageController.text;
    formData['selectedOption'] = selectedOption;
    formData['is_student'] = formData['is_student'] ?? 'N/A';
    formData['has_children'] = formData['has_children'] ?? 'N/A';
    formData['birthDate'] = birthDateController.text;
    formData['total'] = calculateTotal();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('responses').add({
          'userId': user.uid,
          'data': formData,
          'timestamp': Timestamp.now(),
          'type': 'maladie',
          "addedDate": Timestamp.now(),
          "expiryDate": Timestamp.now(),
          "price": formData['total'],
        });

        RemoteMessage dummyMessage = RemoteMessage(
          notification: RemoteNotification(
            title: 'Submission Successful',
            body: 'Your data has been successfully submitted.',
          ),
        );

        await _saveNotificationToFirestore(dummyMessage);
        NotificationService.showNotification(
            flutterLocalNotificationsPlugin, dummyMessage);
      } catch (e) {
        print("Error submitting data to Firestore: $e");
      }
    }
  }
}
