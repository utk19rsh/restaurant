import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:utk19rsh/constant.dart';

buildSnackBar(BuildContext context, String? snackMsg) {
  MediaQueryData mqd = MediaQuery.of(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('$snackMsg'),
      backgroundColor: black,
      dismissDirection: DismissDirection.horizontal,
      duration: const Duration(milliseconds: 750),
      elevation: 0,
      padding: const EdgeInsets.fromLTRB(30, 15, 10, 15),
      margin: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: mqd.viewPadding.bottom + mqd.padding.bottom / 2 + 15,
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
