import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'firestore.dart';
import '../../screens/pages/fooddairy.dart';

class DataProvider with ChangeNotifier {
  late List<MealEntry> _mealEntries;
  bool _isLoaded = false;

  Future<void> loadData() async {
    _mealEntries = await UserDao.getMealLogs(
      FirebaseAuth.instance.currentUser!.uid,
    );
    _isLoaded = true;
    notifyListeners();
  }

  List<MealEntry> get mealEntries => _mealEntries;
  bool get isLoaded => _isLoaded;
}
