import 'package:flutter/foundation.dart';

class AppProvider extends ChangeNotifier {
  // Add state management properties here
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
