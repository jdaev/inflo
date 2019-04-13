import 'package:shared_preferences/shared_preferences.dart';

class LoginSaver {
  Future<void> saveLogin(String name, String phoneNo, String standard, String syllabus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', name);
    prefs.setString("phone", phoneNo);
    prefs.setString("standard", standard);
    prefs.setString("syllabus", syllabus);
  }
}
