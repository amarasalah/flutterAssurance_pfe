import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> registerUser(email, username, password, context) async {
  bool isLoading;
  try {
    setState(() {
      isLoading = true;
    });

    // Create user in Firebase Authentication
    final UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Create user document in Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      'name': username,
      'email': email,
      'role': 'user', // Default role
      'createdAt': Timestamp.now(),
    });

    // Send verification email
    await userCredential.user!.sendEmailVerification();

    // Show success dialog
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      title: 'Success',
      desc: 'Verification email sent. Please verify your email to continue.',
    ).show();

    // Navigate to login screen
    Navigator.of(context).pushReplacementNamed("login");

    setState(() {
      isLoading = false;
    });
  } on FirebaseAuthException catch (e) {
    setState(() {
      isLoading = false;
    });

    String errorMessage;
    if (e.code == 'weak-password') {
      errorMessage = 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      errorMessage = 'The account already exists for that email.';
    } else {
      errorMessage = 'An error occurred. Please try again later.';
    }

    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Error',
      desc: errorMessage,
    ).show();
  } catch (e) {
    setState(() {
      isLoading = false;
    });
    print(e.toString());
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Error',
      desc: 'An unexpected error occurred. Please try again later.',
    ).show();
  }
}

void setState(Null Function() param0) {}
