import 'package:flutter/material.dart';

class FinanceHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Color(0xFFBCA3F7),
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'Account Balance',
                  style: TextStyle(color: Colors.grey[800], fontSize: 14),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              '\$9400',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _amountCard(Icons.download, 'Income', '\$5000', Colors.green),
                  SizedBox(
                    width: 20,
                  ),
                  _amountCard(Icons.upload, 'Expenses', '\$1200', Colors.red),
                ],
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Spend Frequency',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Icon(Icons.filter_list),
                ],
              ),
            ),
            SizedBox(height: 10),
            _transactionTypeSelector(),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _transactionTile(
                      icon: Icons.shopping_bag,
                      color: Colors.amber,
                      title: 'Shopping',
                      subtitle: 'Buy some grocery',
                      amount: '- \$120',
                      time: '10:00 AM'),
                  _transactionTile(
                      icon: Icons.subscriptions,
                      color: Colors.purpleAccent,
                      title: 'Subscription',
                      subtitle: 'Disney+ Annual..',
                      amount: '- \$80',
                      time: '03:30 PM'),
                  _transactionTile(
                      icon: Icons.restaurant,
                      color: Colors.redAccent,
                      title: 'Food',
                      subtitle: 'Buy a ramen',
                      amount: '- \$32',
                      time: '07:30 PM'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _amountCard(IconData icon, String label, String value, Color color) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          SizedBox(height: 8),
          Text(label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(value,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color)),
        ],
      ),
    );
  }

  Widget _transactionTypeSelector() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.expand_more),
          SizedBox(width: 4),
          Text("Transaction"),
        ],
      ),
    );
  }

  Widget _transactionTile(
      {required IconData icon,
        required Color color,
        required String title,
        required String subtitle,
        required String amount,
        required String time}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.3),
            child: Icon(icon, color: color),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.bold)),
              Text(time,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          )
        ],
      ),
    );
  }
}
