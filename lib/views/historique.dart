import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class HistoriqueScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historique'),
      ),
      body: Center(
        child: Text(
          'Historique Content',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
