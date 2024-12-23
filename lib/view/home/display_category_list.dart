import 'package:flutter/material.dart';

class DisplayCategoryList extends StatefulWidget {
  final Map<String, dynamic> selectedDateData;
  final Function(BuildContext) showCategoryBottomSheet;
  final Future<void> Function(BuildContext, int) selectTime;
  final Function(BuildContext, int, String, String) navigateToJournalScreen;
  final bool isPastContract;

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

    // Get the isLocked value for the current date from selectedDateData
    final isLocked = selectedDateData['isLocked'] ?? false;

    // Determine if we need to add an "Add Item" button at the bottom
    final showAddItemButton = widget.isPastContract && !isLocked;

    return Expanded(
      child: ListView.builder(
        itemCount: showAddItemButton
            ? selectedDateData['categorylist'].length + 1
            : selectedDateData['categorylist'].length,
        itemBuilder: (context, index) {
          // If we are showing the "Add Item" button, handle its logic
          if (showAddItemButton && index == selectedDateData['categorylist'].length) {
            return _buildAddItemButton(context, isLocked);
          }

          // Regular category list item
          final item = selectedDateData['categorylist'][index];
          return _buildCategoryItem(context, item, index, isLocked);
        },
      ),
    );
  }

  // Widget to build the "Add Item" button
  Widget _buildAddItemButton(BuildContext context, bool isLocked) {
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

  // Widget to build each category list item
  Widget _buildCategoryItem(BuildContext context, Map<String, dynamic> item, int index, bool isLocked) {
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
        const Divider(),
      ],
    );
  }
}
