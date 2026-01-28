import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:plan_pay_application/utilities/currency_formatter.dart';
import 'package:plan_pay_application/view_models/monthly_view_model.dart';

class MonthlyPlanView extends StatelessWidget {
  MonthlyPlanView({super.key});

  final MonthlyViewModel _monthlyViewModel = Get.put(MonthlyViewModel());

  final NumberFormat nairaFormat = NumberFormat('#,##0', 'en_NG');

  String monthYearName(DateTime dt) {
    return DateFormat('MMM yyyy').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CREATE MONTHLY PLAN',
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
                controller: _monthlyViewModel.planTitleController,
                decoration: const InputDecoration(
                  labelText: 'Plan Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Amount To Spread (formatted)
              TextField(
                controller: _monthlyViewModel.amountToSpreadController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Amount To Spread',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  final numericValue = value.replaceAll(',', '');

                  if (numericValue.isEmpty) {
                    _monthlyViewModel.amountToSpreadController.clear();
                    return;
                  }

                  final formatted = nairaFormat.format(int.parse(numericValue));

                  _monthlyViewModel.amountToSpreadController.value =
                      TextEditingValue(
                        text: formatted,
                        selection: TextSelection.collapsed(
                          offset: formatted.length,
                        ),
                      );
                  // monthlyPayment recalculates automatically via listener
                },
              ),
              const SizedBox(height: 20),

              // Number of Months
              TextField(
                controller: _monthlyViewModel.numberOfMonthsController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Number Of Months',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Live Monthly Payment Preview
              Obx(
                () => Text(
                  'Monthly Payment: ${CurrencyFormatter.format(_monthlyViewModel.monthlyPayment.value)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Account Number
              TextField(
                controller: _monthlyViewModel.accountNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Account Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Account Name
              TextField(
                controller: _monthlyViewModel.accountNameController,
                decoration: const InputDecoration(
                  labelText: 'Account Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Bank Name
              TextField(
                controller: _monthlyViewModel.bankNameController,
                decoration: const InputDecoration(
                  labelText: 'Bank Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Preferred Payment Day
              Obx(
                () => DropdownButtonFormField<String>(
                  value: _monthlyViewModel.selectedDay.value,
                  decoration: const InputDecoration(
                    labelText: 'Preferred Payment Day',
                    border: OutlineInputBorder(),
                  ),
                  items: _monthlyViewModel.allowedDays
                      .map(
                        (day) => DropdownMenuItem(value: day, child: Text(day)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _monthlyViewModel.selectedDay.value = value;
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Start Month
              Obx(
                () => DropdownButtonFormField<DateTime>(
                  value: _monthlyViewModel.selectedMonth.value,
                  decoration: const InputDecoration(
                    labelText: 'Start Month',
                    border: OutlineInputBorder(),
                  ),
                  items: _monthlyViewModel.allowedMonths
                      .map(
                        (monthDt) => DropdownMenuItem(
                          value: monthDt,
                          child: Text(monthYearName(monthDt)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _monthlyViewModel.selectedMonth.value = value;
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
                  onPressed: _monthlyViewModel.createMonthlyPlan,
                  child: const Text(
                    'Create Plan',
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
