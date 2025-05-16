import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:new_minor/pages/finance_home_page.dart';
import '../controllers/income_controller.dart';
import '../models/income.dart';

class IncomeSavingsPage extends StatefulWidget {
  const IncomeSavingsPage({super.key});

  @override
  State<IncomeSavingsPage> createState() => _IncomeSavingsPageState();
}

class _IncomeSavingsPageState extends State<IncomeSavingsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _savingsController = TextEditingController();

  @override
  void dispose() {
    _incomeController.dispose();
    _savingsController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final income = double.parse(_incomeController.text);
      final savings = double.parse(_savingsController.text);

      final incomeData = Income(
        monthlyIncome: income,
        targetSaving: savings,
      );

      final controller = IncomeController();
      final success = await controller.submitIncome(incomeData);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Income and savings saved successfully!')),
        );

        // Navigate to FinanceHomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FinanceHomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save data. Please try again.')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Income & Savings'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Lottie.asset(
                'assets/animations/saving_animation.json',
                height: 300,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _incomeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Monthly Income',
                  prefixIcon: const Icon(Icons.currency_rupee_sharp),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your income';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Enter a valid income';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _savingsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Monthly Savings Goal',
                  prefixIcon: const Icon(Icons.account_balance_wallet),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter savings goal';
                  }
                  final savings = double.tryParse(value);
                  final income = double.tryParse(_incomeController.text);
                  if (savings == null || savings < 0) {
                    return 'Enter a valid savings amount';
                  }
                  if (income != null && savings > income) {
                    return 'Savings cannot exceed income';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
