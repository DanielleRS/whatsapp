import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'model/Message.dart';
import 'model/Usuario.dart';

class Messages extends StatefulWidget {

  Usuario contact;
  Messages(this.contact);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {

  String _idLoggedUser;
  String _idRecipientUser;

  List<String> listMessages = [
    "Olá meu amigo, tudo bem?",
    "Tudo ótimo, e contigo?",
    "Estou ótimo. Queria ver uma coisa contigo, você vai na corrida amanhã?",
    "Não sei ainda",
    "Pq se voce fosse, queria ver se posso ir com voce"
  ];

  TextEditingController _controllerMessage = TextEditingController();

  _sendMessage(){
    String textMessage = _controllerMessage.text;
    if(textMessage.isNotEmpty){
      Message message = Message();
      message.idUser = _idLoggedUser;
      message.message = textMessage;
      message.urlImage = "";
      message.type = "texto";

      _saveMessage(_idLoggedUser, _idRecipientUser, message);
    }
  }

  _saveMessage(String idSender, String idRecipient, Message msg) async {
    Firestore db = Firestore.instance;
    await db.collection("mensagens")
      .document(idSender)
      .collection(idRecipient)
      .add(msg.toMap());

    _controllerMessage.clear();
  }

  _sendPhoto(){

  }

  _recoverUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser loggedUser = await auth.currentUser();
    _idLoggedUser = loggedUser.uid;
    _idRecipientUser = widget.contact.idUser;
  }

  @override
  void initState() {
    super.initState();
    _recoverUserData();
  }

  @override
  Widget build(BuildContext context) {
    var messageBox = Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
                padding: EdgeInsets.only(right: 8),
              child: TextField(
                controller: _controllerMessage,
                autofocus: true,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                    hintText: "Digite uma mensagem...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)
                    ),
                  prefixIcon: IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: _sendPhoto
                  )
                ),
              ),
            ),
          ),
          FloatingActionButton(
            backgroundColor: Color(0xff075E54),
            child: Icon(Icons.send, color: Colors.white,),
            mini: true,
            onPressed: _sendMessage,
          )
        ],
      ),
    );

    var listView = Expanded(
      child: ListView.builder(
        itemCount: listMessages.length,
          itemBuilder: (context, index){

            double widthContainer = MediaQuery.of(context).size.width * 0.8;
            Alignment alignment = Alignment.centerRight;
            Color color = Color(0xffd2ffa5);
            if(index % 2 == 0){
              alignment = Alignment.centerLeft;
              color = Colors.white;
            }

            return Align(
              alignment: alignment,
              child: Padding(
                padding: EdgeInsets.all(6),
                child: Container(
                  width: widthContainer,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  child: Text(
                      listMessages[index],
                    style: TextStyle(
                      fontSize: 18
                    ),
                  ),
                ),
              ),
            );
          }
      ),
    );

    return Scaffold(
      appBar: AppBar(
          title: Row(
            children: <Widget>[
              CircleAvatar(
                maxRadius: 20,
                backgroundColor: Colors.grey,
                backgroundImage: widget.contact.urlImage != null
                  ? NetworkImage(widget.contact.urlImage)
                  : null),
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(widget.contact.name),
              )
            ],
          ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/bg.png"),
            fit: BoxFit.cover
          )
        ),
        child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  listView,
                  messageBox,
                ],
              ),
            )
        ),
      ),
    );
  }
}
