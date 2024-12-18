import 'package:flutter/material.dart';

class DisplayBottomDateAndHour extends StatelessWidget {
  double totalHours ;
  int totalDays ;
  double leftHours;
  double leftDays;

  DisplayBottomDateAndHour({required this.totalHours , required this.totalDays , required this.leftHours , required this.leftDays});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (BuildContext context) {
            return Wrap(
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
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
                                'D-$leftDays',
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
                                'H-$leftHours',
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Hours:',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '$totalHours',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Left Hours:',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '$leftHours',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Days:',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '$totalDays',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Left Days:',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '$leftDays',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
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
                'D-$leftDays',
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
                'H- $leftHours',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




