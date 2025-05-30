import 'package:flutter/material.dart';
import 'package:new_minor/controllers/dashboard_controller.dart';
import 'package:new_minor/pages/categorized_expanse_page.dart';
import 'package:new_minor/pages/dashboard_page.dart';
import 'package:new_minor/pages/finance_home_page.dart';
import 'package:new_minor/pages/registration_page.dart';
import 'package:new_minor/read_sms.dart';
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
    {
      "title": "Category Expense",
      "icon": Icons.list_alt,
      "page": const ExpensePage(),
      "color": Colors.blue
    },
    {
      "title": "Dashboard",
      "icon": Icons.dashboard,
      "page": const FinanceHomePage() ,
      "color": Colors.green
    },
    {
      "title": "Past Transactions",
      "icon": Icons.currency_rupee,
      "page": const ReadSms(),
      "color": Colors.orange
    },
    {
      "title": "Report",
      "icon": Icons.bar_chart,
      "page": const DashboardPage(),
      "color": Colors.purple
    },
    // {
    //   "title": "Settings",
    //   "icon": Icons.settings,
    //   "page": SettingsPage(), // Replace with your actual page widget
    //   "color": Colors.grey
    // },
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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage(),));
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : dashboardData == null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 50, color: Colors.red),
            const SizedBox(height: 16),
            const Text("Failed to load data"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadDashboardData,
              child: const Text("Retry"),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            _buildProfileHeader(context),
            const SizedBox(height: 24),

            // Financial Overview Cards
            _buildFinancialOverview(context, screenWidth),
            const SizedBox(height: 24),

            // User Details Section
            _buildUserDetailsSection(theme),
            const SizedBox(height: 24),

            // Features Section
            _buildFeaturesSection(theme, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/img.png',
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            dashboardData!.username,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            dashboardData!.email,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialOverview(BuildContext context, double screenWidth) {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFinancialCard(
            context: context,
            title: "Monthly Income",
            amount: dashboardData!.monthlyIncome,
            icon: Icons.arrow_upward,
            color: Colors.green,
            width: screenWidth * 0.45,
          ),
          const SizedBox(width: 12),
          _buildFinancialCard(
            context: context,
            title: "Total Expense",
            amount: dashboardData!.totalExpense,
            icon: Icons.arrow_downward,
            color: Colors.red,
            width: screenWidth * 0.45,
          ),
          const SizedBox(width: 12),
          _buildFinancialCard(
            context: context,
            title: "Target Saving",
            amount: dashboardData!.targetSaving,
            icon: Icons.savings,
            color: Colors.blue,
            width: screenWidth * 0.45,
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialCard({
    required BuildContext context,
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(icon, color: color, size: 20),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "₹${amount.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserDetailsSection(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Personal Details",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.phone, "Mobile", dashboardData!.mobileNo),
            const Divider(height: 24),
            _buildDetailRow(Icons.account_balance, "Bank", dashboardData!.bankName),
            const Divider(height: 24),
            _buildDetailRow(Icons.money, "Remaining Limit",
                "₹${dashboardData!.totalSaving.toStringAsFixed(2)}"),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection(ThemeData theme, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Features",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];
            final page = feature['page'] as Widget?; // Safe cast with null check

            return _buildFeatureCard(
              context: context,
              title: feature['title'],
              icon: feature['icon'],
              color: feature['color'],
              onTap: () {
                if (page != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => page),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Page not available')),
                  );
                }
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}