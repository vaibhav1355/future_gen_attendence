import 'package:flutter/material.dart';
import 'package:futuregen_attendance/view/drawer/app_drawer.dart';
import 'package:futuregen_attendance/view/home/display_bottom_date_and_hour.dart';
import 'package:futuregen_attendance/view/home/journal.dart';
import 'package:intl/intl.dart';

import '../../Constants/constants.dart';

import 'display_category_list.dart';
import 'locking_and_saving.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int totalDays = 0;
  double totalHours = 0;

  double leftHours = 0;
  double leftMinutes = 0;
  double leftDays = 0;

  final DateTime startDate = DateTime(2024, 12, 15);
  final DateTime endDate = DateTime(2024, 12, 30);
  final DateTime currentDate = DateTime.now();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    totalDays = _daysBetween(startDate, endDate);
    totalHours = totalDays * 8;
    _populateDataForDateRange();
    _calculateLeftHours();
  }

  int _daysBetween(DateTime start, DateTime end) => end.difference(start).inDays;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> updatedData = [
    {
      'selectedDate': '19-12-2024',
      'isLocked': false,
      'categorylist': [
        {'category': 'Admin-General', 'time': '0:00', 'journals': ''},
        {'category': 'Academic-General', 'time': '0:00', 'journals': ''},
        {'category': 'Customer Service-General', 'time': '0:00', 'journals': ''},
        {'category': 'Marketing-General', 'time': '0:00', 'journals': ''},
      ],
    },
    {
      'selectedDate': '18-12-2024',
      'isLocked': false,
      'categorylist': [
        {'category': 'Admin-General', 'time': '0:00', 'journals': ''},
        {'category': 'Academic-General', 'time': '0:00', 'journals': ''},
      ],
    },
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: startDate,
      lastDate: currentDate,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _ensureDateExists();
        _calculateLeftHours();
      });
    }
  }

  Future<void> _selectTime(BuildContext context, int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 00, minute: 00),
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if (picked != null) {
      setState(() {
        final newTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          picked.hour,
          picked.minute,
        );

        String formattedTime = DateFormat('HH:mm').format(newTime);

        String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);

        var dateEntry = updatedData.firstWhere(
              (item) => item['selectedDate'] == formattedDate,
          orElse: () {
            updatedData.add({
              'selectedDate': formattedDate,
              'isLocked': false,
              'categorylist': [
                {'category': 'Admin-General', 'time': '0:00', 'journals': ''},
                {'category': 'Academic-General', 'time': '0:00', 'journals': ''},
                {'category': 'Fundraising-General', 'time': '0:00', 'journals': ''},
              ],
            });
            return {
              'selectedDate': formattedDate,
              'isLocked': false,
              'categorylist': [
                {'category': 'Admin-General', 'time': '0:00', 'journals': ''},
                {'category': 'Academic-General', 'time': '0:00', 'journals': ''},
                {'category': 'Fundraising-General', 'time': '0:00', 'journals': ''},
              ],
            };
          },
        );
        dateEntry['categorylist'][index]['time'] = formattedTime;

        _calculateLeftHours();
      });
    }
  }

  void _populateDataForDateRange() {
    DateTime tempDate = startDate;
    while (tempDate.isBefore(currentDate) || tempDate.isAtSameMomentAs(currentDate)) {
      final formattedDate = DateFormat('dd-MM-yyyy').format(tempDate);
      if (!updatedData.any((item) => item['selectedDate'] == formattedDate)) {
        updatedData.add({
          'selectedDate': formattedDate,
          'isLocked': false,
          'categorylist': [
            {'category': 'Admin-General', 'time': '0:00', 'journals': ''},
            {'category': 'Academic-General', 'time': '0:00', 'journals': ''},
            {'category': 'Fundraising-General', 'time': '0:00', 'journals': ''},
          ],
        });
      }
      tempDate = tempDate.add(const Duration(days: 1));
    }
  }

  void _calculateLeftHours() {
    int totalUsedHours = 0, totalUsedMinutes = 0;

    for (var entry in updatedData) {
      final entryDate = DateFormat('dd-MM-yyyy').parse(entry['selectedDate']);
      if (entryDate.isBefore(currentDate) || entryDate.isAtSameMomentAs(currentDate)) {
        for (var item in entry['categorylist']) {
          final timeParts = item['time'].split(':');
          totalUsedHours += int.parse(timeParts[0]);
          totalUsedMinutes += int.parse(timeParts[1]);
        }
      }
    }

    totalUsedHours += totalUsedMinutes ~/ 60;
    totalUsedMinutes %= 60;

    double remainingHours = totalHours - totalUsedHours - (totalUsedMinutes / 60);

    setState(() {
      leftHours = double.parse(remainingHours.toStringAsFixed(2));
      leftMinutes = (60 - totalUsedMinutes) % 60;
      leftDays = double.parse(((remainingHours) / 8).toStringAsFixed(2));
      print('leftHours: $leftHours  leftDays: $leftDays');
    });
  }

  void _ensureDateExists() {
    String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
    if (!updatedData.any((item) => item['selectedDate'] == formattedDate)) {
      updatedData.add({
        'selectedDate': formattedDate,
        'isLocked': false,
        'categorylist': [
          {'category': 'Admin-General', 'time': '0:00', 'journals': ''},
          {'category': 'Academic-General', 'time': '0:00', 'journals': ''},
          {'category': 'Fundraising-General', 'time': '0:00', 'journals': ''},
        ],
      });
    }
  }

  Map<String, dynamic> _getSelectedDateData() {
    String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
    return updatedData.firstWhere(
          (item) => item['selectedDate'] == formattedDate,
      orElse: () => {
        'selectedDate': formattedDate,
        'isLocked': false,
        'categorylist': [],
      },
    );
  }

  void _navigateToJournalScreen(BuildContext context, int index, String category, String initialJournalText) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalScreen(
          index: index,
          category: category,
          initialJournalText: initialJournalText,
          onJournalUpdate: (updatedText) {
            setState(() {
              updatedData.firstWhere((item) => item['selectedDate'] == DateFormat('dd-MM-yyyy').format(selectedDate))
              ['categorylist'][index]['journals'] = updatedText;
            });
          },
        ),
      ),
    );
  }

  final List<String> categories = [
    'Admin-General',
    'Academic-General',
    'Fundraising-General',
    'Marketing-General',
    'Operations-General',
    'Finance-General',
    'HR-General',
    'Research-General',
    'Event Management-General',
    'Customer Service-General',
  ];

  void _showCategoryBottomSheet(BuildContext context) {

    Map<String, bool> checkboxStates = {};

    var selectedDateData = _getSelectedDateData();

    selectedDateData['categorylist'].forEach((item) {
      checkboxStates[item['category']] = true;
    });

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.all(4.0),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Color(0xff6C60FF),
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              categories.forEach((category) {
                                if (checkboxStates[category] == true) {
                                  bool isAlreadySelected = selectedDateData['categorylist']
                                      .any((item) => item['category'] == category);

                                  if (!isAlreadySelected) {
                                    selectedDateData['categorylist'].add({
                                      'category': category,
                                      'time': '00:00',
                                      'journals': '',
                                    });
                                  }
                                }
                              });
                            });
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Add Category',
                              style: TextStyle(
                                color: Color(0xff6C60FF),
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        String category = categories[index];
                        bool isChecked = checkboxStates[category] ?? false;
                        return Column(
                          children: [
                            CheckboxListTile(
                              title: Text(category),
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  checkboxStates[category] = value ?? false;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            Divider(),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      setState(() {});
    });
  }

  @override

  Widget build(BuildContext context) {
    _ensureDateExists();
    var selectedDateData = _getSelectedDateData();
    final isLocked = selectedDateData['isLocked'] ?? false;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: Icon(Icons.menu, size: 26, color: Colors.white),
        ),
        centerTitle: true,
        title: Text(
          'Home',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      drawer: Drawer(
        child: AppDrawer(),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.075,
            color: Color(0xff323641),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      if (selectedDate.subtract(Duration(days: 1)).isAfter(startDate)) {
                        selectedDate = selectedDate.subtract(Duration(days: 1));
                        _ensureDateExists();
                        print('hehe: $updatedData');
                      }
                    });
                  },
                ),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Text(
                    DateFormat('EEE, dd MMM yyyy').format(selectedDate),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      if (selectedDate.add(Duration(days: 1)).isBefore(
                          DateTime(currentDate.year, currentDate.month, currentDate.day + 1))) {
                        selectedDate = selectedDate.add(Duration(days: 1));
                        _ensureDateExists();
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBoxHeight10,
          DisplayCategoryList(
            selectedDateData: _getSelectedDateData(),
            showCategoryBottomSheet: _showCategoryBottomSheet,
            selectTime: _selectTime,
            calculateLeftHours: _calculateLeftHours,
            navigateToJournalScreen: _navigateToJournalScreen,
          ),
          LockAndSaving(
            selectedDateData: _getSelectedDateData(),
            onSave: () {
              String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
              print("Data saved for $formattedDate");
            },
            onLock: () {
              setState(() {
                String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
                var dateEntry = updatedData.firstWhere(
                      (item) => item['selectedDate'] == formattedDate,
                );
                if (dateEntry != null) {
                  dateEntry['isLocked'] = true;
                  print("Date $formattedDate is locked.");
                }
              });
            },
          ),
          DisplayBottomDateAndHour(totalHours: totalHours,totalDays : totalDays, leftHours: leftHours, leftDays: leftDays),
        ],
      ),
    );
  }
}

