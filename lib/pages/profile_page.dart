import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_minor/controllers/dashboard_controller.dart';
import 'package:new_minor/pages/categorized_expanse_page.dart';
import 'package:new_minor/pages/dashboard_page.dart';
import 'package:new_minor/pages/finance_home_page.dart';
import 'package:new_minor/pages/income_saving_page.dart';
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
    {"title": "Category Expense", "icon": Icons.list_alt, "page": ExpensePage(), "color": Colors.blue},
    {"title": "Dashboard", "icon": Icons.dashboard, "page": FinanceHomePage(), "color": Colors.green},
    {"title": "Past Transactions", "icon": Icons.currency_rupee, "page": ReadSms(), "color": Colors.orange},
    {"title": "Report", "icon": Icons.bar_chart, "page": DashboardPage(), "color": Colors.purple},
    {"title": "Saving Goals", "icon": Icons.settings, "page": IncomeSavingsPage(), "color": Colors.grey},
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
        title: Text("My Profile", style: TextStyle(fontSize: 18.sp)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, size: 20.sp),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistrationPage()));
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
            Icon(Icons.error_outline, size: 50.sp, color: Colors.red),
            SizedBox(height: 16.h),
            Text("Failed to load data", style: TextStyle(fontSize: 16.sp)),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _loadDashboardData,
              child: Text("Retry", style: TextStyle(fontSize: 14.sp)),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context),
            SizedBox(height: 24.h),
            _buildFinancialOverview(context, screenWidth),
            SizedBox(height: 24.h),
            _buildUserDetailsSection(theme),
            SizedBox(height: 24.h),
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
                    width: 2.w,
                  ),
                ),
                child: CircleAvatar(
                  radius: 50.r,
                  backgroundColor: Colors.grey[200],
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/img.png',
                      width: 90.w,
                      height: 90.h,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(Icons.person, size: 50.sp, color: Colors.grey[600]),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.camera_alt, size: 18.sp, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            dashboardData!.username,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 22.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            dashboardData!.email,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 16.sp,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialOverview(BuildContext context, double screenWidth) {
    return SizedBox(
      height: 120.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFinancialCard(context: context, title: "Monthly Income", amount: dashboardData!.monthlyIncome, icon: Icons.arrow_upward, color: Colors.green, width: screenWidth * 0.45),
          SizedBox(width: 12.w),
          _buildFinancialCard(context: context, title: "Total Expense", amount: dashboardData!.totalExpense, icon: Icons.arrow_downward, color: Colors.red, width: screenWidth * 0.45),
          SizedBox(width: 12.w),
          _buildFinancialCard(context: context, title: "Target Saving", amount: dashboardData!.targetSaving, icon: Icons.savings, color: Colors.blue, width: screenWidth * 0.45),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
                  Icon(icon, color: color, size: 20.sp),
                ],
              ),
              SizedBox(height: 8.h),
              Text("₹${amount.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserDetailsSection(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Personal Details",
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 12.h),
            _buildDetailRow(Icons.phone, "Mobile", dashboardData!.mobileNo),
            Divider(height: 24.h),
            _buildDetailRow(Icons.account_balance, "Bank", dashboardData!.bankName),
            Divider(height: 24.h),
            _buildDetailRow(Icons.money, "Remaining Limit", "₹${dashboardData!.totalSaving.toStringAsFixed(2)}"),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: Colors.grey[600]),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
              SizedBox(height: 4.h),
              Text(value, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
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
        Text("Features", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 12.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.5,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];
            final page = feature['page'] as Widget?;
            return _buildFeatureCard(
              context: context,
              title: feature['title'],
              icon: feature['icon'],
              color: feature['color'],
              onTap: () {
                if (page != null) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => page));
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(9.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24.sp),
              ),
              SizedBox(height: 12.h),
              Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
