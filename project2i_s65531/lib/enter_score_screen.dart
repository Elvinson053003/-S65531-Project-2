import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EnterScoreScreen extends StatefulWidget {
  const EnterScoreScreen({super.key});

  @override
  State<EnterScoreScreen> createState() => _EnterScoreScreenState();
}

class _EnterScoreScreenState extends State<EnterScoreScreen> {
  List<String> courses = [];
  List<double> scores = [];
  TextEditingController _scoreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    List<String> Cour1 = [];
    List<double> Sco1 = [];
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
      Sco1.add(item.value['Score']);
    }

    setState(() {
      courses = Cour1;
      scores = Sco1;
    });
  }

  void _updateItems(String co2) async {
    final update = Uri.https(
        'e-course-app-c9928-default-rtdb.asia-southeast1.firebasedatabase.app',
        'enroll.json');
    final updateResponse = await http.get(update);
    final Map<String, dynamic> findKey = json.decode(updateResponse.body);
    var _key = '';
    findKey.forEach((key, value) {
      if (value['Course'] == co2) {
        _key = key;
      }
    });
    final Map<String, dynamic> updateLast = {
      _key: {
        'Course': co2,
        'Score': _scoreController.text,
      }
    };
    try {
      final response = await http.patch(
        update,
        body: json.encode(updateLast),
      );

      if (response.statusCode == 200) {
        print('Data updated successfully');
      } else {
        print('Failed to update data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Subject Scores'),
      ),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.book),
            title: Text(courses[index]),
            subtitle: Text(scores[index].toString()),
            onTap: () {
              _showScoreDialog(context, courses[index]);
            },
          );
        },
      ),
    );
  }

  void _showScoreDialog(BuildContext context, String course1) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Score for $course1'),
          content: TextField(
            controller: _scoreController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Score'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateItems(course1);
                String enteredScore = _scoreController.text;
                print('Entered score for $course1: $enteredScore');
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
