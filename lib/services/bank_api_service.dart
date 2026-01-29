import 'dart:convert';
import 'package:flutter/foundation.dart'; // <-- for kIsWeb
import 'package:http/http.dart' as http;
import 'package:plan_pay_application/models/bank.dart';

class BankApiService {
  static final String baseUrl = kIsWeb
      ? 'http://localhost:3000' // for Web
      : 'http://192.168.43.11:3000'; // for Android emulator

  Future<List<Bank>> getBanks() async {
    final res = await http.get(Uri.parse('$baseUrl/banks'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((json) => Bank.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch banks');
    }
  }

  Future<String> resolveAccount({
    required String accountNumber,
    required String bankCode,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/resolve-account'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'account_number': accountNumber,
        'bank_code': bankCode,
      }),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['accountName'];
    } else {
      throw Exception('Failed to resolve account');
    }
  }
}
