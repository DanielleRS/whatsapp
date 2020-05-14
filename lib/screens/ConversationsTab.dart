import 'dart:async';
import 'package:flutter/material.dart';
import 'package:whatsapp/model/Conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConversationsTab extends StatefulWidget {
  @override
  _ConversationsTabState createState() => _ConversationsTabState();
}

class _ConversationsTabState extends State<ConversationsTab> {

  List<Conversation> _listConversations = List();
  final _controller = StreamController<QuerySnapshot>.broadcast();
  Firestore db = Firestore.instance;
  String _idLoggedUser;

  @override
  void initState() {
    super.initState();
    _recoverUserData();

    Conversation conversation = Conversation();
    conversation.name = "Ana Clara";
    conversation.message = "Olá, tudo bem?";
    conversation.photo = "https://firebasestorage.googleapis.com/v0/b/whatsapp-97983.appspot.com/o/profiles%2Fperfil1.jpg?alt=media&token=6a3e62ac-290d-4d7e-82d9-e868f245aa9d";

    _listConversations.add(conversation);
  }

  Stream<QuerySnapshot> _addListenerConversation(){
    final stream = db.collection("conversations")
        .document(_idLoggedUser)
        .collection("last_conversation")
        .snapshots();

    stream.listen((data){
      _controller.add(data);
    });
  }

  _recoverUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser loggedUser = await auth.currentUser();
    _idLoggedUser = loggedUser.uid;

    _addListenerConversation();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _controller.stream,
      builder: (context, snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: <Widget>[
                  Text("Carregando conversas"),
                  CircularProgressIndicator()
                ],
              ),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text("Erro ao carregar os dados.");
            } else {
              QuerySnapshot querySnapshot = snapshot.data;
              if(querySnapshot.documents.length == 0){
                return Center(
                  child: Text(
                    "Você não tem nenhuma conversa ainda :(",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                );
              }
              return ListView.builder(
                  itemCount: _listConversations.length,
                  itemBuilder: (context, index){
                    List<DocumentSnapshot> conversations = querySnapshot.documents.toList();
                    DocumentSnapshot item = conversations[index];

                    String urlImage = item["photo"];
                    String type = item["typeMessage"];
                    String message = item["message"];
                    String name = item["name"];

                    return ListTile(
                      contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      leading: CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: Colors.grey,
                        backgroundImage: urlImage != null
                            ? NetworkImage(urlImage)
                            : null,
                      ),
                      title: Text(
                        name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),
                      ),
                      subtitle: Text(
                        type == "texto"
                            ? message
                            : "Imagem...",
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
      },
    );
  }
}
