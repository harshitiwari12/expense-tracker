import 'package:flutter/material.dart';
import 'package:new_minor/widget/category_drop_down_button.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  // Dummy expense data
  final List<Map<String, String>> dummyExpenses = [
    {"amount": "₹150", "date": "2025-04-26"},
    {"amount": "₹300", "date": "2025-04-25"},
    {"amount": "₹500", "date": "2025-04-24"},
  ];

  // List to store selected category for each expense
  List<String?> selectedCategories = [];

  @override
  void initState() {
    super.initState();
    // Initialize selectedCategories with null values
    selectedCategories = List<String?>.filled(dummyExpenses.length, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expenses List')),
      body: ListView.builder(
        itemCount: dummyExpenses.length,
        itemBuilder: (context, index) {
          final expense = dummyExpenses[index];
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
                            expense['amount']!,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            expense['date']!,
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
