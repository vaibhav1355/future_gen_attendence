import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> updatedData = [];

  void _initializeDateData(String formattedDate) {
    if (!updatedData.any((item) => item['selectedDate'] == formattedDate)) {
      updatedData.add({
        'selectedDate': formattedDate,
        'isLocked': false,
        'categorylist': [
          {'category': 'Admin-General', 'time': '8:00', 'journals': ''},
          {'category': 'Academic-General', 'time': '9:00', 'journals': ''},
          {'category': 'Fundraising-General', 'time': '7:00', 'journals': ''},
        ],
      });
    }
  }

  void _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _initializeDateData(DateFormat('dd-MM-yyyy').format(selectedDate));
      });
    }
  }

  void _selectTime(int index, int categoryIndex) async {
    TimeOfDay initialTime = TimeOfDay.now();
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      setState(() {
        updatedData[index]['categorylist'][categoryIndex]['time'] =
            picked.format(context);
      });
    }
  }

  void _toggleLock(int index) {
    setState(() {
      updatedData[index]['isLocked'] = !updatedData[index]['isLocked'];
    });
  }

  void _showCategoryBottomSheet(BuildContext context, int index) {
    final TextEditingController categoryController = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: categoryController,
                decoration: InputDecoration(
                  labelText: 'New Category',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    updatedData[index]['categorylist'].add({
                      'category': categoryController.text,
                      'time': '8:00',
                      'journals': '',
                    });
                  });
                  Navigator.pop(context);
                },
                child: Text('Add Category'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
    _initializeDateData(formattedDate);

    return Scaffold(
      appBar: AppBar(title: Text('Dynamic Category App')),
      body: ListView.builder(
        itemCount: updatedData.length,
        itemBuilder: (context, index) {
          final dateData = updatedData[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date: ${dateData['selectedDate']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: dateData['categorylist'].length,
                    itemBuilder: (context, categoryIndex) {
                      final categoryData =
                      dateData['categorylist'][categoryIndex];
                      return ListTile(
                        title: Text(categoryData['category']),
                        subtitle: Text('Time: ${categoryData['time']}'),
                        trailing: IconButton(
                          icon: Icon(Icons.timer),
                          onPressed: () => _selectTime(index, categoryIndex),
                        ),
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => _showCategoryBottomSheet(context, index),
                        child: Text('Add Category'),
                      ),
                      ElevatedButton(
                        onPressed: () => _toggleLock(index),
                        child: Text(dateData['isLocked'] ? 'Unlock' : 'Lock'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _selectDate(context),
        child: Icon(Icons.calendar_today),
      ),
    );
  }
}
