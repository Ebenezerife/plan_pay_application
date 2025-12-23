import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_pay_application/view_models/weekly_view_model.dart';

class WeeklyPlanView extends StatelessWidget {
  final WeeklyViewModel _weeklyViewModel = Get.put(WeeklyViewModel());
  WeeklyPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weekly Plan View')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: _weeklyViewModel.planTitleController,
                decoration: InputDecoration(
                  labelText: 'Plan Title',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),
              TextField(
                controller: _weeklyViewModel.amountToSpreadController,
                decoration: InputDecoration(
                  labelText: 'Amount To Spread',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _weeklyViewModel.calculateWeeklyPayment();
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: _weeklyViewModel.numberOfWeeksController,
                decoration: InputDecoration(
                  labelText: 'Number Of Weeks',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _weeklyViewModel.calculateWeeklyPayment();
                },
              ),
              SizedBox(height: 20),
              Obx(
                () => Text(
                  'Weekly Payment: ${_weeklyViewModel.weeklyPayment.value}',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _weeklyViewModel.accountNumberController,
                decoration: InputDecoration(
                  labelText: 'Your Preferred Account Number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _weeklyViewModel.accountNameController,
                decoration: InputDecoration(
                  labelText: 'Account Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _weeklyViewModel.bankNameController,
                decoration: InputDecoration(
                  labelText: 'Bank Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Obx(
                () => DropdownButton(
                  value: _weeklyViewModel.selectedPayDay.value,
                  items: _weeklyViewModel.paymentDay.map((day) {
                    return DropdownMenuItem(value: day, child: Text(day));
                  }).toList(),
                  onChanged: (value) {
                    _weeklyViewModel.selectedPayDay.value =
                        value!; // if you did not add =value!, the number of days won't update when you change it e.g, it was monday before, if you click tuesday, it will still display monday
                  },
                ),
              ),
              // Obx(
              //   () => DropdownButton(
              //     value: _weeklyViewModel.paymentDay.value,
              //     items: [
              //       DropdownMenuItem(value: 'Monday', child: Text('Monday')),
              //       DropdownMenuItem(value: 'Tuesday', child: Text('Tuesday')),
              //       DropdownMenuItem(
              //         value: 'Wednesday',
              //         child: Text('Wednesday'),
              //       ),
              //       DropdownMenuItem(
              //         value: 'Thursday',
              //         child: Text('Thursday'),
              //       ),
              //       DropdownMenuItem(value: 'Friday', child: Text('Friday')),
              //       DropdownMenuItem(
              //         value: 'Saturday',
              //         child: Text('Saturday'),
              //       ),
              //       DropdownMenuItem(value: 'Sunday', child: Text('Sunday')),
              //     ],
              //     onChanged: (value) {
              //       _weeklyViewModel.selectedPaymentDay(value!);
              //     },
              //   ),
              // ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _weeklyViewModel.createWeeklyPlan();
                  // Get.back(); // commented this line to test onCreatePlanClicked navigation to home
                  _weeklyViewModel.onCreatePlanClicked();
                },
                child: Text('Create Weekly Plan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
