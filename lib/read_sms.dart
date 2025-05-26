import 'package:flutter/material.dart';
import 'package:another_telephony/telephony.dart';
import 'package:new_minor/pages/finance_home_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

import 'controllers/sms_service.dart';
import 'models/sms_data.dart';

class ReadSms extends StatefulWidget {
  const ReadSms({super.key});

  @override
  State<ReadSms> createState() => _ReadSmsState();
}

class _ReadSmsState extends State<ReadSms> {
  final Telephony telephony = Telephony.instance;
  List<SmsMessage> bankMessages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBankSMS();
  }

  Future<void> fetchBankSMS() async {
    setState(() {
      isLoading = true;
    });

    var permission = await Permission.sms.request();
    if (!permission.isGranted) {
      print("SMS permission not granted");
      setState(() {
        isLoading = false;
      });
      return;
    }

    List<SmsMessage> messages = await telephony.getInboxSms(
      columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
      sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
    );

    List<SmsMessage> filtered = messages.where((msg) {
      final body = msg.body?.toLowerCase() ?? '';
      return body.contains("rs.") &&
          (body.contains("debited") || body.contains("credited"));
    }).toList();

    print("Filtered bank messages: ${filtered.length}");

    List<SmsData> extractedList = [];

    for (var msg in filtered) {
      final smsData = extractSmsData(msg);
      if (smsData != null) {
        extractedList.add(smsData);
      }
    }

    if (extractedList.isNotEmpty) {
      await SmsService.sendSmsListToBackend(extractedList);
    }

    setState(() {
      bankMessages = filtered;
      isLoading = false;
    });
  }

  SmsData? extractSmsData(SmsMessage msg) {
    final body = msg.body?.toLowerCase() ?? '';

    final amountRegex = RegExp(r'(?:rs|inr)[\s\.]?\s*([\d,]+(?:\.\d{1,2})?)');
    final refRegex = RegExp(r'upi\/?(\d+)', caseSensitive: false);

    final amountMatch = amountRegex.firstMatch(body);
    final refMatch = refRegex.firstMatch(body);

    final date = msg.date != null
        ? DateTime.fromMillisecondsSinceEpoch(msg.date!)
        : null;

    if (amountMatch != null && date != null) {
      return SmsData(
        amount:
        double.tryParse(amountMatch.group(1)!.replaceAll(',', '')) ?? 0.0,
        refNo: refMatch?.group(1) ?? 'N/A',
        moneyType: body.contains('debited') ? 'DEBITED' : 'CREDITED',
        dateTime: date,
      );
    }
    return null;
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bank SMS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.indigo))
          : bankMessages.isEmpty
          ? const Center(
        child: Text(
          'No bank messages found.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchBankSMS,
              color: Colors.indigo,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: bankMessages.length,
                itemBuilder: (context, index) {
                  final sms = bankMessages[index];
                  final smsData = extractSmsData(sms);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sms.address ?? 'Unknown Sender',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              smsData != null
                                  ? 'Amount: ₹${smsData.amount.toStringAsFixed(2)}\n'
                                  'Ref: ${smsData.refNo}\n'
                                  'Type: ${smsData.moneyType}\n'
                                  'Date: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(smsData.dateTime)}'
                                  : 'No valid transaction found.',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FinanceHomePage(),
                    ),
                  );
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
