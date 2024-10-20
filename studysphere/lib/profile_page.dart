import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Column(
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/pfp.png'),
          ),
          SizedBox(height: 20),
          Text('Mohamed Attia', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('Student', style: TextStyle(fontSize: 18, color: Colors.grey)),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.school),
            title: Text('Education'),
            subtitle: Text('Computer Science, University of XYZ'),
          ),
          ListTile(
            leading: Icon(Icons.emoji_events),
            title: Text('Achievements'),
            subtitle: Text('10 badges earned'),
          ),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text('Study Time'),
            subtitle: Text('120 hours this month'),
          ),
        ],
      ),
    );
  }
}