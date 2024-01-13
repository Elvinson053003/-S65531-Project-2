import 'package:flutter/material.dart';
import 'add_course_screen.dart';
import 'enter_score_screen.dart';
import 'logout_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentIndex = 0;
  List<String> courses = [];

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

  @override
  Widget build(BuildContext context) {
    _loadItems();
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Home'),
      ),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.book),
            title: Text(courses[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCourseScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EnterScoreScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LogoutPage()),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Enter Scores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
      ),
    );
  }
}
