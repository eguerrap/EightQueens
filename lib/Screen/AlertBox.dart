import 'package:flutter/material.dart';

class AlertBox{

  static void Alert(BuildContext context, String message){
    AlertDialog dialog = new AlertDialog(
      content: new Text(message),
    );

    showDialog(context: context, child: dialog);
  }
}