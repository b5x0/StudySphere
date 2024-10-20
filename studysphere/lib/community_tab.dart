import 'package:flutter/material.dart';

class CommunityTab extends StatelessWidget {
  const CommunityTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Community')),
      body: ListView(
        children: [
          _buildForumSection('Announcements', [
            'Welcome to the forums!',
            'Rules and support',
          ]),
          _buildForumSection('Public Forums', [
            'How to get started on StudySphere',
            'Better plan your schedule',
          ]),
        ],
      ),
    );
  }

  Widget _buildForumSection(String title, List<String> topics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ...topics.map((topic) => ListTile(
              leading: Icon(Icons.forum),
              title: Text(topic),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to topic page
              },
            )),
      ],
    );
  }
}