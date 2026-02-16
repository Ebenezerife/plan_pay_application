import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plan_pay_application/utilities/currency_formatter.dart';
import 'package:plan_pay_application/view_models/weekly_view_model.dart';
import 'package:plan_pay_application/widgets/bank_picker_sheet.dart';

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
          padding: const EdgeInsets.all(20),
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
                  final numeric = value.replaceAll(',', '');
                  if (numeric.isEmpty) return;

                  final formatted = nairaFormat.format(int.parse(numeric));
                  _weeklyViewModel.amountToSpreadController.value =
                      TextEditingValue(
                        text: formatted,
                        selection: TextSelection.collapsed(
                          offset: formatted.length,
                        ),
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

              // Bank Picker
              TextField(
                controller: _weeklyViewModel.bankNameController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Select Bank',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.keyboard_arrow_down),
                ),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => BankPickerSheet(
                      banks: _weeklyViewModel.banks,
                      onSelected: (bank) {
                        _weeklyViewModel.selectedBank.value = bank;
                        _weeklyViewModel.bankNameController.text = bank.name;
                        _weeklyViewModel.fetchAccountName();
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Account Number
              TextField(
                controller: _weeklyViewModel.accountNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Account Number',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => _weeklyViewModel.fetchAccountName(),
              ),
              const SizedBox(height: 10),

              // Account Name
              Obx(
                () => _weeklyViewModel.isFetchingAccountName.value
                    ? const LinearProgressIndicator()
                    : TextField(
                        controller: _weeklyViewModel.accountNameController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Account Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
              ),
              const SizedBox(height: 20),

              // Preferred Payment Day
              Obx(
                () => DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Preferred Payment Day',
                    border: OutlineInputBorder(),
                  ),
                  value: _weeklyViewModel.selectedDay.value,
                  items: _weeklyViewModel.allowedDays
                      .map(
                        (day) => DropdownMenuItem(value: day, child: Text(day)),
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

              // Create Button
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


// THIS IS THE REAL CODE THAT MAKES SURE ALL FIELDS ARE CORRECT BEFORE CREATING A WEEKLY PLAN


// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// import 'package:plan_pay_application/utilities/currency_formatter.dart';
// import 'package:plan_pay_application/view_models/weekly_view_model.dart';
// import 'package:plan_pay_application/widgets/bank_picker_sheet.dart';

// class WeeklyPlanView extends StatelessWidget {
//   WeeklyPlanView({super.key});

//   final WeeklyViewModel _weeklyViewModel = Get.put(WeeklyViewModel());
//   final _formKey = GlobalKey<FormState>();

//   final NumberFormat nairaFormat = NumberFormat('#,##0', 'en_NG');

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'CREATE WEEKLY PLAN',
//           style: TextStyle(
//             fontSize: MediaQuery.of(context).size.width * 0.05,
//             color: Colors.green,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.amberAccent,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 // ================= PLAN TITLE =================
//                 TextFormField(
//                   controller: _weeklyViewModel.planTitleController,
//                   decoration: const InputDecoration(
//                     labelText: 'Plan Title',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) =>
//                       value == null || value.trim().isEmpty
//                           ? 'Plan title is required'
//                           : null,
//                 ),
//                 const SizedBox(height: 20),

//                 // ================= AMOUNT =================
//                 TextFormField(
//                   controller: _weeklyViewModel.amountToSpreadController,
//                   keyboardType: TextInputType.number,
//                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                   decoration: const InputDecoration(
//                     labelText: 'Amount To Spread',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) =>
//                       value == null || value.isEmpty
//                           ? 'Amount is required'
//                           : null,
//                   onChanged: (value) {
//                     final numeric = value.replaceAll(',', '');
//                     if (numeric.isEmpty) return;

//                     final formatted =
//                         nairaFormat.format(int.parse(numeric));
//                     _weeklyViewModel.amountToSpreadController.value =
//                         TextEditingValue(
//                       text: formatted,
//                       selection:
//                           TextSelection.collapsed(offset: formatted.length),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 20),

//                 // ================= NUMBER OF WEEKS =================
//                 TextFormField(
//                   controller: _weeklyViewModel.numberOfWeeksController,
//                   keyboardType: TextInputType.number,
//                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                   decoration: const InputDecoration(
//                     labelText: 'Number Of Weeks',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Number of weeks is required';
//                     }
//                     if (int.tryParse(value) == null ||
//                         int.parse(value) <= 0) {
//                       return 'Enter a valid number';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),

//                 // ================= WEEKLY PREVIEW =================
//                 Obx(
//                   () => Text(
//                     'Weekly Payment: ${CurrencyFormatter.format(_weeklyViewModel.weeklyPayment.value)}',
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // ================= BANK PICKER =================
//                 TextFormField(
//                   controller: _weeklyViewModel.bankNameController,
//                   readOnly: true,
//                   decoration: const InputDecoration(
//                     labelText: 'Select Bank',
//                     border: OutlineInputBorder(),
//                     suffixIcon: Icon(Icons.keyboard_arrow_down),
//                   ),
//                   validator: (value) =>
//                       value == null || value.isEmpty
//                           ? 'Please select a bank'
//                           : null,
//                   onTap: () {
//                     showModalBottomSheet(
//                       context: context,
//                       isScrollControlled: true,
//                       builder: (_) => BankPickerSheet(
//                         banks: _weeklyViewModel.banks,
//                         onSelected: (bank) {
//                           _weeklyViewModel.selectedBank.value = bank;
//                           _weeklyViewModel.bankNameController.text =
//                               bank.name;
//                           _weeklyViewModel.fetchAccountName();
//                           Navigator.pop(context);
//                         },
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 20),

//                 // ================= ACCOUNT NUMBER =================
//                 TextFormField(
//                   controller:
//                       _weeklyViewModel.accountNumberController,
//                   keyboardType: TextInputType.number,
//                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                   decoration: const InputDecoration(
//                     labelText: 'Account Number',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Account number is required';
//                     }
//                     if (value.length != 10) {
//                       return 'Account number must be 10 digits';
//                     }
//                     return null;
//                   },
//                   onChanged: (_) =>
//                       _weeklyViewModel.fetchAccountName(),
//                 ),
//                 const SizedBox(height: 10),

//                 // ================= ACCOUNT NAME =================
//                 Obx(
//                   () => _weeklyViewModel.isFetchingAccountName.value
//                       ? const LinearProgressIndicator()
//                       : TextFormField(
//                           controller:
//                               _weeklyViewModel.accountNameController,
//                           readOnly: true,
//                           decoration: const InputDecoration(
//                             labelText: 'Account Name',
//                             border: OutlineInputBorder(),
//                           ),
//                           validator: (value) =>
//                               value == null || value.isEmpty
//                                   ? 'Account name not resolved'
//                                   : null,
//                         ),
//                 ),
//                 const SizedBox(height: 20),

//                 // ================= PAYMENT DAY =================
//                 Obx(
//                   () => DropdownButtonFormField<String>(
//                     decoration: const InputDecoration(
//                       labelText: 'Preferred Payment Day',
//                       border: OutlineInputBorder(),
//                     ),
//                     value: _weeklyViewModel.selectedDay.value,
//                     validator: (value) =>
//                         value == null
//                             ? 'Please select payment day'
//                             : null,
//                     items: _weeklyViewModel.allowedDays
//                         .map(
//                           (day) => DropdownMenuItem(
//                             value: day,
//                             child: Text(day),
//                           ),
//                         )
//                         .toList(),
//                     onChanged: (value) {
//                       if (value != null) {
//                         _weeklyViewModel.selectedDay.value = value;
//                       }
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 30),

//                 // ================= CREATE BUTTON =================
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         _weeklyViewModel.createWeeklyPlan();
//                       } else {
//                         Get.snackbar(
//                           'Incomplete Form',
//                           'Please fill all required fields',
//                           snackPosition: SnackPosition.BOTTOM,
//                         );
//                       }
//                     },
//                     child: const Text(
//                       'Create Weekly Plan',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
