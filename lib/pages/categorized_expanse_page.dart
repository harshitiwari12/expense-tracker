import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_minor/controllers/get_sms_data_controller.dart';
import 'package:new_minor/controllers/post_sms_category_controller.dart';
import 'package:new_minor/models/post_sms_category_model.dart';
import 'package:new_minor/pages/finance_home_page.dart'; // <-- Import your target page
import 'package:new_minor/pages/income_saving_page.dart';
import '../widget/category_drop_down_button.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  List<CategorizedSmsData> smsExpenses = [];
  List<String?> selectedCategories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSms();
  }

  Future<void> fetchSms() async {
    final fetchedSms = await SmsFetchController.fetchCategorizedSms();
    setState(() {
      smsExpenses = fetchedSms;
      selectedCategories = List<String?>.filled(fetchedSms.length, null);
      isLoading = false;
    });
  }

  Future<void> submitCategories() async {
    for (int i = 0; i < smsExpenses.length; i++) {
      smsExpenses[i].category = selectedCategories[i];
    }

    bool success = await SmsPostController.submitCategorizedSms(smsExpenses);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? "Categories submitted successfully"
            : "Failed to submit categories"),
      ),
    );

    // Navigate to FinanceHomePage after successful submission
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const IncomeSavingsPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expenses List')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : smsExpenses.isEmpty
          ? const Center(child: Text('No expenses found.'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: smsExpenses.length,
              itemBuilder: (context, index) {
                final expense = smsExpenses[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 150,
                            child: CategoryDropDownButton(
                              selectedBank: selectedCategories[index],
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedCategories[index] = newValue;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "₹${expense.amount.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('yyyy-MM-dd HH:mm:ss')
                                      .format(expense.dateTime),
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 4.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.cloud_upload),
              label: const Text('Submit Categories'),
              onPressed: submitCategories,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 4.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.home),
              label: const Text('Go to Finance Home'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>IncomeSavingsPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
