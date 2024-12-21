// import 'package:flutter/material.dart';
// import 'package:futuregen_attendance/view/drawer/app_drawer.dart';
// import 'package:futuregen_attendance/view/home/display_bottom_date_and_hour.dart';
// import 'package:futuregen_attendance/view/home/journal.dart';
// import 'package:intl/intl.dart';
//
// import '../../Constants/constants.dart';
//
// import 'display_category_list.dart';
// import 'locking_and_saving.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//
//   final List<Map<String, dynamic>> updatedData = [
//     {
//       "startDate": "03-12-2024",
//       "endDate": "05-12-2024",
//       "totalDays": 0,
//       "leftDays" : 0.0,
//       "totalHours": 0.0,
//       "leftHours": 0.0,
//       "entries": [
//         {
//           "selectedDate": "03-12-2024",
//           "isLocked": false,
//           "categorylist": [
//             {'category': 'Admin-General', 'time': '2:00', 'journals': ''},
//             {'category': 'Academic-General', 'time': '2:00', 'journals': ''},
//             {'category': 'Customer Service-General', 'time': '2:00', 'journals': ''},
//             {'category': 'Marketing-General', 'time': '2:00', 'journals': ''},
//           ],
//         },
//         {
//           "selectedDate": "04-12-2024",
//           "isLocked": false,
//           "categorylist": [
//             {'category': 'Admin-General', 'time': '2:00', 'journals': ''},
//             {'category': 'Academic-General', 'time': '2:00', 'journals': ''},
//             {'category': 'Customer Service-General', 'time': '2:00', 'journals': ''},
//             {'category': 'Marketing-General', 'time': '2:00', 'journals': ''},
//           ],
//         },
//       ],
//     },
//     {
//       "startDate": "15-12-2024",
//       "endDate": "30-12-2024",
//       "totalDays": 0,
//       "leftDays" : 0.0,
//       "totalHours": 0.0,
//       "leftHours": 0.0,
//       "entries": [
//         {
//           "selectedDate": "20-12-2024",
//           "isLocked": false,
//           "categorylist": [
//             {'category': 'Admin-General', 'time': '2:00', 'journals': ''},
//             {'category': 'Academic-General', 'time': '2:00', 'journals': ''},
//             {'category': 'Customer Service-General', 'time': '2:00', 'journals': ''},
//             {'category': 'Marketing-General', 'time': '2:00', 'journals': ''},
//           ],
//         },
//       ],
//     },
//   ];
//
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   final DateTime currentDate = DateTime.now();
//   DateTime selectedDate = DateTime.now();
//
//   DateTime? minStartDate;
//   DateTime? maxEndDate;
//
//   double totalHours = 0.0;
//   int totalDays = 0;
//   double leftHours = 0.0;
//   double leftDays= 0.0;
//
//   @override
//   void initState() {
//     super.initState();
//     _calculateMinAndMaxDates();
//     _populateDataForDateRange(minStartDate!,maxEndDate!);
//     updateTotalDaysAndHours();
//   }
//
//   void updateTotalDaysAndHours() {
//     String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
//
//     int _daysBetween(DateTime start, DateTime end) => end.difference(start).inDays;
//
//     for (var range in updatedData) {
//       DateTime rangeStartDate = DateFormat('dd-MM-yyyy').parse(range['startDate']);
//       DateTime rangeEndDate = DateFormat('dd-MM-yyyy').parse(range['endDate']);
//       DateTime currentDate = DateFormat('dd-MM-yyyy').parse(formattedDate);
//
//       if (currentDate.isAfter(rangeStartDate.subtract(Duration(days: 1))) && currentDate.isBefore(rangeEndDate.add(Duration(days: 1)))) {
//         setState(() {
//
//           range['totalDays'] = _daysBetween(rangeStartDate, rangeEndDate);
//           range['totalHours'] = range['totalDays'] * 8.0;
//           totalDays = range['totalDays'];
//           totalHours = range['totalHours'];
//
//           int totalUsedHours = 0, totalUsedMinutes = 0;
//
//           for (var entry in range['entries']) {
//             final entryDate = DateFormat('dd-MM-yyyy').parse(entry['selectedDate']);
//             if (entryDate.isBefore(currentDate) || entryDate.isAtSameMomentAs(currentDate)) {
//               for (var item in entry['categorylist']) {
//                 final timeParts = item['time'].split(':');
//                 totalUsedHours += int.parse(timeParts[0]);
//                 totalUsedMinutes += int.parse(timeParts[1]);
//               }
//             }
//           }
//
//           totalUsedHours += totalUsedMinutes ~/ 60;
//           totalUsedMinutes %= 60;
//
//           double remainingHours = range['totalHours'] - totalUsedHours - (totalUsedMinutes / 60.0);
//           range['leftHours'] = remainingHours;
//           range['leftDays'] = remainingHours;
//
//           setState(() {
//             leftDays = range['leftDays'];
//             leftHours = range['leftHours'];
//           });
//
//           print('Range: ${range['startDate']} - ${range['endDate']}');
//           print('Total Hours: ${range['totalHours']} | Left Hours: ${range['leftHours']} | Left Days: ${range['leftDays']}');
//         });
//       }
//     }
//   }
//
//   void _calculateMinAndMaxDates() {
//     List<String> startDates = updatedData.map((data) => data['startDate'] as String).toList();
//     List<String> endDates = updatedData.map((data) => data['endDate'] as String).toList();
//
//     String minStartDateString = startDates.reduce((a, b) => a.compareTo(b) < 0 ? a : b);
//     String maxEndDateString = endDates.reduce((a, b) => a.compareTo(b) > 0 ? a : b);
//
//     minStartDate = DateTime.parse("${minStartDateString.substring(6)}-${minStartDateString.substring(3, 5)}-${minStartDateString.substring(0, 2)}");
//     maxEndDate = DateTime.parse("${maxEndDateString.substring(6)}-${maxEndDateString.substring(3, 5)}-${maxEndDateString.substring(0, 2)}");
//   }
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: minStartDate!,
//       lastDate: currentDate,
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//         _ensureDateExists();
//         //_calculateLeftHours();
//       });
//     }
//   }
//
//   Future<void> _selectTime(BuildContext context, int index) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay(hour: 00, minute: 00),
//       initialEntryMode: TimePickerEntryMode.dial,
//     );
//
//     if (picked != null) {
//       setState(() {
//         final newTime = DateTime(
//           selectedDate.year,
//           selectedDate.month,
//           selectedDate.day,
//           picked.hour,
//           picked.minute,
//         );
//
//         String formattedTime = DateFormat('HH:mm').format(newTime);
//
//         String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
//
//         var rangeEntry = updatedData.firstWhere(
//               (range) {
//             DateTime rangeStartDate = DateFormat('dd-MM-yyyy').parse(range['startDate']);
//             DateTime rangeEndDate = DateFormat('dd-MM-yyyy').parse(range['endDate']);
//             return selectedDate.isAfter(rangeStartDate) && selectedDate.isBefore(rangeEndDate) ||
//                 selectedDate.isAtSameMomentAs(rangeStartDate) ||
//                 selectedDate.isAtSameMomentAs(rangeEndDate);
//           },
//           orElse: () {
//             updatedData.add({
//               'startDate': formattedDate,
//               'endDate': formattedDate,
//               'entries': [],
//             });
//             return updatedData.last;
//           },
//         );
//
//         var dateEntry = rangeEntry['entries'].firstWhere(
//               (entry) => entry['selectedDate'] == formattedDate,
//           orElse: () {
//             var newEntry = {
//               'selectedDate': formattedDate,
//               'isLocked': false,
//               'categorylist': [
//                 {'category': 'Admin-General', 'time': '0:00', 'journals': ''},
//                 {'category': 'Academic-General', 'time': '0:00', 'journals': ''},
//                 {'category': 'Fundraising-General', 'time': '0:00', 'journals': ''},
//               ],
//             };
//             rangeEntry['entries'].add(newEntry);
//             return newEntry;
//           },
//         );
//
//         if (index < dateEntry['categorylist'].length) {
//           dateEntry['categorylist'][index]['time'] = formattedTime;
//         }
//       });
//     }
//   }
//
//   void _populateDataForDateRange(DateTime minStartDate, DateTime endDate) {
//
//     DateTime tempDate = minStartDate;
//
//     while (tempDate.isBefore(endDate) || tempDate.isAtSameMomentAs(endDate)) {
//       final formattedDate = DateFormat('dd-MM-yyyy').format(tempDate);
//
//       var rangeEntry = updatedData.firstWhere(
//             (range) {
//           DateTime rangeStartDate = DateFormat('dd-MM-yyyy').parse(range['startDate']);
//           DateTime rangeEndDate = DateFormat('dd-MM-yyyy').parse(range['endDate']);
//           return tempDate.isAfter(rangeStartDate) && tempDate.isBefore(rangeEndDate) ||
//               tempDate.isAtSameMomentAs(rangeStartDate) ||
//               tempDate.isAtSameMomentAs(rangeEndDate);
//         },
//         orElse: () {
//           updatedData.add({
//             'startDate': formattedDate,
//             'endDate': formattedDate,
//             'entries': [],
//           });
//           return updatedData.last;
//         },
//       );
//
//       var existingEntry = rangeEntry['entries'].firstWhere(
//             (entry) => entry['selectedDate'] == formattedDate,
//         orElse: () {
//           var newEntry = {
//             'selectedDate': formattedDate,
//             'isLocked': false,
//             'categorylist': [
//               {'category': 'Admin-General', 'time': '0:00', 'journals': ''},
//               {'category': 'Academic-General', 'time': '0:00', 'journals': ''},
//               {'category': 'Fundraising-General', 'time': '0:00', 'journals': ''},
//             ],
//           };
//           rangeEntry['entries'].add(newEntry);
//           return newEntry;
//         },
//       );
//       tempDate = tempDate.add(Duration(days: 1));
//     }
//   }
//
//   void _ensureDateExists(){
//     String formattedDate =  DateFormat('dd-MM-yyyy').format(selectedDate);
//
//     for(var range in updatedData){
//       DateTime rangeStartDate = DateFormat('dd-MM-yyyy').parse(range['startDate']);
//       DateTime rangeEndDate = DateFormat('dd-MM-yyyy').parse(range['endDate']);
//       DateTime currentDate = DateFormat('dd-MM-yyyy').parse(formattedDate);
//
//       if(currentDate.isAfter(rangeStartDate) && currentDate.isBefore(rangeEndDate)){
//
//         bool dataExists = range['entries'].any((entry)=>entry['selectedDate']==formattedDate);
//         if(!dataExists){
//           range['entries'].add(
//               {
//                 'selectedDate' : formattedDate,
//                 'isLocked' : false,
//                 'categoryList' : [
//                   {'category': 'Admin-General', 'time': '0:00', 'journals': ''},
//                   {'category': 'Academic-General', 'time': '0:00', 'journals': ''},
//                   {'category': 'Fundraising-General', 'time': '0:00', 'journals': ''},
//                 ]
//               }
//           );
//         }
//       }
//     }
//   }
//
//   Map<String, dynamic> _getSelectedDateData() {
//     String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
//
//     var entry = updatedData.firstWhere(
//           (range) {
//         DateTime rangeStartDate = DateFormat('dd-MM-yyyy').parse(range['startDate']);
//         DateTime rangeEndDate = DateFormat('dd-MM-yyyy').parse(range['endDate']);
//         DateTime currentDate = DateFormat('dd-MM-yyyy').parse(formattedDate);
//
//         return currentDate.isAfter(rangeStartDate.subtract(Duration(days: 1))) && currentDate.isBefore(rangeEndDate.add(Duration(days: 1)));
//       },
//       orElse: () {
//         String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
//         updatedData.add({
//           'startDate': formattedDate,
//           'endDate': formattedDate,
//           'entries': [],
//         });
//         return updatedData.last;
//       },
//     );
//
//     return entry['entries'].firstWhere(
//           (entry) => entry['selectedDate'] == formattedDate,
//       orElse: () {
//         var newEntry = {
//           'selectedDate': formattedDate,
//           'isLocked': false,
//           'categorylist': [
//             {'category': 'Admin-General', 'time': '0:00', 'journals': ''},
//             {'category': 'Academic-General', 'time': '0:00', 'journals': ''},
//             {'category': 'Fundraising-General', 'time': '0:00', 'journals': ''},
//           ],
//         };
//         entry['entries'].add(newEntry);
//         return newEntry;
//       },
//     );
//   }
//
//   void _navigateToJournalScreen(BuildContext context, int index, String category, String initialJournalText) async {
//     final DateTime selectedDateTime = selectedDate;
//
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => JournalScreen(
//           index: index,
//           category: category,
//           initialJournalText: initialJournalText,
//           onJournalUpdate: (updatedText) {
//             setState(() {
//               for (var dateRange in updatedData) {
//                 final DateTime startDateTime = DateFormat('dd-MM-yyyy').parse(dateRange['startDate']);
//                 final DateTime endDateTime = DateFormat('dd-MM-yyyy').parse(dateRange['endDate']);
//
//                 if (startDateTime.isBefore(selectedDateTime) || startDateTime.isAtSameMomentAs(selectedDateTime)) {
//                   if (endDateTime.isAfter(selectedDateTime) || endDateTime.isAtSameMomentAs(selectedDateTime)) {
//                     for (var entry in dateRange['entries']) {
//                       if (entry['selectedDate'] == DateFormat('dd-MM-yyyy').format(selectedDateTime)) {
//                         for (var categoryObj in entry['categorylist']) {
//                           if (categoryObj['category'] == category) {
//                             categoryObj['journals'] = updatedText;
//                             break;
//                           }
//                         }
//                       }
//                     }
//                   }
//                 }
//               }
//             });
//           },
//         ),
//       ),
//     );
//   }
//
//   final List<String> categories = [
//     'Admin-General',
//     'Academic-General',
//     'Fundraising-General',
//     'Marketing-General',
//     'Operations-General',
//     'Finance-General',
//     'HR-General',
//     'Research-General',
//     'Event Management-General',
//     'Customer Service-General',
//   ];
//
//   void _showCategoryBottomSheet(BuildContext context) {
//
//     Map<String, bool> checkboxStates = {};
//
//     var selectedDateData = _getSelectedDateData();
//
//     selectedDateData['categorylist'].forEach((item) {
//       checkboxStates[item['category']] = true;
//     });
//
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return Padding(
//               padding: EdgeInsets.all(4.0),
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 10),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text(
//                               'Cancel',
//                               style: TextStyle(
//                                 color: Color(0xff6C60FF),
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             setState(() {
//                               categories.forEach((category) {
//                                 if (checkboxStates[category] == true) {
//                                   bool isAlreadySelected = selectedDateData['categorylist']
//                                       .any((item) => item['category'] == category);
//
//                                   if (!isAlreadySelected) {
//                                     selectedDateData['categorylist'].add({
//                                       'category': category,
//                                       'time': '00:00',
//                                       'journals': '',
//                                     });
//                                   }
//                                 }
//                               });
//                             });
//                             Navigator.pop(context);
//                           },
//                           child: Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text(
//                               'Add Category',
//                               style: TextStyle(
//                                 color: Color(0xff6C60FF),
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Divider(),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: categories.length,
//                       itemBuilder: (context, index) {
//                         String category = categories[index];
//                         bool isChecked = checkboxStates[category] ?? false;
//                         return Column(
//                           children: [
//                             CheckboxListTile(
//                               title: Text(category),
//                               value: isChecked,
//                               onChanged: (bool? value) {
//                                 setState(() {
//                                   checkboxStates[category] = value ?? false;
//                                 });
//                               },
//                               controlAffinity: ListTileControlAffinity.leading,
//                             ),
//                             Divider(),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     ).then((_) {
//       setState(() {});
//     });
//   }
//
//   @override
//
//   Widget build(BuildContext context) {
//     _ensureDateExists();
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         leading: IconButton(
//           onPressed: () => _scaffoldKey.currentState?.openDrawer(),
//           icon: Icon(Icons.menu, size: 26, color: Colors.white),
//         ),
//         centerTitle: true,
//         title: Text(
//           'Home',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//       ),
//       drawer: Drawer(
//         child: AppDrawer(),
//       ),
//       body: Column(
//         children: [
//           Container(
//             height: MediaQuery.of(context).size.height * 0.075,
//             color: Color(0xff323641),
//             padding: EdgeInsets.symmetric(horizontal: 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.arrow_back_ios, color: Colors.white),
//                   onPressed: () {
//                     setState(() {
//                       if (selectedDate.subtract(Duration(days: 1)).isAfter(minStartDate!)) {
//                         selectedDate = selectedDate.subtract(Duration(days: 1));
//                         _ensureDateExists();
//                         print('hehe: $updatedData');
//                       }
//                     });
//                   },
//                 ),
//                 InkWell(
//                   onTap: () => _selectDate(context),
//                   child: Text(
//                     DateFormat('EEE, dd MMM yyyy').format(selectedDate),
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 20,
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
//                   onPressed: () {
//                     setState(() {
//                       if (selectedDate.add(Duration(days: 1)).isBefore(
//                           DateTime(currentDate.year, currentDate.month, currentDate.day + 1))) {
//                         selectedDate = selectedDate.add(Duration(days: 1));
//                         _ensureDateExists();
//                       }
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ),
//           SizedBoxHeight10,
//           DisplayCategoryList(
//             selectedDateData: _getSelectedDateData(),
//             showCategoryBottomSheet: _showCategoryBottomSheet,
//             selectTime: _selectTime,
//             navigateToJournalScreen: _navigateToJournalScreen,
//           ),
//           LockAndSaving(
//             selectedDateData: _getSelectedDateData(),
//             onSave: () {
//               String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
//               print("Data saved for $formattedDate");
//             },
//             onLock: () {
//               final DateTime selectedDateTime = selectedDate;
//               setState(() {
//                 for (var dateRange in updatedData) {
//                   final DateTime startDateTime = DateFormat('dd-MM-yyyy').parse(dateRange['startDate']);
//                   final DateTime endDateTime = DateFormat('dd-MM-yyyy').parse(dateRange['endDate']);
//
//                   if (startDateTime.isBefore(selectedDateTime) || startDateTime.isAtSameMomentAs(selectedDateTime)) {
//                     if (endDateTime.isAfter(selectedDateTime) || endDateTime.isAtSameMomentAs(selectedDateTime)) {
//                       for (var entry in dateRange['entries']) {
//                         if (entry['selectedDate'] == DateFormat('dd-MM-yyyy').format(selectedDateTime)) {
//                           entry['isLocked'] = true;
//                         }
//                       }
//                     }
//                   }
//                 }
//               });
//             },
//           ),
//           DisplayBottomDateAndHour(totalHours: totalHours,totalDays : totalDays, leftHours: leftHours, leftDays: leftDays),
//         ],
//       ),
//     );
//   }
// }
