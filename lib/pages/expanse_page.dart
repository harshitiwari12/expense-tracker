import 'package:flutter/material.dart';
import 'package:new_minor/widget/category_drop_down_button.dart';
import '../controllers/get_sms_data.dart';

import '../models/get_sms.dart'; // This is your model: GetSms

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  List<GetSms> smsExpenses = [];
  List<String?> selectedCategories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSms();
  }

  Future<void> fetchSms() async {
    final fetchedSms = await GetSmsData.fetchSmsData(); // Returns List<GetSms>
    setState(() {
      smsExpenses = fetchedSms.cast<GetSms>();
      selectedCategories = List<String?>.filled(smsExpenses.length, null);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expenses List')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : smsExpenses.isEmpty
          ? const Center(child: Text('No expenses found.'))
          : ListView.builder(
        itemCount: smsExpenses.length,
        itemBuilder: (context, index) {
          final expense = smsExpenses[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Dropdown on the left
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
                    // Expense details on the right
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            expense.amount,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            expense.date,
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
    );
  }
}
