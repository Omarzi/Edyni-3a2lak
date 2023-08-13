import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  String hint;
  FormFieldValidator<String>? correctionHint;
  VoidCallback? ontap;
  IconData? prefixIcon;
  IconData? suffixIcon;
  bool? password;

  TextInputType? keyboardType;
  TextEditingController controller;
  bool? readOnly;
  int? maxLines;
  bool? expands;
  bool? enabled;
  void Function(String)? onChanged;

  CustomTextField(
      {Key? key,
      this.maxLines,
      this.enabled,
      this.onChanged,
      this.expands,
      this.password,
      this.correctionHint,
      required this.hint,
      required this.controller,
      this.ontap,
      this.prefixIcon,
      this.suffixIcon,
      this.keyboardType,
      this.readOnly})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(

        readOnly: widget.readOnly ?? false,
        maxLines: widget.maxLines,
        minLines: widget.maxLines ?? 2 - 1,
        keyboardType: widget.keyboardType,
        obscureText: widget.password != null ? widget.password! : false,
        onChanged: widget.onChanged,
        enabled: widget.enabled ?? true,
        style: TextStyle(color: Colors.black ,),
        decoration: InputDecoration(

          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20) ),
            suffixIcon: widget.suffixIcon != null
                ? IconButton(
                    icon: Icon(widget.suffixIcon!),
                    onPressed: () {
                      setState(() {
                        if (widget.suffixIcon == Icons.visibility) {
                          widget.suffixIcon = Icons.visibility_off;
                        } else {
                          widget.suffixIcon = Icons.visibility;
                        }
                        widget.password = !widget.password!;
                      });
                    },
                  )
                : null,
            prefixIcon:
                widget.prefixIcon != null ? Icon(widget.prefixIcon!) : null,
            contentPadding: const EdgeInsets.all(10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            hintStyle: const TextStyle(color: Colors.grey),
            hintText: widget.hint),
        onTap: widget.ontap,
        controller: widget.controller,
        validator: widget.correctionHint,
      ),
    );
  }
}
