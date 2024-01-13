import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  List<String> courses = [];
  List<String> scores = [];

  void initState() {
    _loadItems();
    super.initState();
  }

  void _loadItems() async {
    List<String> Cour1 = [];
    List<String> Scor1 = [];
    final url = Uri.https(
        'e-course-app-c9928-default-rtdb.asia-southeast1.firebasedatabase.app',
        'enroll.json');
    final response = await http.get(url);
    print('#Debug grocery_list.dart');
    print(response.body);
    final Map<String, dynamic> listData = json.decode(response.body);
    print('#Debug grocery_list.dart');
    print(listData);

    for (final item in listData.entries) {
      Cour1.add(item.value['Course']);
      Scor1.add(item.value['Score']);
    }

    setState(() {
      courses = Cour1;
      scores = Scor1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.book),
            title: Text(courses[index]),
            subtitle: Text('Score: ' + scores[index]),
          );
        },
      ),
    );
  }
}
