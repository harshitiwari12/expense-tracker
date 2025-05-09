import 'package:flutter/material.dart';
import '../controllers/dashboard_controller.dart';
import '../models/dashboard_data_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DashboardDataModel? dashboardData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    final data = await DashboardController.fetchDashboardData();
    setState(() {
      dashboardData = data;
      isLoading = false;
    });
  }

  Widget buildInfoCard(String title, String value, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: ListTile(
        tileColor: color.withOpacity(0.1),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : dashboardData == null
          ? const Center(child: Text("Failed to load dashboard data."))
          : ListView(
        children: [
          buildInfoCard("Username", dashboardData!.username, Colors.blue),
          buildInfoCard("Mobile No", dashboardData!.mobileNo, Colors.green),
          buildInfoCard("Bank", dashboardData!.bankName, Colors.deepPurple),
          buildInfoCard("Email", dashboardData!.email, Colors.orange),
          buildInfoCard("Monthly Income", "₹${dashboardData!.monthlyIncome}", Colors.teal),
          buildInfoCard("Target Saving", "₹${dashboardData!.targetSaving}", Colors.cyan),
          buildInfoCard("Total Expense", "₹${dashboardData!.totalExpense}", Colors.redAccent),
          buildInfoCard("Total Saving", "₹${dashboardData!.totalSaving}", Colors.indigo),
        ],
      ),
    );
  }
}
