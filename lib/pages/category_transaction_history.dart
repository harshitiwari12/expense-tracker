import 'package:flutter/material.dart';
import '../controllers/category_transaction_controller.dart';
import '../models/post_sms_category_model.dart';
import 'package:intl/intl.dart';

class CategoryTransactionScreen extends StatefulWidget {
  final String category;

  const CategoryTransactionScreen({super.key, required this.category});

  @override
  State<CategoryTransactionScreen> createState() => _CategoryTransactionScreenState();
}

class _CategoryTransactionScreenState extends State<CategoryTransactionScreen> {
  List<CategorizedSmsData> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    try {
      final fetched = await CategoryTransactionController.fetchTransactionsByCategory(widget.category);
      setState(() {
        transactions = fetched;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching transactions: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatDate(String dateTimeString) {
    // Parse the dateTimeString as a DateTime object, assuming it's in local time
    final dateTime = DateTime.parse(dateTimeString);
    return DateFormat('dd MMM yyyy • hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.category} Transactions"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : transactions.isEmpty
          ? const Center(child: Text("No transactions available."))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final txn = transactions[index];
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.currency_rupee,
                  color: Colors.deepPurple),
              title: Text("₹${txn.amount.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(formatDate(txn.dateTime.toString())),
            ),
          );
        },
      ),
    );
  }
}
