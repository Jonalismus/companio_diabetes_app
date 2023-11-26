import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companio_diabetes_app/utilis/dao/loadData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../utilis/dao/firestore.dart';

class FoodDairyPage extends StatefulWidget {
  const FoodDairyPage({Key? key}) : super(key: key);

  @override
  State<FoodDairyPage> createState() => _FoodDairyPageState();
}

class FoodItem {
  String name;
  int quantity;
  int carbohydrate; //TODO

  FoodItem(
      {required this.name, required this.quantity, required this.carbohydrate});

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      name: map['name'],
      quantity: map['quantity'],
      carbohydrate: map['carbohydrate'],
    );
  }
}

class MealEntry {
  DateTime dateTime;
  List<FoodItem> foodItems;
  String uuid;

  MealEntry(
      {required this.dateTime, required this.foodItems, required this.uuid});

  factory MealEntry.fromMap(Map<String, dynamic> map, String logId) {
    var foodItemsList = (map['food_items'] as List).map((itemMap) {
      return FoodItem.fromMap(itemMap as Map<String, dynamic>);
    }).toList();

    return MealEntry(
      dateTime: (map['date_time'] as Timestamp).toDate(),
      foodItems: foodItemsList,
      uuid: logId,
    );
  }
}

class _FoodDairyPageState extends State<FoodDairyPage> {
  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _foodQuantityController = TextEditingController();
  final List<FoodItem> _foodItems = [];

  bool _isAddingFoodItem = false;

  List<MealEntry> _mealEntries = [];
  DateTime _selectedDateTime = DateTime.now();
  Icon _iconInUse = const Icon(Icons.add);

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
      });
    }
  }

  Future<void> _pickTime() async {
    DateTime now = DateTime.now();
    TimeOfDay initialTime = TimeOfDay.fromDateTime(_selectedDateTime);
    bool isToday = _selectedDateTime.year == now.year &&
        _selectedDateTime.month == now.month &&
        _selectedDateTime.day == now.day;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (!mounted) return;

    if (pickedTime != null &&
        (!isToday ||
            (isToday &&
                (pickedTime.hour < now.hour ||
                    (pickedTime.hour == now.hour &&
                        pickedTime.minute <= now.minute))))) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    } else if (pickedTime != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Invalid Time"),
            content: const Text(
                "You cannot select a time later than the current time."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _toggleAddFoodItem() {
    setState(() {
      _isAddingFoodItem = !_isAddingFoodItem;
      if (!_isAddingFoodItem) {
        _foodNameController.clear();
        _foodQuantityController.clear();
      }
      _iconInUse = (_iconInUse.icon == Icons.add)
          ? const Icon(Icons.cancel)
          : const Icon(Icons.add);
    });
  }

  void _addFoodItemToMealEntry(MealEntry mealEntry) {
    _addFoodItem();
    mealEntry.foodItems.add(_foodItems.first);
    _foodItems.clear();
  }

  void _submitEntry() async {
    // Print each food item
    for (FoodItem foodItem in _foodItems) {
      print('Food Name: ${foodItem.name}, Quantity: ${foodItem.quantity}');
    }

    // You can save the information to a database or perform other processing
    MealEntry mealEntry = MealEntry(
        dateTime: _selectedDateTime,
        foodItems: List.from(_foodItems),
        uuid: const Uuid().v4());
    _mealEntries.add(mealEntry);

    UserDao.createMealLog(
        FirebaseAuth.instance.currentUser!.uid, mealEntry.uuid, mealEntry);

    // Clear input fields and food items list
    _foodNameController.clear();
    _foodQuantityController.clear();
    _foodItems.clear();

    // Close dialog
    Navigator.of(context).pop();

    // Force UI refresh
    setState(() {});
  }

  void _cancelSubmitEntry() {
    // Print each food item
    for (FoodItem foodItem in _foodItems) {
      print('Food Name: ${foodItem.name}, Quantity: ${foodItem.quantity}');
    }

    // Clear input fields and food items list
    _foodNameController.clear();
    _foodQuantityController.clear();
    _foodItems.clear();

    // Close the dialog
    Navigator.of(context).pop();

    // Force UI refresh
    setState(() {});
  }

  void _addFoodItem() {
    _foodItems.add(
      FoodItem(
        name: _foodNameController.text,
        quantity: int.parse(_foodQuantityController.text),
        carbohydrate: 0, //TODO
      ),
    );

    _foodNameController.clear();
    _foodQuantityController.clear();
  }

  Widget _buildTable() {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  _selectedDateTime =
                      _selectedDateTime.subtract(const Duration(days: 1));
                });
              },
            ),
            Text(
              'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDateTime)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                DateTime tomorrow =
                    _selectedDateTime.add(const Duration(days: 1));
                DateTime now = DateTime.now();

                if (tomorrow.isBefore(now) || tomorrow.isAtSameMomentAs(now)) {
                  setState(() {
                    _selectedDateTime = tomorrow;
                  });
                }
              },
            ),
          ],
        ),
        ..._mealEntries
            .where((mealEntry) =>
                mealEntry.dateTime.year == _selectedDateTime.year &&
                mealEntry.dateTime.month == _selectedDateTime.month &&
                mealEntry.dateTime.day == _selectedDateTime.day)
            .map((mealEntry) => _buildMealEntry(mealEntry))
            .toList(),
      ]),
    );
  }

  Widget _buildMealEntry(MealEntry mealEntry) {
    return ExpansionTile(
      title: Text('Meal at ${DateFormat('HH:mm').format(mealEntry.dateTime)}'),
      children: [
        ...mealEntry.foodItems
            .map((item) => Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: TextEditingController(text: item.name),
                        readOnly: true,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: TextEditingController(
                            text: item.quantity.toString()),
                        readOnly: true,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          mealEntry.foodItems.remove(item);
                          UserDao.updateMealLog(FirebaseAuth.instance.currentUser!.uid, mealEntry.uuid, mealEntry);
                        });
                      },
                    ),
                  ],
                ))
            .toList(),
        if (_isAddingFoodItem)
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: _foodNameController,
                  decoration: const InputDecoration(labelText: 'Food Name'),
                ),
              ),
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _foodQuantityController,
                  decoration: const InputDecoration(labelText: 'Food Quantity'),
                  keyboardType: TextInputType.number,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  setState(() {
                    _addFoodItemToMealEntry(mealEntry);
                    _toggleAddFoodItem();
                    UserDao.updateMealLog(FirebaseAuth.instance.currentUser!.uid, mealEntry.uuid, mealEntry);
                  });
                },
              ),
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: _iconInUse,
              onPressed: () => _toggleAddFoodItem(),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _mealEntries.remove(mealEntry);
                  UserDao.deleteMealLog(
                      FirebaseAuth.instance.currentUser!.uid, mealEntry.uuid);
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: true);
    if (!dataProvider.isLoaded) {
      return const CircularProgressIndicator();
    }
    _mealEntries = dataProvider.mealEntries;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const SizedBox(height: 20.0),
          _buildTable(),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: const Text('Log meal'),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _pickDate,
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue,
                                  ),
                                  child: Text(DateFormat('yyyy-MM-dd')
                                      .format(_selectedDateTime)),
                                ),
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _pickTime,
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue,
                                  ),
                                  child: Text(DateFormat('HH:mm')
                                      .format(_selectedDateTime)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          for (var foodItem in _foodItems)
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      '${foodItem.name}: ${foodItem.quantity}'),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _foodItems.remove(foodItem);
                                    });
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _foodNameController,
                                  decoration: const InputDecoration(
                                      labelText: 'Food Name'),
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: TextFormField(
                                  controller: _foodQuantityController,
                                  decoration: const InputDecoration(
                                      labelText: 'Food Quantity'),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              IconButton(
                                onPressed: () => setState(_addFoodItem),
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: _cancelSubmitEntry,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.pink,
                        ),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: _submitEntry,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text('Submit'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
