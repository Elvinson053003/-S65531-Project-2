import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddCourseScreen extends StatelessWidget {
  final TextEditingController _courseNameController = TextEditingController();

  void _saveItem() async {
    final url = Uri.https(
        'e-course-app-c9928-default-rtdb.asia-southeast1.firebasedatabase.app',
        'course.json');

    var courseadd = _courseNameController.text;

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        {'Course': courseadd},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _courseNameController,
              decoration: InputDecoration(labelText: 'Course Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveItem();
              },
              child: Text('Add Course'),
            ),
          ],
        ),
      ),
    );
  }
}
