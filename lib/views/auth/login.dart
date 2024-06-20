import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:insurance_pfe/views/components/custombuttonauth.dart';
import 'package:insurance_pfe/views/components/customlogoauth.dart';
import 'package:insurance_pfe/views/components/textformfield.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        setState(() {
          isLoading = false;
        });
        return; // The user canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      setState(() {
        isLoading = false;
      });

      Navigator.of(context)
          .pushNamedAndRemoveUntil("root_screen", (route) => false);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorDialog('Google sign-in failed. Please try again.');
      print('Google sign-in error: $e');
    }
  }

  void showErrorDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Error',
      desc: message,
    ).show();
  }

  void showSuccessDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Success',
      desc: message,
    ).show();
  }

  Future<void> loginUser() async {
    if (!formState.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      UserCredential credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );

      if (credential.user != null) {
        if (credential.user!.emailVerified) {
          print('User is logged in and email is verified.');
          Navigator.of(context)
              .pushNamedAndRemoveUntil("root_screen", (route) => false);
        } else {
          print('User is logged in but email is not verified.');
          showErrorDialog(
              'Please verify your email to login. Check your inbox for the verification link.');
        }
      }

      setState(() {
        isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });

      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      } else if (e.code == 'too-many-requests') {
        errorMessage = 'Too many attempts, please try again later.';
      } else {
        errorMessage = 'Error: ${e.message}';
      }

      showErrorDialog(errorMessage);
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      showErrorDialog('An error occurred. Please try again later.');
      print('Login error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  Form(
                    key: formState,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 50),
                        const CustomLogoAuth(),
                        Container(height: 20),
                        const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(height: 10),
                        const Text(
                          "Login To Continue Using The App",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Container(height: 20),
                        const Text(
                          "Email",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Container(height: 10),
                        CustomTextForm(
                          hinttext: "Enter Your Email",
                          mycontroller: email,
                          validator: (val) {
                            if (val == "") {
                              return "Email cannot be empty";
                            }
                            return null;
                          },
                        ),
                        Container(height: 10),
                        const Text(
                          "Password",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Container(height: 10),
                        CustomTextForm(
                          hinttext: "Enter Your Password",
                          mycontroller: password,
                          validator: (val) {
                            if (val == "") {
                              return "Password cannot be empty";
                            }
                            return null;
                          },
                        ),
                        InkWell(
                          onTap: () async {
                            if (email.text.isEmpty) {
                              showErrorDialog(
                                  "Please enter your email address before clicking on Forgot Password");
                              return;
                            }

                            try {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: email.text);
                              showSuccessDialog(
                                  'A password reset link has been sent to your email address. Please check your email.');
                            } catch (e) {
                              showErrorDialog(e.toString());
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 20),
                            alignment: Alignment.topRight,
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomButtonAuth(
                    title: "Login",
                    onPressed: loginUser,
                  ),
                  Container(height: 20),
                  MaterialButton(
                    height: 40,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.red[700],
                    textColor: Colors.white,
                    onPressed: signInWithGoogle,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Login With Google  "),
                        Image.asset(
                          "images/4.png",
                          width: 20,
                        )
                      ],
                    ),
                  ),
                  Container(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed("signup");
                    },
                    child: const Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't Have An Account? ",
                            ),
                            TextSpan(
                              text: "Register",
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
