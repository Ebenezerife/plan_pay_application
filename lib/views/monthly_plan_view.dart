import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:plan_pay_application/utilities/currency_formatter.dart';
import 'package:plan_pay_application/view_models/monthly_view_model.dart';
import 'package:plan_pay_application/widgets/bank_picker_sheet.dart';

class MonthlyPlanView extends StatelessWidget {
  MonthlyPlanView({super.key});

  final MonthlyViewModel _monthlyViewModel = Get.put(MonthlyViewModel());
  final NumberFormat nairaFormat = NumberFormat('#,##0', 'en_NG');

  String monthYearName(DateTime dt) => DateFormat('MMM yyyy').format(dt);

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
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // ================= PLAN TITLE =================
              TextField(
                controller: _monthlyViewModel.planTitleController,
                decoration: const InputDecoration(
                  labelText: 'Plan Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // ================= AMOUNT =================
              TextField(
                controller: _monthlyViewModel.amountToSpreadController,
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
                  _monthlyViewModel.amountToSpreadController.value =
                      TextEditingValue(
                    text: formatted,
                    selection:
                        TextSelection.collapsed(offset: formatted.length),
                  );
                },
              ),
              const SizedBox(height: 20),

              // ================= MONTHS =================
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

              // ================= PREVIEW =================
              Obx(
                () => Text(
                  'Monthly Payment: ${CurrencyFormatter.format(_monthlyViewModel.monthlyPayment.value)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ================= BANK PICKER =================
              TextField(
                controller: _monthlyViewModel.bankNameController,
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
                      banks: _monthlyViewModel.banks,
                      onSelected: (bank) {
                        _monthlyViewModel.selectedBank.value = bank;
                        _monthlyViewModel.bankNameController.text = bank.name;
                        _monthlyViewModel.fetchAccountName();
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // ================= ACCOUNT NUMBER =================
              TextField(
                controller: _monthlyViewModel.accountNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Account Number',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => _monthlyViewModel.fetchAccountName(),
              ),
              const SizedBox(height: 10),

              // ================= ACCOUNT NAME =================
              Obx(
                () => _monthlyViewModel.isFetchingAccountName.value
                    ? const LinearProgressIndicator()
                    : TextField(
                        controller:
                            _monthlyViewModel.accountNameController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Account Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
              ),
              const SizedBox(height: 20),

              // ================= PAYMENT DAY =================
              Obx(
                () => DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Preferred Payment Day',
                    border: OutlineInputBorder(),
                  ),
                  value: _monthlyViewModel.selectedDay.value,
                  items: _monthlyViewModel.allowedDays
                      .map(
                        (day) => DropdownMenuItem(
                          value: day,
                          child: Text(day),
                        ),
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

              // ================= START MONTH =================
              Obx(
                () => DropdownButtonFormField<DateTime>(
                  decoration: const InputDecoration(
                    labelText: 'Start Month',
                    border: OutlineInputBorder(),
                  ),
                  value: _monthlyViewModel.selectedMonth.value,
                  items: _monthlyViewModel.allowedMonths
                      .map(
                        (month) => DropdownMenuItem(
                          value: month,
                          child: Text(monthYearName(month)),
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

              // ================= CREATE BUTTON =================
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

// THIS IS THE CORRECT CODE THAT MAKE SURE ALL FIELDS ARE FILLED BEFORE CREATING A MONTHLY PLAN

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// import 'package:plan_pay_application/utilities/currency_formatter.dart';
// import 'package:plan_pay_application/view_models/monthly_view_model.dart';
// import 'package:plan_pay_application/widgets/bank_picker_sheet.dart';

// class MonthlyPlanView extends StatelessWidget {
//   MonthlyPlanView({super.key});

//   final MonthlyViewModel _monthlyViewModel = Get.put(MonthlyViewModel());
//   final _formKey = GlobalKey<FormState>();

//   final NumberFormat nairaFormat = NumberFormat('#,##0', 'en_NG');

//   String monthYearName(DateTime dt) => DateFormat('MMM yyyy').format(dt);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'CREATE MONTHLY PLAN',
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
//                   controller: _monthlyViewModel.planTitleController,
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
//                   controller: _monthlyViewModel.amountToSpreadController,
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
//                     _monthlyViewModel.amountToSpreadController.value =
//                         TextEditingValue(
//                       text: formatted,
//                       selection: TextSelection.collapsed(
//                         offset: formatted.length,
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 20),

//                 // ================= NUMBER OF MONTHS =================
//                 TextFormField(
//                   controller: _monthlyViewModel.numberOfMonthsController,
//                   keyboardType: TextInputType.number,
//                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                   decoration: const InputDecoration(
//                     labelText: 'Number Of Months',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Number of months is required';
//                     }
//                     if (int.tryParse(value) == null ||
//                         int.parse(value) <= 0) {
//                       return 'Enter a valid number';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),

//                 // ================= MONTHLY PREVIEW =================
//                 Obx(
//                   () => Text(
//                     'Monthly Payment: ${CurrencyFormatter.format(_monthlyViewModel.monthlyPayment.value)}',
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // ================= BANK PICKER =================
//                 TextFormField(
//                   controller: _monthlyViewModel.bankNameController,
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
//                         banks: _monthlyViewModel.banks,
//                         onSelected: (bank) {
//                           _monthlyViewModel.selectedBank.value = bank;
//                           _monthlyViewModel.bankNameController.text =
//                               bank.name;
//                           _monthlyViewModel.fetchAccountName();
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
//                       _monthlyViewModel.accountNumberController,
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
//                       _monthlyViewModel.fetchAccountName(),
//                 ),
//                 const SizedBox(height: 10),

//                 // ================= ACCOUNT NAME =================
//                 Obx(
//                   () => _monthlyViewModel.isFetchingAccountName.value
//                       ? const LinearProgressIndicator()
//                       : TextFormField(
//                           controller:
//                               _monthlyViewModel.accountNameController,
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
//                     value: _monthlyViewModel.selectedDay.value,
//                     validator: (value) =>
//                         value == null
//                             ? 'Please select payment day'
//                             : null,
//                     items: _monthlyViewModel.allowedDays
//                         .map(
//                           (day) => DropdownMenuItem(
//                             value: day,
//                             child: Text(day),
//                           ),
//                         )
//                         .toList(),
//                     onChanged: (value) {
//                       if (value != null) {
//                         _monthlyViewModel.selectedDay.value = value;
//                       }
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // ================= START MONTH =================
//                 Obx(
//                   () => DropdownButtonFormField<DateTime>(
//                     decoration: const InputDecoration(
//                       labelText: 'Start Month',
//                       border: OutlineInputBorder(),
//                     ),
//                     value: _monthlyViewModel.selectedMonth.value,
//                     validator: (value) =>
//                         value == null
//                             ? 'Please select start month'
//                             : null,
//                     items: _monthlyViewModel.allowedMonths
//                         .map(
//                           (month) => DropdownMenuItem(
//                             value: month,
//                             child: Text(monthYearName(month)),
//                           ),
//                         )
//                         .toList(),
//                     onChanged: (value) {
//                       if (value != null) {
//                         _monthlyViewModel.selectedMonth.value = value;
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
//                         _monthlyViewModel.createMonthlyPlan();
//                       } else {
//                         Get.snackbar(
//                           'Incomplete Form',
//                           'Please fill all required fields',
//                           snackPosition: SnackPosition.BOTTOM,
//                         );
//                       }
//                     },
//                     child: const Text(
//                       'Create Plan',
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

