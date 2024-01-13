import 'package:flutter/material.dart';
import 'result_screen.dart';
import 'logout_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudentHomeScreen extends StatefulWidget {
  @override
  _StudentHomeScreenState createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  int _currentIndex = 0;
  List<String> courses = [];
  List<double> scores = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    List<String> Cour1 = [];
    final url = Uri.https(
        'e-course-app-c9928-default-rtdb.asia-southeast1.firebasedatabase.app',
        'course.json');
    final response = await http.get(url);
    print('#Debug grocery_list.dart');
    print(response.body);
    final Map<String, dynamic> listData = json.decode(response.body);
    print('#Debug grocery_list.dart');
    print(listData);

    for (final item in listData.entries) {
      Cour1.add(item.value['Course']);
    }

    setState(() {
      courses = Cour1;
    });
  }

  void _saveItem(String co1, double sco) async {
    final url = Uri.https(
        'e-course-app-c9928-default-rtdb.asia-southeast1.firebasedatabase.app',
        'enroll.json');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        {'Course': co1, 'Score': sco},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Home'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Result',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
      ),
      body: _currentIndex == 0
          ? _buildHomeScreen()
          : _currentIndex == 1
              ? ResultScreen()
              : LogoutPage(),
    );
  }

  Widget _buildHomeScreen() {
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.book),
          title: Text(courses[index]),
          onTap: () {
            _saveItem(courses[index], 0);
          },
        );
      },
    );
  }
}
