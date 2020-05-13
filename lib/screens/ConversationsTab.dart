import 'package:flutter/material.dart';
import 'package:whatsapp/model/Conversation.dart';

class ConversationsTab extends StatefulWidget {
  @override
  _ConversationsTabState createState() => _ConversationsTabState();
}

class _ConversationsTabState extends State<ConversationsTab> {

  List<Conversation> _listConversations = List();

  @override
  void initState() {
    super.initState();

    Conversation conversation = Conversation();
    conversation.name = "Ana Clara";
    conversation.message = "Olá, tudo bem?";
    conversation.photo = "https://firebasestorage.googleapis.com/v0/b/whatsapp-97983.appspot.com/o/profiles%2Fperfil1.jpg?alt=media&token=6a3e62ac-290d-4d7e-82d9-e868f245aa9d";

    _listConversations.add(conversation);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _listConversations.length,
      itemBuilder: (context, index){
        Conversation conversation = _listConversations[index];
        return ListTile(
          contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          leading: CircleAvatar(
            maxRadius: 30,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(conversation.photo),
          ),
          title: Text(
            conversation.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),
          ),
          subtitle: Text(
            conversation.message,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 18
            ),
          ),
        );
      }
    );
  }
}
