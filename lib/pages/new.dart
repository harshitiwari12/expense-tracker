import 'package:flutter/material.dart';
import 'package:new_minor/controllers/get_category_total.dart';
import 'package:new_minor/models/total_expense_model.dart';

class FinanceHomePage extends StatefulWidget {
  const FinanceHomePage({super.key});

  @override
  State<FinanceHomePage> createState() => _FinanceHomePageState();
}

class _FinanceHomePageState extends State<FinanceHomePage> {
  CategoryTotals? totals;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final fetchedData = await GetCategoryTotalsController.fetchCategoryTotals();
    setState(() {
      totals = fetchedData ?? CategoryTotals(
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
      isLoading = false;
    });
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

  double _getTotalExpenses(CategoryTotals totals) {
    return totals.groceries +
        totals.medical +
        totals.domestic +
        totals.shopping +
        totals.bills +
        totals.entertainment +
        totals.travelling +
        totals.fueling +
        totals.educational +
        totals.others;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F7FB),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Container(
              width: double.infinity,
              padding:const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF836FFF), Color(0xFFBCA3F7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Welcome back 👋", style: TextStyle(color: Colors.white70, fontSize: 16)),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Colors.deepPurple),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  const  Text('\₹9400',
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _amountCard('assets/images/logo.png', 'Targeted Saving', '\₹5000', Colors.green),
                      _amountCard('assets/images/logo_2.png', 'Current Expenses',
                          '\₹${_getTotalExpenses(totals!).toStringAsFixed(2)}', Colors.red),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Spend Frequency', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 15),
            _transactionTypeSelector(),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.only(bottom: 20),
                itemCount: _buildCategoryList(totals!).length,
                separatorBuilder: (_, __) => SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = _buildCategoryList(totals!)[index];
                  return _transactionTile(
                    icon: item['icon'],
                    color: item['color'],
                    title: item['title'],
                    subtitle: item['subtitle'],
                    amount: "- ₹${item['amount'].toStringAsFixed(2)}",
                    time: "—",
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

  Widget _transactionTypeSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children:[
          Icon(Icons.expand_more),
          SizedBox(width: 4),
          Text("Transaction"),
        ],
      ),
    );
  }

  Widget _transactionTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String amount,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount,
                  style: const TextStyle(
                      fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold)),
              Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          )
        ],
      ),
    );
  }
}
