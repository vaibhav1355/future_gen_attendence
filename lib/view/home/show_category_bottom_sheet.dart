import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CategoryBottomSheet {

  static const List<String> categories = [
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

  static void showCategoryBottomSheet({
    required BuildContext context,
    required Map<String, dynamic> selectedDateData,
    required VoidCallback onCategoryAdded,
  }) {
    Map<String, bool> checkboxStates = {};

    selectedDateData['categorylist'].forEach((item) {
      checkboxStates[item['category']] = true;
    });

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Padding(
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

                            onCategoryAdded(); // Notify parent widget of changes
                            Navigator.pop(context);
                          },
                          child: const Padding(
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
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        String category = categories[index];
                        bool isChecked = checkboxStates[category] ?? false;

                        // Check if the category is already selected
                        bool isAlreadySelected = selectedDateData['categorylist']
                            .any((item) => item['category'] == category);

                        return Column(
                          children: [
                            CheckboxListTile(
                              title: Text(category),
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (isAlreadySelected && !(value ?? false)) {
                                    // Prevent unchecking already selected categories
                                    return;
                                  }
                                  checkboxStates[category] = value ?? false;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            const Divider(),
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
    );
  }
}
