import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
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
                      const Text("Welcome back 👋", style: TextStyle(color: Colors.white70, fontSize: 16)),
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
                  const SizedBox(height: 3),
                  Text(
                    dashboardData?.username ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text('Target Saving', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 4),
                  Text(
                    '₹${dashboardData?.targetSaving.toStringAsFixed(2) ?? ''}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Category Wise Expense',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: _buildCategoryList(totals!).length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
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
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.deepPurple,
        //   onPressed: () {
        //     // Navigate to the desired page
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (_) => DashboardPage()),
        //     );
        //   },
        //   child: const Icon(Icons.add, color: Colors.white),
        // ),
      ),
    );
  }

  Widget _amountCard(String imagePath, String label, String value, Color color) {
    return Container(
      width: 150,
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
            child: Center(child: Image.asset(imagePath, width: 22, height: 22)),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
              Text(value,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Text(subtitle, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          Text('₹${amount.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
