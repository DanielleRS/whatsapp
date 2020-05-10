import 'package:flutter/material.dart';
import 'package:whatsapp/model/Conversation.dart';

class ConversationsTab extends StatefulWidget {
  @override
  _ConversationsTabState createState() => _ConversationsTabState();
}

class _ConversationsTabState extends State<ConversationsTab> {

  List<Conversation> listConversations = [
    Conversation(
      "Ana Clara",
      "Olá, tudo bem?",
      "https://firebasestorage.googleapis.com/v0/b/whatsapp-97983.appspot.com/o/profiles%2Fperfil1.jpg?alt=media&token=6a3e62ac-290d-4d7e-82d9-e868f245aa9d"
    ),
    Conversation(
        "Pedro Silva",
        "Me manda o nome daquela série que falamos!",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-97983.appspot.com/o/profiles%2Fperfil2.jpg?alt=media&token=e6d64652-65d4-412c-bcfa-e965b85df083"
    ),
    Conversation(
        "Marcela Almeida",
        "Olá, tudo bem?",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-97983.appspot.com/o/profiles%2Fperfil3.jpg?alt=media&token=56b9fb35-519f-4840-b3f9-b2b7f4021f03"
    ),
    Conversation(
        "José Renato",
        "Olá, tudo bem?",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-97983.appspot.com/o/profiles%2Fperfil4.jpg?alt=media&token=e8600f16-2372-4bf5-9ba4-a776467a3c27"
    ),
    Conversation(
        "Jamilton Damasceno",
        "Olá, tudo bem?",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-97983.appspot.com/o/profiles%2Fperfil5.jpg?alt=media&token=a08096ce-d56c-4fbe-8509-cca4c7922ffb"
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listConversations.length,
      itemBuilder: (context, index){
        Conversation conversation = listConversations[index];
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
