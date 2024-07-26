import 'package:flutter/material.dart';

class TextFields_PaymentMethod extends StatefulWidget {
  final hintText;
  final Icon? pre;
  final Icon? suf;
  final keyboardType;

  TextFields_PaymentMethod(
      {super.key, this.hintText, this.pre, this.suf, this.keyboardType});

  @override
  State<TextFields_PaymentMethod> createState() =>
      _TextFields_PaymentMethodState();
}

class _TextFields_PaymentMethodState extends State<TextFields_PaymentMethod> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xffE4DFDF).withOpacity(0.2),
      ),
      child: TextFormField(
        keyboardType: widget.keyboardType,
        style: TextStyle(fontSize: 18),
        cursorColor: Color(0xffFF9F1A),
        decoration: InputDecoration(
          enabled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Color(0xff6B7280).withOpacity(0.3),
            ),
          ),
          disabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Color(0xff6B7280).withOpacity(0.3))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffFF9F1A)),
              borderRadius: BorderRadius.circular(8)),
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          border: InputBorder.none,
          hintText: widget.hintText,
          prefixIcon: widget.pre,
          suffixIcon: widget.suf,
          hintStyle: TextStyle(color: Color(0xff7A7A7A), fontSize: 17),
        ),
      ),
    );
  }
}
