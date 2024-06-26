import 'package:flutter/material.dart';
import '../controllers/health_insurance_controller.dart';
import 'yes_no_step_view.dart';
import 'yes_no_married_view.dart';
import 'date_step_view.dart';
import 'form_step_view.dart';
import 'summary_step_view.dart';

class HealthInsuranceView extends StatefulWidget {
  @override
  _HealthInsuranceViewState createState() => _HealthInsuranceViewState();
}

class _HealthInsuranceViewState extends State<HealthInsuranceView> {
  late HealthInsuranceController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HealthInsuranceController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assurance Maladie'),
      ),
      body: Container(
        decoration:
            BoxDecoration(color: const Color.fromARGB(255, 255, 255, 255)),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_controller.currentPage + 1) / 5,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
            Expanded(
              child: PageView(
                controller: _controller.pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  YesNoStepView(
                    question: 'Etes Vous un etudiant ?',
                    stepKey: 'is_student',
                    onOptionSelected: (value, score) {
                      _controller.formData['is_student'] = value;
                      _controller.formData['is_student_score'] = score;
                    },
                  ),
                  YesNoMarriedView(
                    question: 'Avez Vous des Enfants ?',
                    stepKey: 'has_children',
                    onOptionSelected: (value, score) {
                      _controller.formData['has_children'] = value;
                      _controller.formData['has_children_score'] = score;
                    },
                  ),
                  DateStepView(
                    question: 'Entrer votre date de Naissance',
                    controller: _controller,
                  ),
                  FormStepView(controller: _controller),
                  SummaryStepView(controller: _controller),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_controller.currentPage > 0)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 30),
                          ),
                          onPressed: () =>
                              setState(() => _controller.previousPage()),
                          child: Text('Previous'),
                        ),
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 30),
                        ),
                        onPressed: () => setState(() => _controller.nextPage()),
                        child: Text(
                            _controller.currentPage < 4 ? 'Next' : 'Submit'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
