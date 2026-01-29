import 'package:flutter/material.dart';
import 'package:plan_pay_application/models/bank.dart';

class BankPickerSheet extends StatefulWidget {
  final List<Bank> banks;
  final Function(Bank) onSelected;

  const BankPickerSheet({
    super.key,
    required this.banks,
    required this.onSelected,
  });

  @override
  State<BankPickerSheet> createState() => _BankPickerSheetState();
}

class _BankPickerSheetState extends State<BankPickerSheet> {
  late List<Bank> filteredBanks;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredBanks = widget.banks;

    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        filteredBanks = widget.banks
            .where((bank) => bank.name.toLowerCase().contains(query))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Bank',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Bank list
          Expanded(
            child: ListView.builder(
              itemCount: filteredBanks.length,
              itemBuilder: (_, index) {
                final bank = filteredBanks[index];
                return ListTile(
                  title: Text(bank.name),
                  onTap: () {
                    widget.onSelected(bank);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
