import 'package:flutter/material.dart';
import 'package:new_minor/controllers/dashboard_controller.dart';
import '../models/dashboard_data_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DashboardDataModel? dashboardData;
  bool isLoading = true;

  final List<Map<String, dynamic>> features = [
    {"title": "Category Expense", "icon": Icons.list_alt, "route": "/transactions"},
    {"title": "Add Expense", "icon": Icons.add_circle_outline, "route": "/addExpense"},
    {"title": "Budget Planner", "icon": Icons.attach_money, "route": "/budgetPlanner"},
    {"title": "Reports", "icon": Icons.bar_chart, "route": "/reports"},
    {"title": "Settings", "icon": Icons.settings, "route": "/settings"},
  ];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    final data = await DashboardController.fetchDashboardData();
    setState(() {
      dashboardData = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileImageUrl = "https://i.pravatar.cc/150?img=3";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : dashboardData == null
          ? const Center(child: Text("Failed to load data"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(profileImageUrl),
              ),
            ),
            const SizedBox(height: 16),

            // User Info
            Center(
              child: Text(
                dashboardData!.username,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                dashboardData!.email,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // User Details List
            _buildInfoTile("Mobile Number", dashboardData!.mobileNo),
            _buildInfoTile("Bank Name", dashboardData!.bankName),
            _buildInfoTile("Monthly Income", "₹${dashboardData!.monthlyIncome.toStringAsFixed(2)}"),
            _buildInfoTile("Target Saving", "₹${dashboardData!.targetSaving.toStringAsFixed(2)}"),
            _buildInfoTile("Total Expense", "₹${dashboardData!.totalExpense.toStringAsFixed(2)}"),
            _buildInfoTile("Remaining Limit", "₹${dashboardData!.totalSaving.toStringAsFixed(2)}"),
            const SizedBox(height: 25),

            Text(
              "Features",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),

            // Feature List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: features.length,
              itemBuilder: (context, index) {
                final feature = features[index];
                return FeatureListTile(
                  title: feature['title'],
                  icon: feature['icon'],
                  onTap: () {
                    Navigator.pushNamed(context, feature['route']);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      subtitle: Text(value, style: const TextStyle(fontSize: 15)),
    );
  }
}

class FeatureListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const FeatureListTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
