import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plants_app/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Map<String, String>> messages = [];

  @override
  void initState() {
    super.initState();
    dotenv.load();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final storedMessages = prefs.getString('chat_messages');
    if (storedMessages != null) {
      final List<dynamic> decoded = json.decode(storedMessages);
      setState(() {
        messages = decoded.map<Map<String, String>>((item) => Map<String, String>.from(item)).toList();
      });
    }
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('chat_messages', json.encode(messages));
  }

  Future<void> _clearMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_messages');
    setState(() {
      messages.clear();
    });
  }

  Future<void> getChatResponse(String userInput) async {
    final String url = 'https://router.huggingface.co/fireworks-ai/inference/v1/chat/completions';
    final String apiKey = dotenv.env['HUGGINGFACE_API_KEY'] ?? '';

    if (apiKey.isEmpty) {
      return;
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "messages": [{"role": "user", "content": userInput}],
        "max_tokens": 512,
        "model": "accounts/fireworks/models/llama-v3p1-8b-instruct",
        "stream": false,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final reply = data['choices'][0]['message']['content'] ?? 'No response';

      setState(() {
        messages.add({'role': 'assistant', 'content': reply});
      });

      _saveMessages();
    }
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      messages.add({'role': 'user', 'content': text});
    });
    _controller.clear();
    getChatResponse(text);
    _saveMessages();
  }

  void _confirmClearMessages() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus semua chat?'),
        content: const Text('Apakah kamu yakin ingin menghapus seluruh riwayat percakapan?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Hapus'),
            onPressed: () {
              _clearMessages();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'VineBot', 
          style: TextStyle( 
            color: Constants.blackColor,
            fontWeight: FontWeight.w500,
          )
        ),  
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Constants.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            tooltip: 'Hapus semua chat',
            onPressed: _confirmClearMessages,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: messages.isEmpty
                  ? const Center(child: Text('Belum ada percakapan.'))
                  : ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isUser = message['role'] == 'user';

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Align(
                            alignment:
                                isUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isUser ? Constants.primaryColor : Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              constraints: const BoxConstraints(maxWidth: 250),
                              child: Column(
                                crossAxisAlignment: isUser
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  if (!isUser)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Colors.grey,
                                        child: Image.asset(
                                          'assets/images/bot.png',
                                          width: 28,
                                          height: 28,
                                        ),
                                      ),
                                    ),
                                  Text(
                                    message['content'] ?? '',
                                    style: TextStyle(
                                      color: isUser ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 10.0, 15.0),
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _sendMessage,
                      decoration: InputDecoration(
                        hintText: 'Ketik pesan...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
