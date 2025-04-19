import 'package:flutter/material.dart';
import 'package:another_telephony/telephony.dart';
import 'package:permission_handler/permission_handler.dart';

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

    print("Total SMS fetched: ${messages.length}");

    List<SmsMessage> filtered = messages.where((msg) {
      final body = msg.body?.toLowerCase() ?? '';
      return body.contains("Rs.") ||
          body.contains("transferred") ||
           body.contains("debited from A/C XXXXXX6509 and credited to") ||
           body.contains("A/C XXXXXX6509") ||
           body.contains('Bank Of Baroda') ||
           body.contains("UPI Ref:") ;
            //body.contains("UPI") ;
          // body.contains("transaction") ||
          // body.contains("JM-BOBTXN") ||
          // body.contains("BOBSMS");
    }).toList();

    print("Filtered bank messages: ${filtered.length}");

    setState(() {
      bankMessages = filtered;
    });
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
          return ListTile(
            title: Text(sms.address ?? 'Unknown Sender'),
            subtitle: Text(sms.body ?? ''),
          );
        },
      ),
    );
  }
}
