import 'package:flutter/widgets.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class MainNavigationProwider with ChangeNotifier {
  final PersistentTabController navController =
      PersistentTabController(initialIndex: 0);

  chaneIndexOfNavbar(int index) {
    navController.jumpToTab(index);
    notifyListeners();
  }
}
