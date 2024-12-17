import 'package:flutter/material.dart';
import 'package:futuregen_attendance/view/drawer/app_drawer.dart';
import 'package:futuregen_attendance/view/home/date_and_hour.dart';
import 'package:futuregen_attendance/view/home/journal.dart';
import 'package:intl/intl.dart';

import '../drawer/about_us.dart';
import 'locking_and_saving.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int totalDays = 0;
  int totalHours = 0;
  int currentDays = 0;
  int leftHours = 0;
  int leftMinutes = 0;
  int leftDays = 0;

  final DateTime firstDate = DateTime(2024, 12, 10);
  final DateTime secondDate = DateTime(2024, 12, 25);
  final DateTime currentDate = DateTime.now();
  DateTime selectedDate = DateTime.now();


  @override
  void initState() {
    super.initState();
    totalDays = _daysBetween(firstDate, secondDate);
    currentDays = _daysBetween(firstDate, currentDate);
    totalHours = totalDays * 8;
    leftDays = totalDays - currentDays;
    _populateDataForDateRange();
    _calculateLeftHours();
  }

  int _daysBetween(DateTime start, DateTime end) => end.difference(start).inDays;


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> updatedData = [
    {
      'selectedDate': '17-12-2024',
      'isLocked': false,
      'categorylist': [
        {'category': 'Admin-General', 'time': '2:00', 'journals': ''},
        {'category': 'Academic-General', 'time': '2:00', 'journals': ''},
        {'category': 'Customer Service-General', 'time': '2:00', 'journals': ''},
        {'category': 'Marketing-General', 'time': '2:00', 'journals': ''},
      ],
    },
    {
      'selectedDate': '16-12-2024',
      'isLocked': false,
      'categorylist': [
        {'category': 'Admin-General', 'time': '4:00', 'journals': ''},
        {'category': 'Academic-General', 'time': '4:00', 'journals': ''},
      ],
    },
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024, 10, 15),
      lastDate: currentDate,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _ensureDateExists();
        _calculateLeftHours(); // Recalculate left hours and minutes after changing date
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
                {'category': 'Admin-General', 'time': '3:00', 'journals': ''},
                {'category': 'Academic-General', 'time': '3:00', 'journals': ''},
                {'category': 'Fundraising-General', 'time': '2:00', 'journals': ''},
              ],
            });
            return {
              'selectedDate': formattedDate,
              'isLocked': false,
              'categorylist': [
                {'category': 'Admin-General', 'time': '3:00', 'journals': ''},
                {'category': 'Academic-General', 'time': '3:00', 'journals': ''},
                {'category': 'Fundraising-General', 'time': '2:00', 'journals': ''},
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
    DateTime tempDate = firstDate;
    while (tempDate.isBefore(currentDate) || tempDate.isAtSameMomentAs(currentDate)) {
      final formattedDate = DateFormat('dd-MM-yyyy').format(tempDate);
      if (!updatedData.any((item) => item['selectedDate'] == formattedDate)) {
        updatedData.add({
          'selectedDate': formattedDate,
          'isLocked': false,
          'categorylist': [
            {'category': 'Admin-General', 'time': '3:00', 'journals': ''},
            {'category': 'Academic-General', 'time': '3:00', 'journals': ''},
            {'category': 'Fundraising-General', 'time': '2:00', 'journals': ''},
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

    setState(() {
      leftHours = totalHours - totalUsedHours;
      leftMinutes = (60 - totalUsedMinutes) % 60;
      print('leftHours: $leftHours  leftMinutes: $leftMinutes');
    });
  }

  void _ensureDateExists() {
    String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
    if (!updatedData.any((item) => item['selectedDate'] == formattedDate)) {
      updatedData.add({
        'selectedDate': formattedDate,
        'isLocked': false,
        'categorylist': [
          {'category': 'Admin-General', 'time': '3:00', 'journals': ''},
          {'category': 'Academic-General', 'time': '3:00', 'journals': ''},
          {'category': 'Fundraising-General', 'time': '2:00', 'journals': ''},
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

  // Future<void> _selectTime(BuildContext context, int index) async {
  //
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay(hour: 00, minute: 00),
  //     initialEntryMode: TimePickerEntryMode.dial,
  //   );
  //
  //   if (picked != null) {
  //     setState(() {
  //       final newTime = DateTime(
  //         selectedDate.year,
  //         selectedDate.month,
  //         selectedDate.day,
  //         picked.hour,
  //         picked.minute,
  //       );
  //
  //       String formattedTime = DateFormat('HH:mm').format(newTime);
  //
  //       String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
  //
  //       var dateEntry = updatedData.firstWhere(
  //             (item) => item['selectedDate'] == formattedDate,
  //         orElse: () {
  //           updatedData.add({
  //             'selectedDate': formattedDate,
  //             'isLocked': false,
  //             'categorylist': [
  //               {'category': 'Admin-General', 'time': '3:00', 'journals': ''},
  //               {'category': 'Academic-General', 'time': '3:00', 'journals': ''},
  //               {'category': 'Fundraising-General', 'time': '2:00', 'journals': ''},
  //             ],
  //           });
  //           return {
  //             'selectedDate': formattedDate,
  //             'isLocked': false,
  //             'categorylist': [
  //               {'category': 'Admin-General', 'time': '3:00', 'journals': ''},
  //               {'category': 'Academic-General', 'time': '3:00', 'journals': ''},
  //               {'category': 'Fundraising-General', 'time': '2:00', 'journals': ''},
  //             ],
  //           };
  //         },
  //       );
  //       dateEntry['categorylist'][index]['time'] = formattedTime;
  //     });
  //   }
  // }

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
                      selectedDate = selectedDate.subtract(Duration(days: 1));
                      _ensureDateExists();
                      print('hehe: $updatedData');
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
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: selectedDateData['categorylist'].length + 1,
              itemBuilder: (context, index) {
                if (index == selectedDateData['categorylist'].length) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8, left: 20.0, bottom: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (selectedDateData['isLocked'] == false) {
                                  _showCategoryBottomSheet(context);
                                }
                              });
                            },
                            child: Image.asset(
                              'assets/images/add_img.png',
                              height: 50,
                              width: 50,
                              color: Colors.grey,
                              semanticLabel: "Add item",
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                    ],
                  );
                }
                final item = selectedDateData['categorylist'][index];
                return Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 30, top: 8, bottom: 8, right: 10),
                      leading: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.29,
                          child: Text(
                            item['category'],
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ),
                      title: InkWell(
                        onTap: () =>
                        {
                          setState(() {
                            if (selectedDateData['isLocked'] == false) {
                              _selectTime(context, index);
                              _calculateLeftHours();
                            }
                          })
                        },
                        child: Row(
                          children: [
                            SizedBox(width: 10, height: 50),
                            Flexible(
                              child: Text(
                                item['time'],
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: 25, height: 50),
                            Image.asset(
                              'assets/images/caret_arrow_up.png',
                              height: 20,
                              width: 20,
                              semanticLabel: "Select time",
                            ),
                            SizedBox(width: 5, height: 5),
                          ],
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          if(!isLocked)
                            _navigateToJournalScreen(
                              context,
                              index,
                              item['category'],
                              item['journals'],
                            );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffefcd1a),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                          padding: EdgeInsets.all(12),
                          minimumSize: Size(110, 38),
                        ),
                        child: Text(
                          'Journal',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff121212),
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                  ],
                );
              },
            ),
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
          DateAndHour(totalHours: totalHours,totalDays : totalDays, leftHours: leftHours, leftDays: leftDays),
        ],
      ),
    );
  }
}


