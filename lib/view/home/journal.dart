import 'package:flutter/material.dart';

class JournalScreen extends StatefulWidget {
  final int index;
  final String category;
  final String initialJournalText;
  final Function(String) onJournalUpdate; // Add this callback

  JournalScreen({
    required this.index,
    required this.category,
    required this.initialJournalText,
    required this.onJournalUpdate, // Include this in the constructor
  });

  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  TextEditingController _journalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _journalController.text = widget.initialJournalText;
    // Add listener to save text as user types
    _journalController.addListener(_saveJournalText);
  }

  // Function to save journal text whenever it changes
  void _saveJournalText() {
    // This will update the parent widget's journal text as the user types
    final updatedText = _journalController.text;
    // You can update the state of the parent widget (via the callback or state management)
    widget.onJournalUpdate(updatedText);
  }

  @override
  void dispose() {
    _journalController.removeListener(_saveJournalText); // Remove the listener when the widget is disposed
    _journalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Journal - ${widget.category}"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Category: ${widget.category}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _journalController,
              decoration: InputDecoration(
                hintText: "Enter your journal entry here...",
                border: OutlineInputBorder(),
              ),
              maxLines: 10,
            ),
          ],
        ),
      ),
    );
  }
}

