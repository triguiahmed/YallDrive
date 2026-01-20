import 'package:car_rental_app_clean_arch/features/profile/presentation/widgets/help_option.dart';
import 'package:flutter/material.dart';

class CustomerHelp extends StatelessWidget {
  const CustomerHelp({super.key});

  void _showHelpBottomSheet(BuildContext context, String title, Widget content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              content,
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Close"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Get Help', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HelpOption(
              icon: Icons.help_outline,
              title: 'Help Center',
              subtitle: "Search a library of help articles",
              onTap: () {
                _showHelpBottomSheet(
                  context, 
                  "Help Center",
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Search for common issues:", style: TextStyle(fontWeight: FontWeight.bold)),
                      ListTile(
                        leading: Icon(Icons.article),
                        title: Text("How to book a car?"),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.payment),
                        title: Text("Payment & refund policies"),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.security),
                        title: Text("Safety guidelines for renters"),
                        onTap: () {},
                      ),
                    ],
                  ),
                );
              },
            ),
            HelpOption(
              icon: Icons.phone,
              title: 'Contact Host',
              subtitle: 'Message or call your host',
              onTap: () {
                _showHelpBottomSheet(
                  context, 
                  "Contact Host",
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Reach out to your host:", style: TextStyle(fontWeight: FontWeight.bold)),
                      ListTile(
                        leading: Icon(Icons.message),
                        title: Text("Send a Message"),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.call),
                        title: Text("Call Host"),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.email),
                        title: Text("Email Support"),
                        onTap: () {},
                      ),
                    ],
                  ),
                );
              },
            ),
            HelpOption(
              icon: Icons.headset_mic,
              title: 'Contact Support',
              subtitle: 'Call or chat with support',
              onTap: () {
                _showHelpBottomSheet(
                  context, 
                  "Contact Support",
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Choose your preferred support option:", style: TextStyle(fontWeight: FontWeight.bold)),
                      ListTile(
                        leading: Icon(Icons.chat),
                        title: Text("Live Chat with Support"),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.call),
                        title: Text("Call Customer Support"),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.help),
                        title: Text("Submit a Support Ticket"),
                        onTap: () {},
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LiveChatScreen extends StatefulWidget {
  const LiveChatScreen({super.key});

  @override
  State<LiveChatScreen> createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends State<LiveChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  static const String _groqApiKey = "";
  static const String _groqApiUrl = "https://api.groq.com/openai/v1/chat/completions";

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _messages.add(
      ChatMessage(
        text: "Hello! I'm your Car Rental support assistant. How can I help you today?",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text.trim();
    _messageController.clear();

    setState(() {
      _messages.add(
        ChatMessage(
          text: userMessage,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final response = await _getGroqResponse(userMessage);
      
      setState(() {
        _messages.add(
          ChatMessage(
            text: response,
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: "Sorry, I'm having trouble connecting right now. Please try again or contact us at ahmed.trigui@outlook.com",
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  Future<String> _getGroqResponse(String userMessage) async {
    final messages = [
      {
        "role": "system",
        "content": "You are a car rental customer support assistant. Your job is to help customers with their car rental questions, booking issues, payment problems, and general inquiries. Be friendly, professional, and helpful. Keep responses concise and clear."
      },
      // Include conversation history for context
      ..._messages.where((m) => !m.isUser || m.text != userMessage).map((m) => {
        "role": m.isUser ? "user" : "assistant",
        "content": m.text,
      }),
      {
        "role": "user",
        "content": userMessage,
      }
    ];

    final response = await http.post(
      Uri.parse(_groqApiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_groqApiKey',
      },
      body: jsonEncode({
        'model': 'llama-3.3-70b-versatile',
        'messages': messages,
        'temperature': 0.7,
        'max_tokens': 500,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to get response: ${response.statusCode}');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.support_agent, color: Colors.purple),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Support Chat',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  'Online',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _messages[index];
                },
              ),
            ),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(width: 16),
                    CircleAvatar(
                      backgroundColor: Colors.purple.shade100,
                      child: Icon(Icons.support_agent, color: Colors.purple, size: 20),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.purple),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Typing...', style: TextStyle(color: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.purple.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.purple.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.purple, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.purple,
                    radius: 24,
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              backgroundColor: Colors.purple.shade100,
              child: Icon(Icons.support_agent, color: Colors.purple, size: 20),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? Colors.purple : Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: isUser ? Radius.circular(20) : Radius.circular(4),
                  bottomRight: isUser ? Radius.circular(4) : Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      color: isUser ? Colors.white70 : Colors.grey.shade600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.purple,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ],
        ],
      ),
    );
  }
}
