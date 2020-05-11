import 'package:flutter/material.dart';

import 'model/Usuario.dart';

class Messages extends StatefulWidget {

  Usuario contact;
  Messages(this.contact);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.contact.name)),
      body: Container(),
    );
  }
}
