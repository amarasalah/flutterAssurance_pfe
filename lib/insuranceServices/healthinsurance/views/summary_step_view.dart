import 'package:flutter/material.dart';
import 'package:insurance_pfe/insuranceServices/healthinsurance/views/stripe_payment_page.dart';
import '../controllers/health_insurance_controller.dart';
import 'invoice_page.dart';
import 'payment_page.dart';

class SummaryStepView extends StatelessWidget {
  final HealthInsuranceController controller;

  SummaryStepView({required this.controller});

  @override
  Widget build(BuildContext context) {
    int total = controller.calculateTotal();
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        margin: const EdgeInsets.all(10.0),
        width: 300.0, // Increase width for more content space
        padding: const EdgeInsets.all(16.0), // Add padding for inner content
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Summary: Review Your Data',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Name: ${controller.nameController.text}',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Age: ${controller.ageController.text}',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Selected Option: ${controller.selectedOption}',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Student: ${controller.formData['is_student']}',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Children: ${controller.formData['has_children']}',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Birth Date: ${controller.birthDateController.text}',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Total: $total',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showPaymentDialog(context, total),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.orange,
                backgroundColor: Colors.white, // Text color
              ),
              child: Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentDialog(BuildContext context, int total) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose an option"),
          content: Text("Would you like to pay now or receive an invoice?"),
          actions: [
            TextButton(
              child: Text("Invoice"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _showInvoiceDialog(context);
              },
            ),
            TextButton(
              child: Text("Pay"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => StripePaymentPage(total: total)),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showInvoiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Invoice Number"),
          content: Text("Your invoice number is 12345-67890."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
