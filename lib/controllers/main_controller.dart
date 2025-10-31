import 'package:get/get.dart';

class MainController extends GetxController {
  final RxInt _selectedIndex = 0.obs;
  
  int get selectedIndex => _selectedIndex.value;
  
  void changeTab(int index) {
    _selectedIndex.value = index;
  }
  
  void changeTabIndex(int index) {
    _selectedIndex.value = index;
  }
}
