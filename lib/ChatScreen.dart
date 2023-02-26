// ignore: file_names
import 'dart:async';

import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/services.dart';
// ignore: implementation_imports, unnecessary_import
import 'package:flutter/src/widgets/framework.dart';
// ignore: unused_import, implementation_imports
import 'package:flutter/src/widgets/placeholder.dart';
// ignore: unused_import
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
// ignore: depend_on_referenced_packages, unused_import
import 'package:async/async.dart';
import 'package:velocity_x/velocity_x.dart';

import 'ChatMessage.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _message = [];

  late OpenAI? chatGPT;

  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    chatGPT = OpenAI.instance;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _sendMessage() {
    ChatMessage message =
        ChatMessage(text: _controller.text.capitalized, sender: "USER");
    setState(() {
      _message.insert(0, message);
    });
    _controller.clear();

    final request = CompleteText(
        prompt: message.text, model: kCodeTranslateModelV2, maxTokens: 100);
    _subscription = chatGPT!
        .build(
            baseOption: HttpSetup(
                sendTimeout: 7000, connectTimeout: 7000, receiveTimeout: 7000),
            isLogger: const bool.fromEnvironment("HasanKhan"),
            token: "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")
        .onCompleteStream(request: request)
        .listen((response) {
      Vx.log(response!.choices[0].text);
      ChatMessage botMessage = ChatMessage(
          text: response.choices[0].text.capitalized, sender: "AI BOT");
      setState(() {
        _message.insert(0, botMessage);
      });
    });
  }

  Widget _buildTextComposer() {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: true,
              cursorColor: Colors.white,
              textCapitalization: TextCapitalization.characters,
              cursorWidth: 2,
              cursorHeight: 20,
              onSubmitted: (value) => _sendMessage(),
              decoration: const InputDecoration.collapsed(
                hintText: "Ask Me Anything!",
                hintStyle: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
          IconButton(
            onPressed: () => {
              _sendMessage(),
            },
            icon: const Icon(
              Icons.send_to_mobile_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat GPT-3"),
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 3),
              itemCount: _message.length,
              itemBuilder: (context, index) {
                return _message[index];
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: _buildTextComposer(),
          )
        ],
      ),
    );
  }
}
