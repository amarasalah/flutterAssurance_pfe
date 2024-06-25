import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:insurance_pfe/homepage.dart';

class StripePaymentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StripePaymentPage(),
    );
  }
}

class StripePaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: PaymentDetails(),
        ),
      ),
    );
  }
}

class PaymentDetails extends StatefulWidget {
  @override
  _PaymentDetailsState createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _expiryMonthController = TextEditingController();
  final TextEditingController _expiryYearController = TextEditingController();
  final TextEditingController _cardNumberController1 = TextEditingController();
  final TextEditingController _cardNumberController2 = TextEditingController();
  final TextEditingController _cardNumberController3 = TextEditingController();
  final TextEditingController _cardNumberController4 = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  String _cardName = 'John Doe';
  String _expiryDate = '02/26';

  @override
  void initState() {
    super.initState();

    _nameController.addListener(() {
      setState(() {
        _cardName =
            _nameController.text.isEmpty ? 'John Doe' : _nameController.text;
      });
    });

    _expiryMonthController.addListener(() {
      setState(() {
        _updateExpiryDate();
      });
    });

    _expiryYearController.addListener(() {
      setState(() {
        _updateExpiryDate();
      });
    });
  }

  void _updateExpiryDate() {
    final month = _expiryMonthController.text.padLeft(2, '0');
    final year = _expiryYearController.text.padLeft(2, '0').substring(2);
    _expiryDate = '$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.arrow_back),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Payment details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PaymentOption(icon: Icons.credit_card, label: 'Visa'),
              PaymentOption(icon: Icons.credit_card, label: 'Mastercard'),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Select card',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          CardDetails(cardName: _cardName, expiryDate: _expiryDate),
          SizedBox(height: 20),
          AddNewCardForm(
            nameController: _nameController,
            expiryMonthController: _expiryMonthController,
            expiryYearController: _expiryYearController,
            cardNumberController1: _cardNumberController1,
            cardNumberController2: _cardNumberController2,
            cardNumberController3: _cardNumberController3,
            cardNumberController4: _cardNumberController4,
            cvvController: _cvvController,
          ),
          SizedBox(height: 20),
          OrderTotal(),
          PayNowButton(),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class PaymentOption extends StatelessWidget {
  final IconData icon;
  final String label;

  const PaymentOption({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 48),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}

class CardDetails extends StatelessWidget {
  final String cardName;
  final String expiryDate;

  const CardDetails({required this.cardName, required this.expiryDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        gradient: LinearGradient(
          colors: [Colors.pinkAccent, Colors.purpleAccent],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VISA',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            '**** **** **** 3233',
            style: TextStyle(
                color: Colors.white, fontSize: 18, letterSpacing: 2.0),
          ),
          SizedBox(height: 20),
          Text(
            cardName,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: 20),
          Text(
            expiryDate,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class AddNewCardForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController expiryMonthController;
  final TextEditingController expiryYearController;
  final TextEditingController cardNumberController1;
  final TextEditingController cardNumberController2;
  final TextEditingController cardNumberController3;
  final TextEditingController cardNumberController4;
  final TextEditingController cvvController;

  const AddNewCardForm({
    required this.nameController,
    required this.expiryMonthController,
    required this.expiryYearController,
    required this.cardNumberController1,
    required this.cardNumberController2,
    required this.cardNumberController3,
    required this.cardNumberController4,
    required this.cvvController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('+ add new card', style: TextStyle(fontSize: 18)),
        SizedBox(height: 20),
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Name on card',
            hintText: 'ex: John Doe',
          ),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            _buildOTPField(context, cardNumberController1,
                nextFocusNode: FocusNode(), inputType: TextInputType.number),
            SizedBox(width: 10),
            _buildOTPField(context, cardNumberController2,
                nextFocusNode: FocusNode(), inputType: TextInputType.number),
            SizedBox(width: 10),
            _buildOTPField(context, cardNumberController3,
                nextFocusNode: FocusNode(), inputType: TextInputType.number),
            SizedBox(width: 10),
            _buildOTPField(context, cardNumberController4,
                nextFocusNode: FocusNode(), inputType: TextInputType.number),
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildOTPField(context, expiryMonthController,
                  inputType: TextInputType.number, hintText: 'MM'),
            ),
            SizedBox(width: 20),
            Expanded(
              child: _buildOTPField(context, expiryYearController,
                  inputType: TextInputType.number, hintText: 'YY'),
            ),
          ],
        ),
        SizedBox(height: 20),
        TextField(
          controller: cvvController,
          decoration: InputDecoration(
            labelText: 'CVV/CVC',
            hintText: '3 or 4 digits',
          ),
        ),
      ],
    );
  }

  Widget _buildOTPField(BuildContext context, TextEditingController controller,
      {FocusNode? nextFocusNode,
      TextInputType inputType = TextInputType.text,
      String? hintText}) {
    return Container(
      width: 60,
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        textAlign: TextAlign.center,
        maxLength: 4,
        decoration: InputDecoration(
          hintText: hintText,
          counterText: '',
        ),
        onChanged: (value) {
          if (value.length == 4 && nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
      ),
    );
  }
}

class OrderTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Order total',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text('\$89',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class PayNowButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: 'Payment Successful',
          desc: 'Your payment has been processed successfully.',
          btnOkOnPress: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Homepage()));
          },
        )..show();
      },
      child: Text('Pay now', style: TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      ),
    );
  }
}