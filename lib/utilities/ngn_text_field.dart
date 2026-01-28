import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

typedef NGNValueChanged = void Function(double value);

class NGNInputField extends StatefulWidget {
  final String labelText;
  final TextEditingController? controller;
  final NGNValueChanged? onChanged;
  final bool autoFocus;

  const NGNInputField({
    super.key,
    this.labelText = 'Amount (NGN)',
    this.controller,
    this.onChanged,
    this.autoFocus = false,
  });

  @override
  State<NGNInputField> createState() => _NGNInputFieldState();
}

class _NGNInputFieldState extends State<NGNInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_handleChange);
  }

  void _handleChange() {
    final text = _controller.text;
    final numericString = text.replaceAll(RegExp(r'[^0-9]'), '');
    final value = numericString.isEmpty ? 0.0 : double.parse(numericString);

    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  void clear() {
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.removeListener(_handleChange);
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: widget.autoFocus,
      keyboardType: TextInputType.number,
      inputFormatters: [
        CurrencyInputFormatter(
          leadingSymbol: '₦',
          thousandSeparator: ThousandSeparator.Comma,
          mantissaLength: 0,
          useSymbolPadding: true,
        ),
      ],
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'currency_formatter.dart';

// typedef OnAmountChanged = void Function(double amount);

// class NGNTextField extends StatefulWidget {
//   final TextEditingController? controller;
//   final String labelText;
//   final OnAmountChanged? onChanged;

//   const NGNTextField({
//     super.key,
//     this.controller,
//     this.labelText = 'Amount (NGN)',
//     this.onChanged,
//   });

//   @override
//   State<NGNTextField> createState() => _NGNTextFieldState();
// }

// class _NGNTextFieldState extends State<NGNTextField> {
//   late TextEditingController _controller;
//   bool _isFormatting = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = widget.controller ?? TextEditingController();
//     _controller.addListener(_formatText);
//   }

//   void _formatText() {
//     if (_isFormatting) return;
//     _isFormatting = true;

//     final text = _controller.text;
//     final selectionStart = _controller.selection.baseOffset;

//     // Remove all non-digit characters
//     final numericString = text.replaceAll(RegExp(r'[^0-9]'), '');
//     if (numericString.isEmpty) {
//       _controller.clear();
//       widget.onChanged?.call(0);
//       _isFormatting = false;
//       return;
//     }

//     // Convert to double
//     final value = double.parse(numericString);

//     // Format NGN
//     final formatted = CurrencyFormatter.format(value);

//     // Calculate new cursor position
//     int offset = formatted.length - (text.length - selectionStart);
//     if (offset < 0) offset = 0;
//     if (offset > formatted.length) offset = formatted.length;

//     _controller.value = TextEditingValue(
//       text: formatted,
//       selection: TextSelection.collapsed(offset: offset),
//     );

//     // Notify parent
//     widget.onChanged?.call(value);

//     _isFormatting = false;
//   }

//   @override
//   void dispose() {
//     _controller.removeListener(_formatText);
//     if (widget.controller == null) _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: _controller,
//       keyboardType: TextInputType.number,
//       decoration: InputDecoration(
//         labelText: widget.labelText,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//     );
//   }
// }
