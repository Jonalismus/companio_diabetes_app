import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companio_diabetes_app/screens/pages/foodDairy.dart';
import 'package:intl/intl.dart';

class UserDao {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getUser(String userId) async {
    return await _firestore.collection('users').doc(userId).get();
  }

  Future<void> createUser(String userId, Map<String, dynamic> userData) async {
    await _firestore.collection('users').doc(userId).set(userData);
  }

  Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
    await _firestore.collection('users').doc(userId).update(userData);
  }

  Future<void> deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }

  Stream<QuerySnapshot> getBloodGlucoseReadings(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('blood_glucose_readings')
        .snapshots();
  }

  Future<void> createBloodGlucoseReading(
      String userId, Map<String, dynamic> readingData) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('blood_glucose_readings')
        .add(readingData);
  }

  Future<void> updateBloodGlucoseReading(
      String userId, String readingId, Map<String, dynamic> readingData) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('blood_glucose_readings')
        .doc(readingId)
        .update(readingData);
  }

  Future<void> deleteBloodGlucoseReading(
      String userId, String readingId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('blood_glucose_readings')
        .doc(readingId)
        .delete();
  }

  Stream<QuerySnapshot> getMedicationLogs(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('medication_logs')
        .snapshots();
  }

  Future<void> createMedicationLog(
      String userId, Map<String, dynamic> logData) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('medication_logs')
        .add(logData);
  }

  Future<void> updateMedicationLog(
      String userId, String logId, Map<String, dynamic> logData) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('medication_logs')
        .doc(logId)
        .update(logData);
  }

  Future<void> deleteMedicationLog(String userId, String logId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('medication_logs')
        .doc(logId)
        .delete();
  }

  Stream<QuerySnapshot> getActivityLogs(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('activity_logs')
        .snapshots();
  }

  Future<void> createActivityLog(
      String userId, Map<String, dynamic> logData) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('activity_logs')
        .add(logData);
  }

  Future<void> updateActivityLog(
      String userId, String logId, Map<String, dynamic> logData) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('activity_logs')
        .doc(logId)
        .update(logData);
  }

  Future<void> deleteActivityLog(String userId, String logId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('activity_logs')
        .doc(logId)
        .delete();
  }

  static void checkFirestoreConnection() async {
    try {
      await _firestore.collection('users').doc('user_id').get();
      print("connection succeeded! [${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}]");
    } catch (e) {
      print("connection failed: $e! [(${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}]");
    }
  }

  static Future<void> createMealLog(
      String userId, String logId, MealEntry mealEntry) async {

    //check connection
    checkFirestoreConnection();
    print("create meal log...");

    final mealLogMap = {
      'food_items': mealEntry.foodItems
          .map((item) => {
                'name': item.name,
                'quantity': item.quantity,
                'carbohydrate': item.carbohydrate
              })
          .toList(),
      'carbohydrate_content': mealEntry.foodItems
          .fold(0, (total, item) => total + item.carbohydrate),
      'date_time': Timestamp.fromDate(mealEntry.dateTime),
    };

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('meal_logs')
        .doc(logId)
        .set(mealLogMap);
  }

  static Future<List<MealEntry>> getMealLogsInRange(String userId, DateTime startDate, DateTime endDate) async {
    // check connection
    checkFirestoreConnection();
    print("get meal log...");

    List<MealEntry> mealEntries = [];
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('meal_logs')
        .where('date_time', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date_time', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();

    for (var doc in querySnapshot.docs) {
      MealEntry mealEntry = MealEntry.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      mealEntries.add(mealEntry);
    }

    return mealEntries;
  }

  static Future<List<MealEntry>> getMealLogs(String userId) async {
    // check connection
    checkFirestoreConnection();
    print("get meal log...");

    List<MealEntry> mealEntries = [];
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('meal_logs')
        .get();

    for (var doc in querySnapshot.docs) {
      MealEntry mealEntry = MealEntry.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      mealEntries.add(mealEntry);
    }

    return mealEntries;
  }


  static Future<void> updateMealLog(
      String userId, String logId, MealEntry MealEntry) async {

    //check connection
    checkFirestoreConnection();
    print("update meal log...");

    final mealLogMap = {
      'food_items': MealEntry.foodItems
          .map((item) => {
        'name': item.name,
        'quantity': item.quantity,
        'carbohydrate': item.carbohydrate
      })
          .toList(),
      'carbohydrate_content': MealEntry.foodItems
          .fold(0, (total, item) => total + item.carbohydrate),
      'date_time': MealEntry.dateTime,
    };

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('meal_logs')
        .doc(logId)
        .update(mealLogMap);
  }

  static Future<void> deleteMealLog(String userId, String logId) async {
    // check connection
    checkFirestoreConnection();
    print("delete meal log...");

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('meal_logs')
        .doc(logId)
        .delete();
  }

  Stream<QuerySnapshot> getReminders(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('reminders')
        .snapshots();
  }

  Future<void> createReminder(
      String userId, Map<String, dynamic> reminderData) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('reminders')
        .add(reminderData);
  }

  Future<void> updateReminder(String userId, String reminderId,
      Map<String, dynamic> reminderData) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('reminders')
        .doc(reminderId)
        .update(reminderData);
  }

  Future<void> deleteReminder(String userId, String reminderId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('reminders')
        .doc(reminderId)
        .delete();
  }
}
