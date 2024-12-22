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
//   final List<Map<String, dynamic>> updatedData = [
//     // Your updatedData list here...
//   ];
//
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final DateTime currentDate = DateTime.now();
//   DateTime selectedDate = DateTime.now();
//
//   DateTime? minStartDate;
//   DateTime? maxEndDate;
//
//   double totalHours = 0.0;
//   int totalDays = 0;
//   double leftHours = 0.0;
//   double leftDays = 0.0;
//
//   bool contractExist = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _calculateMinAndMaxDates();
//     updateTotalDaysAndHours();
//   }
//
//   void updateTotalDaysAndHours() {
//     int _daysBetween(DateTime start, DateTime end) => end.difference(start).inDays;
//
//     try {
//       for (var range in updatedData) {
//         DateTime rangeStartDate = DateFormat('dd-MM-yyyy').parse(range['startDate']);
//         DateTime rangeEndDate = DateFormat('dd-MM-yyyy').parse(range['endDate']);
//
//         int totalUsedHours = 0, totalUsedMinutes = 0;
//
//         for (var entry in range['entries']) {
//           DateTime entryDate = DateFormat('dd-MM-yyyy').parse(entry['selectedDate']);
//
//           if (entryDate.isBefore(selectedDate) || entryDate.isAtSameMomentAs(selectedDate)) {
//             for (var item in entry['categorylist']) {
//               final timeParts = item['time'].split(':');
//               if (timeParts.length == 2) {
//                 totalUsedHours += int.tryParse(timeParts[0]) ?? 0;
//                 totalUsedMinutes += int.tryParse(timeParts[1]) ?? 0;
//               }
//             }
//           }
//         }
//
//         totalUsedHours += totalUsedMinutes ~/ 60;
//         totalUsedMinutes %= 60;
//
//         int rangeDays = _daysBetween(rangeStartDate, rangeEndDate) + 1;
//         double rangeTotalHours = rangeDays * 8.0; // Assuming 8 hours per day
//         double remainingHours = rangeTotalHours - totalUsedHours - (totalUsedMinutes / 60.0);
//
//         setState(() {
//           range['totalDays'] = rangeDays;
//           range['totalHours'] = rangeTotalHours;
//           range['leftHours'] = double.parse(remainingHours.toStringAsFixed(2));
//           range['leftDays'] = double.parse((remainingHours / 8.0).toStringAsFixed(2));
//
//           totalDays = rangeDays;
//           totalHours = rangeTotalHours;
//           leftHours = range['leftHours'];
//           leftDays = range['leftDays'];
//         });
//         break;
//       }
//     } catch (e) {
//       print('Error in updateTotalDaysAndHours: $e');
//     }
//   }
//
//   void _calculateMinAndMaxDates() {
//     final DateFormat dateFormat = DateFormat("dd-MM-yyyy");
//
//     List<DateTime> startDates = updatedData.map((data) => dateFormat.parse(data['startDate'] as String)).toList();
//     List<DateTime> endDates = updatedData.map((data) => dateFormat.parse(data['endDate'] as String)).toList();
//
//     minStartDate = startDates.reduce((a, b) => a.isBefore(b) ? a : b);
//     maxEndDate = endDates.reduce((a, b) => a.isAfter(b) ? a : b);
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
//       });
//     }
//   }
//
//   void _ensureDateExists() {
//     bool dateExists = false;
//     for (var range in updatedData) {
//       DateTime rangeStartDate = DateFormat('dd-MM-yyyy').parse(range['startDate']);
//       DateTime rangeEndDate = DateFormat('dd-MM-yyyy').parse(range['endDate']);
//
//       if (selectedDate.isAfter(rangeStartDate.subtract(Duration(days: 1))) && selectedDate.isBefore(rangeEndDate.add(Duration(days: 1)))) {
//         dateExists = true;
//         if (range['entries'] is! List) {
//           range['entries'] = [];
//         }
//         bool dataExists = range['entries'].any((entry) =>
//         entry['selectedDate'] == DateFormat('dd-MM-yyyy').format(selectedDate));
//
//         if (!dataExists) {
//           range['entries'].add({
//             'selectedDate': DateFormat('dd-MM-yyyy').format(selectedDate),
//             'isLocked': false,
//             'categorylist': [
//               {'category': 'Admin-General', 'time': '0:00', 'journals': ''},
//               {'category': 'Academic-General', 'time': '0:00', 'journals': ''},
//               {'category': 'Fundraising-General', 'time': '0:00', 'journals': ''},
//             ],
//           });
//         }
//       }
//     }
//
//     setState(() {
//       contractExist = dateExists;
//     });
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
//   @override
//   Widget build(BuildContext context) {
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
//           // Existing code for UI, handling selected date, etc.
//           contractExist ? DisplayCategoryList(
//             selectedDateData: _getSelectedDateData(),
//             showCategoryBottomSheet: _showCategoryBottomSheet,
//             selectTime: _selectTime,
//             navigateToJournalScreen: _navigateToJournalScreen,
//           ) : NoContractPage(),
//         ],
//       ),
//     );
//   }
// }
//
// class NoContractPage extends StatelessWidget {
//   const NoContractPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(height: MediaQuery.of(context).size.height * 0.40),
//         Text(
//           'No Contract Exist on this date',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w400,
//             color: Colors.grey,
//           ),
//         ),
//       ],
//     );
//   }
// }
