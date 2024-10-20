import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/scheduler.dart';
import 'schedule_menu.dart';
import 'community_tab.dart';
import 'loading_screen.dart';
import 'profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
   const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudySphere',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: FutureBuilder(
        future: Future.delayed(Duration(seconds: 2)), // Simulating loading time
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          } else {
            return MainScreen();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, String>> messages = [];
  bool _canSend = true;
  int _currentIndex = 2;

  void sendRequest(String userMessage) async {
    if (!_canSend) return;

    setState(() {
      messages.add({
        'sender': 'user',
        'message': userMessage.toString(),
      });
      controller.clear();
      _canSend = false;
    });

    _scrollToBottom();

    try {
      var url = 'https://5459-34-75-129-224.ngrok-free.app/predict';
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'message': userMessage}),
      );
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        setState(() {
          messages.add({
            'sender': 'StudySphere',
            'message': responseData.toString(),
          });
        });

        _scrollToBottom();
      }
    } on Exception catch (e) {
      print('Failed to get response from server. Status code: $e}');
    }

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _canSend = true;
      });
    });
  }

  void _scrollToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return ScheduleMenu();
      case 1:
        return _buildChatBot();
      case 2:
        return HomeMenu();
      case 3:
        return CommunityTab();
      case 4:
        return ProfilePage();
      default:
        return HomeMenu();
    }
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: _getPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onBottomNavTapped,
      ),
    );
  }

  Widget _buildChatBot() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];
              final isUser = msg['sender'] == 'user';
              return Align(
                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.blue[100] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: isUser
                      ? Text(
                          msg['message']!,
                          style: TextStyle(color: Colors.black87),
                        )
                      : TypewriterText(msg['message']!),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (message) {
                      if (_canSend) {
                        sendRequest(message);
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _canSend ? () => sendRequest(controller.text) : null,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
class HomeMenu extends StatelessWidget {
  const HomeMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/stud_sphere_profile.png', height: 40),
            SizedBox(width: 10),
            Text('StudySphere Home'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Welcome back, Mohamed!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Balance: 256 coins", style: TextStyle(fontSize: 20, color: Colors.grey)),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildCard(
                    title: "Grades Summary",
                    content: "Overall: 42% increase\nMaths: 18.25/20\nPhysics: 14.5/20\nEnglish: 20/20\nFrench: 1.5/20",
                    color: Colors.lightBlueAccent,
                  ),
                  SizedBox(height: 10),
                  _buildCard(
                    title: "Achievements Progress",
                    content: "This month:\n42% more increase in grades\n37% more increase in studying time\nBetter sleep schedule",
                    color: Colors.greenAccent,
                  ),
                  SizedBox(height: 10),
                  _buildCard(
                    title: "Upcoming Sessions",
                    content: "In 10 minutes: Pick up French notes\n8:15 AM: Revise notes with Jane",
                    color: Colors.orangeAccent,
                  ),
                  SizedBox(height: 10),
                  _buildCard(
                    title: "Currency Earned Yesterday",
                    content: "+10 from achievements\n+3 from Chat-Bot",
                    color: Colors.purpleAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required String content, required Color color}) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(content, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class TypewriterText extends StatefulWidget {
  final String text;
  const TypewriterText(this.text, {Key? key}) : super(key: key);

  @override
  _TypewriterTextState createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.text.length * 50), // Adjust speed here
      vsync: this,
    );
    _animation = IntTween(begin: 0, end: widget.text.length).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          widget.text.substring(0, _animation.value),
          style: TextStyle(color: Colors.black87),
        );
      },
    );
  }
}