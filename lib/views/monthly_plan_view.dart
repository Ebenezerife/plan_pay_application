import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:plan_pay_application/view_models/monthly_view_model.dart';

class MonthlyPlanView extends StatelessWidget {
  final MonthlyViewModel _monthlyViewModel = Get.put(MonthlyViewModel());
  MonthlyPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Monthly Plan')),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsGeometry.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: _monthlyViewModel.planTitleController,
                decoration: InputDecoration(
                  labelText: 'Plan Title',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: _monthlyViewModel.amountToSpreadController,
                decoration: InputDecoration(
                  labelText: 'Amount To Spread',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _monthlyViewModel.calculateMonthlyPayment();
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: _monthlyViewModel.numberOfMonthsController,
                decoration: InputDecoration(
                  labelText: 'Number Of Months',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _monthlyViewModel.calculateMonthlyPayment();
                },
              ),
              SizedBox(height: 20),
              Obx(
                () => Text(
                  'Monthly Payment: ${_monthlyViewModel.monthlyPayment.value}',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _monthlyViewModel.accountNumberController,
                decoration: InputDecoration(
                  labelText: 'Your Preferred Account Number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _monthlyViewModel.accountNameController,
                decoration: InputDecoration(
                  labelText: 'Account Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _monthlyViewModel.bankNameController,
                decoration: InputDecoration(
                  labelText: 'Bank Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              Obx(
                () => DropdownButton(
                  value: _monthlyViewModel.selectedPayDate.value,
                  items: _monthlyViewModel.preferredDate.map((day) {
                    return DropdownMenuItem(value: day, child: Text(day));
                  }).toList(),
                  onChanged: (value) {
                    _monthlyViewModel.selectedPayDate.value =
                        value!; // if you did not add =value!, the number of days won't update when you change it e.g, it was monday before, if you click tuesday, it will still display monday
                  },
                ),
              ),
              // Obx(
              //   () => Text(
              //     'Preferred Date To Be Receiving Your Monthly Pay: ${_monthlyViewModel.preferredDate.value}',
              //   ),
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     _monthlyViewModel.showDatePickerDialog();
              //   },
              //   child: Text('Select Preferred Date'),
              // ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _monthlyViewModel.createMonthlyPlan();
                  _monthlyViewModel.onCreatePlanPressed();
                  // Get.back(); // this was the initial thing, but the problem is the values were not resetting
                },
                child: Text('Create Plan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
