String indentCost(int input) {
  String output = "";
  while (input > 0) {
    output = "${input % 10}$output";
    input ~/= 10;
  }
  if (output.length > 3) {
    output =
        "${output.substring(0, output.length - 3)},${output.substring(output.length - 3)}";
  }
  if (output.length > 6) {
    output =
        "${output.substring(0, output.length - 6)},${output.substring(output.length - 6)}";
  }
  if (output.length > 9) {
    output =
        "${output.substring(0, output.length - 9)},${output.substring(output.length - 9)}";
  }

  return "₹ $output";
}


String? validatePhone(String value) {
  Pattern pattern = r'''^[6-9][0-9]{9}$''';
  RegExp regExp = RegExp(pattern as String);
  if (value.isEmpty) {
    return 'Please enter a mobile number.';
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter valid mobile number.';
  }
  return null;
}

String getDocId({DateTime? time}) {
  // 11:59:59.000 PM on 12/12/2999
  int now = time == null
      ? DateTime.now().millisecondsSinceEpoch
      : time.millisecondsSinceEpoch;
  return (32503636799000 - now).toString();
}
