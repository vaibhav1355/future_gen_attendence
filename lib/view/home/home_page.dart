import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<Map<String, dynamic>> data = [
    {"strings": "Admin - General", "times": "00:00", "journals": ""},
    {"strings": "Academic - General", "times": "10:15", "journals": ""},
    {"strings": "Fundraising - General", "times": "11:30", "journals": ""},
  ];
  DateTime selectedDate = DateTime.now();
  final DateTime currentdate = DateTime.now();

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
      });
    }
  }

  Future<void> _selectTime(BuildContext context, int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 0, minute: 00),
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

        // Update the 'times' field for the specific item in the data list
        data[index]['times'] = DateFormat('HH:mm').format(newTime);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    String today = DateFormat('EEE, dd MMM yyyy').format(selectedDate);



    return Scaffold(
      appBar: AppBar(
        leading:  Icon(Icons.menu, size: 26, color: Colors.white),
        centerTitle: true,
        title:  Text(
          'Home',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height*0.075,
            color:  Color(0xff323641),
            padding:  EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon:  Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      selectedDate = selectedDate.subtract( Duration(days: 1));
                    });
                  },
                ),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Text(
                    today,
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
                      if (selectedDate.add( Duration(days: 1)).isBefore(DateTime(currentdate.year, currentdate.month, currentdate.day + 1))) {
                        selectedDate = selectedDate.add(const Duration(days: 1));
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: data.length + 1,
              itemBuilder: (context, index) {
                if (index == data.length) {
                  return Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: EdgeInsets.only(left: 12.0, top: 12.0, bottom: 12.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          'assets/images/add_img.png',
                          height: 50,
                          width: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                }
                final item = data[index];
                return Column(
                  children: [
                    Card(
                      margin: EdgeInsets.zero,
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        leading: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.30,
                          child: Padding(
                            padding: EdgeInsets.only(left: 12.0),
                            child: Text(
                              item['strings'],
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ),
                        title: GestureDetector(
                          onTap: () => _selectTime(context ,index),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    item['times'],
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Image.asset(
                                  'assets/images/caret_arrow_up.png',
                                  height: 20,
                                  width: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        trailing: MaterialButton(
                          onPressed: () {
                            // Implement your logic here
                          },
                          color: Color(0xffefce21),
                          minWidth: 120,
                          padding: EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                          child: Text(
                            'Journal',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff0a0a0a),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: () {
                    // Implement save logic here
                  },
                  color: Colors.black,
                  minWidth: 160,
                  height: 45,
                  padding: EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    // Implement lock logic here
                  },
                  color: Colors.black,
                  minWidth: 160,
                  height: 45,
                  padding:  EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    'Lock',
                    style: TextStyle(fontSize: 16, color: Colors.white),
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

// 0221