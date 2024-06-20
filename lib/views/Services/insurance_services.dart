import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HealthServices extends StatefulWidget {
  @override
  _HealthServices createState() => _HealthServices();
}

class _HealthServices extends State<HealthServices> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  Map<String, dynamic> _formData = {};

  // Controllers for form inputs
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  late String _selectedOption;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 4) {
      setState(() {
        _currentPage++;
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      });
    } else {
      _submitData();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
        _pageController.previousPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      });
    }
  }

  void _submitData() async {
    // Collect data from all steps
    _formData['name'] = _nameController.text;
    _formData['age'] = _ageController.text;
    _formData['selectedOption'] = _selectedOption;
    _formData['qcmStep1'] = 'Option1'; // Add collected QCM data
    _formData['qcmStep2'] = 'Option2'; // Add collected QCM data
    _formData['qcmStep4'] = 'Option4'; // Add collected QCM data

    // Add to Firebase
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('responses').add({
        'userId': user.uid,
        'data': _formData,
        'timestamp': Timestamp.now(),
      });
      print('Data submitted to Firebase successfully!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multi-Step Form'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildStep1(),
                _buildStep2(),
                _buildStep3(),
                _buildStep4(),
                _buildSummaryStep(),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentPage > 0)
                ElevatedButton(
                  onPressed: _previousPage,
                  child: Text('Previous'),
                ),
              ElevatedButton(
                onPressed: _nextPage,
                child: Text(_currentPage < 4 ? 'Next' : 'Submit'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Step 1: QCM'),
          // Example QCM options
          ListTile(
            title: Text('Option 1'),
            leading: Radio(
              value: 'Option1',
              groupValue: _formData['qcmStep1'],
              onChanged: (value) {
                setState(() {
                  _formData['qcmStep1'] = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Option 2'),
            leading: Radio(
              value: 'Option2',
              groupValue: _formData['qcmStep1'],
              onChanged: (value) {
                setState(() {
                  _formData['qcmStep1'] = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Step 2: QCM'),
          // Example QCM options
          ListTile(
            title: Text('Option 1'),
            leading: Radio(
              value: 'Option1',
              groupValue: _formData['qcmStep2'],
              onChanged: (value) {
                setState(() {
                  _formData['qcmStep2'] = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Option 2'),
            leading: Radio(
              value: 'Option2',
              groupValue: _formData['qcmStep2'],
              onChanged: (value) {
                setState(() {
                  _formData['qcmStep2'] = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Step 3: Form with Inputs'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedOption,
              hint: Text('Select an option'),
              items: ['Option A', 'Option B', 'Option C']
                  .map((option) => DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedOption = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep4() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Step 4: QCM'),
          // Example QCM options
          ListTile(
            title: Text('Option 3'),
            leading: Radio(
              value: 'Option3',
              groupValue: _formData['qcmStep4'],
              onChanged: (value) {
                setState(() {
                  _formData['qcmStep4'] = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Option 4'),
            leading: Radio(
              value: 'Option4',
              groupValue: _formData['qcmStep4'],
              onChanged: (value) {
                setState(() {
                  _formData['qcmStep4'] = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStep() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Summary: Review Your Data'),
          Text('Name: ${_nameController.text}'),
          Text('Age: ${_ageController.text}'),
          Text('Selected Option: $_selectedOption'),
          Text('QCM Step 1: ${_formData['qcmStep1']}'),
          Text('QCM Step 2: ${_formData['qcmStep2']}'),
          Text('QCM Step 4: ${_formData['qcmStep4']}'),
        ],
      ),
    );
  }
}
