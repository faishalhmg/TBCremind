import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tbc_app/theme/app_colors.dart';

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller, String hint) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),
      hintText: hint,
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: AppColors.cardcolor,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

TextField reusableTextField1(String text, TextEditingController controller) {
  return TextField(
    controller: controller,
    cursorColor: Colors.black,
    style: TextStyle(color: Colors.black.withOpacity(0.9)),
    decoration: InputDecoration.collapsed(
      hintText: text,
      hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
    ),
  );
}

TextField reusableTextField3(String text, TextEditingController controller) {
  return TextField(
    controller: controller,
    cursorColor: Colors.black,
    keyboardType: TextInputType.number,
    style: TextStyle(color: Colors.black.withOpacity(0.9)),
    decoration: InputDecoration.collapsed(
      hintText: text,
      hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
    ),
  );
}

TextField reusableTextField4(String text, TextEditingController controller) {
  return TextField(
    controller: controller,
    cursorColor: Colors.black,
    keyboardType: TextInputType.number,
    inputFormatters: [
      LengthLimitingTextInputFormatter(3),
    ],
    style: TextStyle(color: Colors.black.withOpacity(0.9)),
    decoration: InputDecoration.collapsed(
      hintText: text,
      hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
    ),
  );
}

TextField reusableTextField2(String text, TextEditingController controller) {
  return TextField(
    controller: controller,
    cursorColor: Colors.black,
    keyboardType: TextInputType.multiline,
    maxLines: null,
    maxLength: 500,
    style: TextStyle(color: Colors.black.withOpacity(0.9)),
    decoration: InputDecoration.collapsed(
      hintText: text,
      hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
    ),
  );
}

Container ButtonAction(BuildContext context, String title, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        title,
        style: const TextStyle(
            color: AppColors.statusBarColor,
            fontWeight: FontWeight.bold,
            fontSize: 16),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return AppColors.buttonColor;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
    ),
  );
}
