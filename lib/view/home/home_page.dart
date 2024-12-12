import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _islocked = false;

  DateTime selectedDate = DateTime.now();
  final DateTime currentdate = DateTime.now();

  final List<Map<String, dynamic>> updatedData = [
    {
      'selectedDate': '12-12-2024',
      'operationStatus': 'Unlocked',
      'categorylist': [
        {'category': 'Admin-General', 'time': '8:00', 'journals': ''},
        {'category': 'Academic-General', 'time': '9:00', 'journals': ''},
        {'category': 'Customer Service-General', 'time': '6:00', 'journals': ''},
      ],
    },
    {
      'selectedDate': '11-12-2024',
      'operationStatus': 'Unlocked',
      'categorylist': [
        {'category': 'Admin-General', 'time': '4:00', 'journals': ''},
        {'category': 'Academic-General', 'time': '12:00', 'journals': ''},
      ],
    },
  ];

  // List<Map<String, String>> defaultCategory = [
  //   {'category': 'Admin-General', 'time': '8:00', 'journals': ''},
  //   {'category': 'Academic-General', 'time': '9:00', 'journals': ''},
  //   {'category': 'Fundraising-General', 'time': '7:00', 'journals': ''},
  // ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2018, 8),
      lastDate: currentdate,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _ensureDateExists();
      });
    }
  }

  void _ensureDateExists() {
    String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
    if (!updatedData.any((item) => item['selectedDate'] == formattedDate)) {
      updatedData.add({
        'selectedDate': formattedDate,
        'operationStatus': 'Unlocked',
        'categorylist': [
          {'category': 'Admin-General', 'time': '8:00', 'journals': ''},
          {'category': 'Academic-General', 'time': '9:00', 'journals': ''},
          {'category': 'Fundraising-General', 'time': '7:00', 'journals': ''},
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
        'operationStatus': 'Unlocked',
        'categorylist': [],
      },
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
              'operationStatus': 'Unlocked',
              'categorylist': [
                {'category': 'Admin-General', 'time': '8:00', 'journals': ''},
                {'category': 'Academic-General', 'time': '9:00', 'journals': ''},
                {'category': 'Fundraising-General', 'time': '7:00', 'journals': ''},
              ],
            });
            return {
              'selectedDate': formattedDate,
              'operationStatus': 'Unlocked',
              'categorylist': [
                {'category': 'Admin-General', 'time': '8:00', 'journals': ''},
                {'category': 'Academic-General', 'time': '9:00', 'journals': ''},
                {'category': 'Fundraising-General', 'time': '7:00', 'journals': ''},
              ],
            };
          },
        );
        dateEntry['categorylist'][index]['time'] = formattedTime;
      });
    }
  }

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
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(thickness: 1, color: Color(0xffE7E7E7)),
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
                            Divider(
                              thickness: 1,
                              color: Color(0xffE7E7E7),
                            ),
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

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu, size: 26, color: Colors.white),
        centerTitle: true,
        title: Text(
          'Home',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.black,
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
                          DateTime(currentdate.year, currentdate.month, currentdate.day + 1))) {
                        selectedDate = selectedDate.add(Duration(days: 1));
                        _ensureDateExists();
                      }
                    });
                  },
                ),
              ],
            ),
          ),
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
                              if (!_islocked) _showCategoryBottomSheet(context);
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
                      Divider(
                        thickness: 2,
                        color: Color(0xfff1ecf0),
                      ),
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
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Text(
                            item['category'],
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
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
                              if(!_islocked)
                                _selectTime(context, index)
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
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffefcd1a),
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
                    Divider(
                      thickness: 2,
                      color: Color(0xfff1ecf0),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_islocked)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          // Implement save logic here
                        },
                        color: Colors.black,
                        minWidth: 160,
                        height: 45,
                        padding: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            _islocked = true;
                          });
                        },
                        color: Colors.black,
                        minWidth: 160,
                        height: 45,
                        padding: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: const Text(
                          'Lock',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                if (_islocked)
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        'Locked',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape:  RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (BuildContext context) {
                  return Wrap(
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            }, // close the showModelBottomSheet
                            child: Row(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Color(0xff39ba53),
                                  ),
                                  padding: EdgeInsets.all(12),
                                  child: Center(
                                    child: Text(
                                      'D-212.7',
                                      style: TextStyle(fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Color(0xffde3232),
                                  ),
                                  padding: EdgeInsets.all(12),
                                  child: Center(
                                    child: Text(
                                      'H-1701.58',
                                      style: TextStyle(fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding:  EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:  [
                                    Text(
                                      'Total Hours:',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '212.7',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 14),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:  [
                                    Text(
                                      'Left Hours:',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '50', // Replace with dynamic data if needed
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 14),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:  [
                                    Text(
                                      'Total Days:',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '30', // Replace with dynamic data if needed
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 14),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:  [
                                    Text(
                                      'Left Days:',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '10',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  );
                },
              );
            } ,
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xff39ba53),
                  ),
                  padding: EdgeInsets.all(12),
                  child: Center(
                    child: Text(
                      'D-212.7',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xffde3232),
                  ),
                  padding: EdgeInsets.all(12),
                  child: Center(
                    child: Text(
                      'H-1701.58',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
