import 'package:flutter/material.dart';

class DisplayCategoryList extends StatefulWidget {
  final Map<String, dynamic> selectedDateData;
  final Function(BuildContext) showCategoryBottomSheet;
  final Future<void> Function(BuildContext, int) selectTime;
  final Function(BuildContext, int, String, String) navigateToJournalScreen;
  final bool isPastContract ;

  DisplayCategoryList({
    required this.selectedDateData,
    required this.showCategoryBottomSheet,
    required this.selectTime,
    required this.navigateToJournalScreen,
    required this.isPastContract,
  });

  @override
  _DisplayCategoryListState createState() => _DisplayCategoryListState();
}

class _DisplayCategoryListState extends State<DisplayCategoryList> {
  @override
  Widget build(BuildContext context) {
    final selectedDateData = widget.selectedDateData;
    final isLocked = selectedDateData['isLocked'] ?? false;

    return Expanded(
      child: ListView.builder(
        itemCount: widget.isPastContract
            ? selectedDateData['categorylist'].length + 1
            : selectedDateData['categorylist'].length,
        itemBuilder: (context, index) {
          // Handle "Add Item" for past contracts
          if (index == selectedDateData['categorylist'].length && widget.isPastContract) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 20.0, bottom: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        if (!isLocked) {
                          widget.showCategoryBottomSheet(context);
                        }
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

          // Handle regular category list items
          final item = selectedDateData['categorylist'][index];
          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.only(left: 30, top: 8, bottom: 8, right: 10),
                leading: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.29,
                    child: Text(
                      item['category'],
                      style: const TextStyle(
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
                  onTap: () {
                    if (!isLocked && widget.isPastContract) {
                      widget.selectTime(context, index);
                    }
                  },
                  child: Row(
                    children: [
                      const SizedBox(width: 10, height: 50),
                      Flexible(
                        child: Text(
                          item['time'],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 25, height: 25),
                      Image.asset(
                        'assets/images/caret_arrow_up.png',
                        height: 20,
                        width: 20,
                        semanticLabel: "Select time",
                      ),
                      const SizedBox(width: 5, height: 5),
                    ],
                  ),
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    if (!isLocked) {
                      widget.navigateToJournalScreen(
                        context,
                        index,
                        item['category'],
                        item['journals'],
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffefcd1a),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    padding: const EdgeInsets.all(12),
                    minimumSize: const Size(110, 38),
                  ),
                  child: const Text(
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
    );
  }
}