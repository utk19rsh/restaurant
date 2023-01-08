import 'package:shared_preferences/shared_preferences.dart';

class Backend {
  setPreferences(String uID) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("uID", uID);
  }
}
