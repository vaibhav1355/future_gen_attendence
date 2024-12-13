import 'package:flutter/material.dart';

class DateAndHour extends StatelessWidget {
  const DateAndHour({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
    );
  }
}
