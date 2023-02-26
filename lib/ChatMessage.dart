// ignore_for_file: unused_import

import 'package:flutter/material.dart';
// ignore: unnecessary_import, implementation_imports
import 'package:flutter/src/widgets/framework.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/placeholder.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.text, required this.sender});

  final String text;
  final String sender;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.all(5),
          child: Container(
            padding: const EdgeInsets.all(5),
            child: CircleAvatar(
              backgroundColor: sender == "USER"
                  ? const Color.fromARGB(255, 255, 145, 0)
                  : Colors.greenAccent,
              foregroundColor: Colors.white,
              child: sender == "USER"
                  ? const Icon(
                      Icons.person,
                      size: 30,
                    )
                  : const Icon(Icons.person_4_sharp, size: 30),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sender,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Container(
                margin: const EdgeInsets.all(5),
                child: Text(text),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void insert(int i, ChatMessage message) {}
}
