import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controllers/health_insurance_controller.dart';

class SummaryStepView extends StatelessWidget {
  final HealthInsuranceController controller;

  SummaryStepView({required this.controller});

  Future<Map<String, dynamic>> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userData.data() as Map<String, dynamic>;
    } else {
      throw Exception("User not logged in");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching user data'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No user data found'));
        } else {
          var userData = snapshot.data!;
          var dobController = userData['birthdate'] ?? 'N/A';
          var fullnameController = userData['fullname'] ?? 'N/A';
          var nationalIdController = userData['nationalId'] ?? 'N/A';
          var phoneController = userData['phone'] ?? 'N/A';
          var selectedCountry = userData['country'] ?? 'Tunis';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Summary',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _buildSummaryItem('Name:', fullnameController),
                _buildSummaryItem('National ID:', nationalIdController),
                _buildSummaryItem('Phone:', phoneController),
                _buildSummaryItem('Country:', selectedCountry),
                _buildSummaryItem(
                    'Student:', controller.formData['is_student'] ?? 'N/A'),
                _buildSummaryItem(
                    'Children:', controller.formData['has_children'] ?? 'N/A'),
                _buildSummaryItem('Birth Date:', dobController),
                _buildSummaryItem('Marital Status:', controller.selectedOption),
                _buildSummaryItem(
                    'Total:', controller.calculateTotal().toString()),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildSummaryItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          Text(value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}
