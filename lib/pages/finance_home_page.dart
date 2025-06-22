import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_minor/controllers/get_category_total.dart';
import 'package:new_minor/models/total_expense_model.dart';
import 'package:new_minor/pages/category_transaction_history.dart';
import 'package:new_minor/pages/profile_page.dart';
import '../controllers/dashboard_controller.dart';
import '../models/dashboard_data_model.dart';

class FinanceHomePage extends StatefulWidget {
  const FinanceHomePage({Key? key}) : super(key: key);
  @override
  State<FinanceHomePage> createState() => _FinanceHomePageState();
}

class _FinanceHomePageState extends State<FinanceHomePage> {
  CategoryTotals? totals;
  DashboardDataModel? dashboardData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final fetchedTotals = await GetCategoryTotalsController.fetchCategoryTotals();
    final fetchedDashboard = await DashboardController.fetchDashboardData();

    setState(() {
      totals = fetchedTotals ??
          CategoryTotals(
            id: 0,
            groceries: 0,
            medical: 0,
            domestic: 0,
            shopping: 0,
            bills: 0,
            entertainment: 0,
            travelling: 0,
            fueling: 0,
            educational: 0,
            others: 0,
            datetime: DateTime.now(),
          );

      dashboardData = fetchedDashboard ??
          DashboardDataModel(
            username: '',
            mobileNo: '',
            bankName: '',
            email: '',
            monthlyIncome: 0,
            targetSaving: 0,
            totalExpense: 0,
            totalSaving: 0,
          );

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF836FFF), Color(0xFFBCA3F7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Welcome back 👋",
                          style: TextStyle(color: Colors.white70, fontSize: 16.sp)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfilePage()),
                          );
                        },
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, color: Colors.deepPurple),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    dashboardData?.username ?? '',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text('Target Saving',
                      style: TextStyle(color: Colors.white70, fontSize: 14.sp)),
                  SizedBox(height: 4.h),
                  Text(
                    '₹${dashboardData?.targetSaving.toStringAsFixed(2) ?? ''}',
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _amountCard(
                        'assets/images/logo.png',
                        'Limit',
                        '₹${dashboardData?.totalSaving.toStringAsFixed(2) ?? '0.00'}',
                        Colors.green,
                      ),
                      _amountCard(
                        'assets/images/logo_2.png',
                        'Expense',
                        '₹${dashboardData?.totalExpense.toStringAsFixed(2) ?? '0.00'}',
                        Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Text(
                    'Category Wise Expense',
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                itemCount: _buildCategoryList(totals!).length,
                separatorBuilder: (_, __) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  final item = _buildCategoryList(totals!)[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CategoryTransactionScreen(category: item['title']),
                        ),
                      );
                    },
                    child: _transactionTile(
                      icon: item['icon'],
                      color: item['color'],
                      title: item['title'],
                      subtitle: item['subtitle'],
                      amount: item['amount'],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _amountCard(String imagePath, String label, String value, Color color) {
    return Container(
      width: 150.w,
      height: 70.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 10.r)],
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18.r)),
            child: Center(child: Image.asset(imagePath, width: 22.w, height: 22.h)),
          ),
          SizedBox(width: 10.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.white, fontSize: 13.sp)),
              Text(value,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.sp)),
            ],
          )
        ],
      ),
    );
  }

  Widget _transactionTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required double amount,
  }) {
    return Container(
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4.r)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 23.r,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 23.sp),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                Text(subtitle, style: TextStyle(color: Colors.black54, fontSize: 13.sp)),
              ],
            ),
          ),
          Text('₹${amount.toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _buildCategoryList(CategoryTotals totals) {
    return [
      {"icon": Icons.local_grocery_store, "color": Colors.teal, "title": "Groceries", "subtitle": "Daily grocery shopping", "amount": totals.groceries},
      {"icon": Icons.medical_services, "color": Colors.redAccent, "title": "Medical", "subtitle": "Health expenses", "amount": totals.medical},
      {"icon": Icons.cleaning_services, "color": Colors.indigo, "title": "Domestic", "subtitle": "Household help, cleaning", "amount": totals.domestic},
      {"icon": Icons.shopping_bag, "color": Colors.orange, "title": "Shopping", "subtitle": "Clothes, gadgets etc.", "amount": totals.shopping},
      {"icon": Icons.receipt, "color": Colors.blueGrey, "title": "Bills", "subtitle": "Electricity, water etc.", "amount": totals.bills},
      {"icon": Icons.movie, "color": Colors.purple, "title": "Entertainment", "subtitle": "Movies, games etc.", "amount": totals.entertainment},
      {"icon": Icons.travel_explore, "color": Colors.green, "title": "Travelling", "subtitle": "Transport and trips", "amount": totals.travelling},
      {"icon": Icons.local_gas_station, "color": Colors.brown, "title": "Fueling", "subtitle": "Petrol/diesel", "amount": totals.fueling},
      {"icon": Icons.school, "color": Colors.cyan, "title": "Educational", "subtitle": "Books, courses", "amount": totals.educational},
      {"icon": Icons.more_horiz, "color": Colors.grey, "title": "Others", "subtitle": "Miscellaneous", "amount": totals.others},
    ];
  }
}
