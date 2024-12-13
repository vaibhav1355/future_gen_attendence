import 'package:flutter/material.dart';

class Journal extends StatefulWidget {
  const Journal({super.key});

  @override
  State<Journal> createState() => _JournalState();
}

class _JournalState extends State<Journal> {
  final TextEditingController _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(child: Text('Write a Note')),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _bodyController,
              maxLines: 20,
              decoration: InputDecoration(
                hintText: 'Notes',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
