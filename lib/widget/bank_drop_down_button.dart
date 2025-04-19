import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class BankDropDownButton extends StatelessWidget {
  final String? selectedBank;
  final ValueChanged<String?> onChanged;

  const BankDropDownButton({
    super.key,
    required this.selectedBank,
    required this.onChanged,
  });

  final List<String> items = const [
    'Bank Of Baroda',
    'State Bank of India',
    'Bank of India',
    'HDFC Bank',
    'ICICI Bank',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: const Text(
          'Select Bank',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        value: selectedBank,
        onChanged: onChanged,
        items: items
            .map(
              (item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        )
            .toList(),
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400, width: 1.2),
          ),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 24,
            color: Colors.indigo,
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              )
            ],
          ),
          elevation: 3,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
