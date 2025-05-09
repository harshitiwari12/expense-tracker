import 'package:flutter/material.dart';
import 'package:another_telephony/telephony.dart';
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

  @override
  void initState() {
    super.initState();
    fetchBankSMS();
  }

  Future<void> fetchBankSMS() async {
    var permission = await Permission.sms.request();
    if (!permission.isGranted) {
      print("SMS permission not granted");
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
        amount: double.tryParse(amountMatch.group(1)!.replaceAll(',', '')) ?? 0.0,
        refNo: refMatch?.group(1) ?? 'N/A',
        moneyType: body.contains('debited') ? 'DEBITED' : 'CREDITED',
        dateTime: date,
      );
    }
    return null;
  }

  String formatSmsInfo(SmsMessage msg) {
    final smsData = extractSmsData(msg);
    if (smsData == null) return 'No valid transaction found.';

    return 'Amount: ₹${smsData.amount}\n'
        'Ref: ${smsData.refNo}\n'
        'Type: ${smsData.moneyType}\n'
        'Date: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(smsData.dateTime)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank SMS'),
        centerTitle: true,
      ),
      body: bankMessages.isEmpty
          ? const Center(child: Text('No bank messages found.'))
          : ListView.builder(
        itemCount: bankMessages.length,
        itemBuilder: (context, index) {
          final sms = bankMessages[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: ListTile(
              title: Text(sms.address ?? 'Unknown Sender'),
              subtitle: Text(formatSmsInfo(sms)),
            ),
          );
        },
      ),
    );
  }
}
