import 'package:flutter/foundation.dart';

class AppStateModel extends ChangeNotifier {
  int _selectedIndex = 0;
  static final AppStateModel _instance = AppStateModel._internal();

  factory AppStateModel() {
    print('AppStateModel factory called');
    return _instance;
  }

  AppStateModel._internal() {
    print('AppStateModel internal constructor called');
  }

  int get getSelectedIndex => _selectedIndex;

  void updateSelectedIndex(int index) {
    print('Updating selected index to $index from navmodel');
    _selectedIndex = index;
    notifyListeners();
  }
}
