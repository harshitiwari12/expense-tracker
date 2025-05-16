import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_minor/controllers/get_category_total.dart';
import 'package:new_minor/models/total_expense_model.dart';

class CategoryTotalsPage extends StatefulWidget {
  const CategoryTotalsPage({super.key});
  @override
  State<CategoryTotalsPage> createState() => _CategoryTotalsPageState();
}

class _CategoryTotalsPageState extends State<CategoryTotalsPage> {
  CategoryTotals? totals;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTotals();
  }

  Future<void> loadTotals() async {
    final data = await GetCategoryTotalsController.fetchCategoryTotals();
    setState(() {
      totals = data;
      isLoading = false;
    });
  }

  Widget _buildCategoryRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text("₹${amount.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Category Totals')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : totals == null
          ? const Center(child: Text("Failed to load data"))
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryRow("Groceries", totals!.groceries),
          _buildCategoryRow("Medical", totals!.medical),
          _buildCategoryRow("Domestic", totals!.domestic),
          _buildCategoryRow("Shopping", totals!.shopping),
          _buildCategoryRow("Bills", totals!.bills),
          _buildCategoryRow("Entertainment", totals!.entertainment),
          _buildCategoryRow("Travelling", totals!.travelling),
          _buildCategoryRow("Fueling", totals!.fueling),
          _buildCategoryRow("Educational", totals!.educational),
          _buildCategoryRow("Others", totals!.others),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Last Updated: ${DateFormat('yyyy-MM-dd – kk:mm').format(totals!.datetime)}",
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
