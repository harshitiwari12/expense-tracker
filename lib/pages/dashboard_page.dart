import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/get_category_total.dart';
import '../models/total_expense_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  CategoryTotals? totals;
  bool isLoading = true;

  final Map<String, Color> categoryColors = {
    'Groceries': Colors.red,
    'Medical': Colors.green,
    'Domestic': Colors.blue,
    'Shopping': Colors.orange,
    'Bills': Colors.purple,
    'Entertainment': Colors.teal,
    'Travelling': Colors.brown,
    'Fueling': Colors.cyan,
    'Educational': Colors.indigo,
    'Others': Colors.pink,
  };

  @override
  void initState() {
    super.initState();
    fetchCategoryTotals();
  }

  Future<void> fetchCategoryTotals() async {
    final result = await GetCategoryTotalsController.fetchCategoryTotals();
    setState(() {
      totals = result;
      isLoading = false;
    });
  }

  Map<String, double> prepareData(CategoryTotals data) {
    return {
      'Groceries': data.groceries,
      'Medical': data.medical,
      'Domestic': data.domestic,
      'Shopping': data.shopping,
      'Bills': data.bills,
      'Entertainment': data.entertainment,
      'Travelling': data.travelling,
      'Fueling': data.fueling,
      'Educational': data.educational,
      'Others': data.others,
    }..removeWhere((key, value) => value == 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Category Breakdown',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : totals == null
          ? const Center(child: Text('Data not found'))
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Total Expense Distribution',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: buildSections(prepareData(totals!)),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: prepareData(totals!).entries.map((entry) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: categoryColors[entry.key] ?? Colors.grey,
                      radius: 8,
                    ),
                    title: Text(entry.key),
                    trailing: Text('₹${entry.value.toStringAsFixed(2)}'),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> buildSections(Map<String, double> data) {
    final total = data.values.reduce((a, b) => a + b);
    return data.entries.map((entry) {
      final color = categoryColors[entry.key] ?? Colors.grey;
      final value = entry.value;
      final title = '${(value / total * 100).toStringAsFixed(1)}%';

      return PieChartSectionData(
        color: color,
        value: value,
        title: title,
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}
