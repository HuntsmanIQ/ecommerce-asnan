import 'package:flutter/material.dart';
import 'package:grostore/configs/style_config.dart';
import 'package:grostore/configs/theme_config.dart';
import 'package:toast/toast.dart';

class ToastUi {
  static simpleToast(context, message) {
    ToastContext().init(context);
    return Toast.show(
      message,
      border: Border.all(color: ThemeConfig.fontColor, width: 1),
      backgroundColor: ThemeConfig.white,
      textStyle: StyleConfig.fs14fwNormal,
      duration: Toast.lengthShort,
      gravity: Toast.bottom,
    );
  }

  static show(BuildContext mainContext, message) {
    showDialog(
        context: mainContext,
        builder: (context) {
          Future.delayed(const Duration(milliseconds: 700))
              .then((value) => Navigator.pop(mainContext));
          return AlertDialog(
            content: Text(
              message,
              style: StyleConfig.fs14fwNormal,
            ),
          );
        });
  }
}
