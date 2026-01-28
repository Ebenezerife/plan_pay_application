import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:plan_pay_application/utilities/currency_formatter.dart';
import 'package:plan_pay_application/view_models/weekly_view_model.dart';

class WeeklyPlanView extends StatelessWidget {
  WeeklyPlanView({super.key});

  final WeeklyViewModel _weeklyViewModel = Get.put(WeeklyViewModel());
  final NumberFormat nairaFormat = NumberFormat('#,##0', 'en_NG');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CREATE WEEKLY PLAN',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.05,
            color: Colors.green,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Plan Title
              TextField(
                controller: _weeklyViewModel.planTitleController,
                decoration: const InputDecoration(
                  labelText: 'Plan Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Amount To Spread
              TextField(
                controller: _weeklyViewModel.amountToSpreadController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Amount To Spread',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  final numericValue = value.replaceAll(',', '');

                  if (numericValue.isEmpty) {
                    _weeklyViewModel.amountToSpreadController.clear();
                    return;
                  }

                  final formatted =
                      nairaFormat.format(int.parse(numericValue));

                  _weeklyViewModel.amountToSpreadController.value =
                      TextEditingValue(
                    text: formatted,
                    selection:
                        TextSelection.collapsed(offset: formatted.length),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Number of Weeks
              TextField(
                controller: _weeklyViewModel.numberOfWeeksController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Number Of Weeks',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Weekly Payment Preview
              Obx(
                () => Text(
                  'Weekly Payment: ${CurrencyFormatter.format(_weeklyViewModel.weeklyPayment.value)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Account Number
              TextField(
                controller: _weeklyViewModel.accountNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Your Preferred Account Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Account Name
              TextField(
                controller: _weeklyViewModel.accountNameController,
                decoration: const InputDecoration(
                  labelText: 'Account Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Bank Name
              TextField(
                controller: _weeklyViewModel.bankNameController,
                decoration: const InputDecoration(
                  labelText: 'Bank Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Preferred Payment Day
              Obx(
                () => DropdownButtonFormField<String>(
                  value: _weeklyViewModel.selectedDay.value,
                  decoration: const InputDecoration(
                    labelText: 'Preferred Payment Day',
                    border: OutlineInputBorder(),
                  ),
                  items: _weeklyViewModel.allowedDays
                      .map(
                        (day) => DropdownMenuItem(
                          value: day,
                          child: Text(day),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _weeklyViewModel.selectedDay.value = value;
                    }
                  },
                ),
              ),
              const SizedBox(height: 30),

              // Create Plan Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _weeklyViewModel.createWeeklyPlan,
                  child: const Text(
                    'Create Weekly Plan',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
