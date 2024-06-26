import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companio_diabetes_app/screens/pages/sugarIntakeOverview.dart';
import 'package:companio_diabetes_app/utilis/dao/loadData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../utilis/dao/firestore.dart';
import 'dart:convert';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

class FoodDairyPage extends StatefulWidget {
  const FoodDairyPage({Key? key}) : super(key: key);

  @override
  State<FoodDairyPage> createState() => _FoodDairyPageState();
}

class FoodItem {
  String name;
  double quantity;
  double carbohydrate_100g;

  FoodItem(
      {required this.name,
      required this.quantity,
      required this.carbohydrate_100g});

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      name: map['name'],
      quantity: map['quantity'],
      carbohydrate_100g: map['carbohydrate_100g'],
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
  final TextEditingController _foodCarbsController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  String? _editingMealEntryUuid;

  final List<FoodItem> _foodItems = [];

  bool _isAddingFoodItem = false;
  List<MealEntry> _mealEntries = [];
  DateTime _selectedDateTime = DateTime.now();

  void fetchAndFillProductData(String barcode) async {
    var url = Uri.parse(
        'https://world.openfoodfacts.org/api/v2/product/$barcode?fields=product_name,carbohydrates_100g');
    var response = await http.get(url, headers: {'accept': 'application/json'});

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData['product'] != null) {
        var productData = jsonData['product'];
        setState(() {
          _foodNameController.text = productData['product_name'] ?? '';
          double carbs = productData['carbohydrates_100g'] ?? 0.0;
          _foodCarbsController.text = carbs.toString();
        });
      } else {
        _barcodeController.clear();
      }
    }
  }

  Future<String> scanBarcode() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'Abbrechen',
      true,
      ScanMode.BARCODE,
    );

    if (!mounted) return '';

    if (barcodeScanRes == '-1') {
      return '';
    } else {
      return barcodeScanRes;
    }
  }

  void _showBarcodeInputDialog() {
    TextEditingController barcodeInputDialogController =
        TextEditingController();
    barcodeInputDialogController.text = _barcodeController.text;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Barcode eingeben'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  // Navigator.of(context).pop();
                  String scannedBarcode = await scanBarcode();
                  setState(() {
                    _barcodeController.text = scannedBarcode;
                    barcodeInputDialogController.text = _barcodeController.text;
                  });
                },
                child: const Text('Barcode scannen'),
              ),
              TextField(
                controller: barcodeInputDialogController,
                decoration: const InputDecoration(labelText: 'Barcode eingeben'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.pink,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Abbrechen'),
            ),
            TextButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                setState(() {
                  _barcodeController.text = barcodeInputDialogController.text;
                  fetchAndFillProductData(_barcodeController.text);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Bestätigen'),
            ),
          ],
        );
      },
    );
  }

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
      setState(() {});
    } else if (pickedTime != null) {
      _showWarningDialog("Ungültige Zeitangabe",
          "Sie können keinen späteren Zeitpunkt als den aktuellen Zeitpunkt auswählen.");
    }
  }

  void _showWarningDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(VoidCallback onConfirm, String title,
      String content, String button1, String button2) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text(button1),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(button2),
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleAddFoodItem(String mealEntryUuid) {
    setState(() {
      if (_isAddingFoodItem && _editingMealEntryUuid == mealEntryUuid) {
        _isAddingFoodItem = false;
        _editingMealEntryUuid = null;
      } else {
        _isAddingFoodItem = true;
        _editingMealEntryUuid = mealEntryUuid;
      }
      _foodNameController.clear();
      _foodQuantityController.clear();
      _foodCarbsController.clear();
    });
  }

  void _addFoodItemToMealEntry(MealEntry mealEntry) {
    _addFoodItem();
    mealEntry.foodItems.add(_foodItems.first);
    _foodItems.clear();
  }

  void _submitEntry() async {
    if (_foodItems.isEmpty) {
      _showWarningDialog(
          'Fehler', 'Ohne Lebensmittel kann kein Mahlzeiteintrag hinzugefügt werden.');
      return;
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
    _foodCarbsController.clear();
    _foodItems.clear();

    // Close dialog
    Navigator.of(context).pop();

    // Force UI refresh
    setState(() {});
  }

  void _cancelSubmitEntry() {
    // Clear input fields and food items list
    _foodNameController.clear();
    _foodQuantityController.clear();
    _foodCarbsController.clear();
    _foodItems.clear();

    // Close the dialog
    Navigator.of(context).pop();

    // Force UI refresh
    setState(() {});
  }

  void _addFoodItem() {
    if (_foodNameController.text.isEmpty) {
      _showWarningDialog('Fehler', 'Bitte geben Sie einen Lebensmittelnamen ein.');
      return;
    }

    double? quantity = double.tryParse(_foodQuantityController.text);
    if (quantity == null || quantity <= 0) {
      _showWarningDialog('Fehler', 'Bitte geben Sie eine gültige Menge ein.');
      return;
    }

    _foodItems.add(
      FoodItem(
        name: _foodNameController.text,
        quantity: double.parse(_foodQuantityController.text),
        carbohydrate_100g: double.parse(_foodCarbsController.text),
      ),
    );

    _foodNameController.clear();
    _foodQuantityController.clear();
    _foodCarbsController.clear();
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
              '${DateFormat('yyyy-MM-dd').format(_selectedDateTime)}',
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
    bool isEditingThisEntry = _editingMealEntryUuid == mealEntry.uuid;
    Icon actionIcon = isEditingThisEntry ? const Icon(Icons.cancel) : const Icon(Icons.add);
    return ExpansionTile(
      title: Text('Mahlzeit um ${DateFormat('HH:mm').format(mealEntry.dateTime)}'),
      children: [
        ...mealEntry.foodItems
            .map((item) => Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: TextEditingController(text: item.name),
                        readOnly: true,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: TextEditingController(
                            text:
                                '${item.carbohydrate_100g.toString()}g/100g(ml)'),
                        readOnly: true,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: TextEditingController(
                            text: '${item.quantity.toString()}g(ml)'),
                        readOnly: true,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _showConfirmationDialog(() {
                          setState(() {
                            mealEntry.foodItems.remove(item);
                            UserDao.updateMealLog(
                                FirebaseAuth.instance.currentUser!.uid,
                                mealEntry.uuid,
                                mealEntry);
                          });
                        },
                            "Lebensmittel löschen",
                            "Sind Sie sicher, dass Sie dieses Lebensmittel löschen möchten?",
                            "Abbrechen",
                            "Löschen");
                      },
                    ),
                  ],
                ))
            .toList(),
        if (_isAddingFoodItem && isEditingThisEntry)
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _foodNameController,
                  decoration: const InputDecoration(labelText: 'Lebensmittelname'),
                ),
              ),
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: _foodCarbsController,
                  decoration: const InputDecoration(
                      labelText: 'Kohlenhydrate /100g(ml)'),
                  keyboardType: TextInputType.number,
                ),
              ),
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _foodQuantityController,
                  decoration: const InputDecoration(
                      labelText: 'Menge(g,ml)'),
                  keyboardType: TextInputType.number,
                ),
              ),
              IconButton(
                  icon: const Icon(Icons.scanner),
                  onPressed: () {
                    _showBarcodeInputDialog();
                  }),
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  setState(() {
                    _addFoodItemToMealEntry(mealEntry);
                    _toggleAddFoodItem(mealEntry.uuid);
                    UserDao.updateMealLog(
                        FirebaseAuth.instance.currentUser!.uid,
                        mealEntry.uuid,
                        mealEntry);
                  });
                },
              ),
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: actionIcon,
              onPressed: () => _toggleAddFoodItem(mealEntry.uuid),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _showConfirmationDialog(() {
                  setState(() {
                    _mealEntries.remove(mealEntry);
                    UserDao.deleteMealLog(
                        FirebaseAuth.instance.currentUser!.uid, mealEntry.uuid);
                  });
                },
                    "Mahlzeiteintrag löschen",
                    "Sind Sie sicher, dass Sie diesen Mahlzeiteintrag löschen möchten?",
                    "Abbrechen",
                    "Löschen");
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
      return const Center(child: CircularProgressIndicator());
    }
    _mealEntries = dataProvider.mealEntries;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ernährungstagebuch'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, _mealEntries);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const SizedBox(height: 20.0),
          _buildTable(),
        ]),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: const Text('Mahlzeit eintragen'),
                  content: _buildAddMealLogDialogContent(setState),
                  actions: _buildAddMealLogDialogActions(),
                );
              },
            );
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }

  List<Widget> _buildAddMealLogDialogActions() {
    return [
      ElevatedButton(
        onPressed: _cancelSubmitEntry,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.pink,
        ),
        child: const Text('Abbrechen'),
      ),
      ElevatedButton(
        onPressed: _submitEntry,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
        ),
        child: const Text('Abgeben'),
      ),
    ];
  }

  Widget _buildAddMealLogDialogContent(Function setState) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: _pickDate,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                child: Text(DateFormat('yyyy-MM-dd').format(_selectedDateTime)),
              ),
              ElevatedButton(
                onPressed: _pickTime,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                child: Text(DateFormat('HH:mm').format(_selectedDateTime)),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          ..._foodItems.map((foodItem) => Row(
                children: [
                  Expanded(
                    child: Text('${foodItem.name}: ${foodItem.quantity}'),
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
              )),
          const SizedBox(height: 20.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Tooltip(
                message:
                    'Klicken Sie hier, um einen Barcode einzugeben oder zu scannen. Wenn das Lebensmittel keinen Barcode hat, besuchen Sie bitte https://fddb.info/ für dessen Informationen.',
                child: Text('Barcode'),
              ),
              IconButton(
                icon: const Icon(Icons.scanner),
                onPressed: _showBarcodeInputDialog,
              ),
            ],
          ),
          TextFormField(
            controller: _foodNameController,
            decoration: const InputDecoration(labelText: 'Lebensmittelname'),
          ),
          TextFormField(
            controller: _foodCarbsController,
            decoration:
                const InputDecoration(labelText: 'Kohlenhydrate pro 100g(ml)'),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: _foodQuantityController,
            decoration:
                const InputDecoration(labelText: 'Menge(g, ml)'),
            keyboardType: TextInputType.number,
          ),
          IconButton(
            onPressed: () => setState(_addFoodItem),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
