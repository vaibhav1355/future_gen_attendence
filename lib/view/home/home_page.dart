import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  @override
  Widget build(BuildContext context) {
    String today = DateFormat('EEE, dd MMM yyyy').format(selectedDate);

    final List<Map<String, dynamic>> data = [
      {"strings": "Admin - General", "times": "00:00", "journals": ""},
      {"strings": "Academic - General", "times": "10:15", "journals": ""},
      {"strings": "Fundraising - General", "times": "11:30", "journals": ""},
    ];

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
            height: 80,
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
                      padding: const EdgeInsets.only(left: 12.0, top: 12.0, bottom: 12.0),
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
                        contentPadding:  EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        leading: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.26,
                          child: Padding(
                            padding:  EdgeInsets.only(left: 12.0),
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
                        title: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: GestureDetector(
                                  onTap: () async {
                                    final TimeOfDay? picked = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(selectedDate),
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
                                        item['times'] = DateFormat('HH:mm').format(newTime);
                                      });
                                    }
                                  },
                                  child: Text(
                                    item['times'],
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
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
                        trailing: MaterialButton(
                          onPressed: () {

                          },
                          color:  Color(0xffefce21),
                          minWidth: 120,
                          padding:  EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                          child:  Text(
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
          Row(
            children: [
              MaterialButton(
                onPressed: () {
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
                              Row(
                                children: [
                                  Expanded(
                                    child: MaterialButton(
                                      onPressed: () {},
                                      color: Color(0xff39ba53),
                                      height: 60,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomLeft: Radius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        'D-212.7',
                                        style: TextStyle(fontSize: 20, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: MaterialButton(
                                      onPressed: () {},
                                      color: Color(0xffde3232),
                                      height: 60,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(12),
                                          bottomRight: Radius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        'H-1701.58',
                                        style: TextStyle(fontSize: 20, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
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
                                          '212.7', // Replace with dynamic data if needed
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
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
                                     SizedBox(height: 8),
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
                                    SizedBox(height: 8),
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
                },
                color:  Color(0xff39ba53),
                minWidth: MediaQuery.of(context).size.width * 0.5,
                height: 60,
                padding:  EdgeInsets.all(12),
                child: Text(
                  'D-212.7',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              MaterialButton(
                onPressed: () {  },
                color: Color(0xffde3232),
                minWidth: MediaQuery.of(context).size.width * 0.5,
                height: 60,
                padding: EdgeInsets.all(12),
                child: Text(
                  'H-1701.58',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

