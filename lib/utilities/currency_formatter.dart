import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _ngnFormatter = NumberFormat.currency(
    locale: 'en_NG',
    symbol: '₦',
    decimalDigits: 2,
  );

  static String format(double amount) {
    return _ngnFormatter.format(amount);
  }
}
