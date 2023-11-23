import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FoodDairyPage extends StatefulWidget {
  const FoodDairyPage({super.key});

  @override
  State<FoodDairyPage> createState() => _FoodDairyPageState();
}

class FoodItem {
  String name;
  String quantity;

  FoodItem({required this.name, required this.quantity});
}

class _FoodDairyPageState extends State<FoodDairyPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final List<FoodItem> _foodItems = [];

  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _foodQuantityController = TextEditingController();

  void _submitEntry() {
    String date = _dateController.text;
    String time = _timeController.text;

    print('Date: $date');
    print('Time: $time');

    // Print each food item
    for (FoodItem foodItem in _foodItems) {
      print('Food Name: ${foodItem.name}, Quantity: ${foodItem.quantity}');
    }

    // You can save the information to a database or perform other processing

    // Clear input fields and food items list
    _dateController.clear();
    _timeController.clear();
    _foodNameController.clear();
    _foodQuantityController.clear();
    _foodItems.clear();

    // Close the dialog
    Navigator.of(context).pop();
  }

  void _addFoodItem() {
    String foodName = _foodNameController.text;
    String foodQuantity = _foodQuantityController.text;

    // Add food item to the list
    _foodItems.add(FoodItem(name: foodName, quantity: foodQuantity));

    // Clear input fields
    _foodNameController.clear();
    _foodQuantityController.clear();

    // Force UI refresh
    setState(() {});
  }

  Future<void> _pickDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        DateTime pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        String formattedDateTime =
            DateFormat('yyyy-MM-dd HH:mm').format(pickedDateTime);

        // Update date and time controllers
        _dateController.text = formattedDateTime;
        _timeController.text = formattedDateTime;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Enter Food Information'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Date & Time input
                    ElevatedButton(
                      onPressed: _pickDateTime,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Select Date & Time'),
                    ),
                    const SizedBox(height: 20.0),
                    // Food item input
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _foodNameController,
                            decoration:
                                const InputDecoration(labelText: 'Food Name'),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: TextFormField(
                            controller: _foodQuantityController,
                            decoration:
                                const InputDecoration(labelText: 'Quantity'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        IconButton(
                          onPressed: _addFoodItem,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    // Display food items list
                    if (_foodItems.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Food Items:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          for (FoodItem foodItem in _foodItems)
                            Text('${foodItem.name}: ${foodItem.quantity}'),
                        ],
                      ),
                  ],
                ),
                actions: [
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
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
