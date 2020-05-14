import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'model/Message.dart';
import 'model/Usuario.dart';
import 'model/Conversation.dart';

class Messages extends StatefulWidget {
  Usuario contact;
  Messages(this.contact);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  File _image;
  bool _climbingImage = false;
  String _idLoggedUser;
  String _idRecipientUser;
  Firestore db = Firestore.instance;

  TextEditingController _controllerMessage = TextEditingController();

  _sendMessage() {
    String textMessage = _controllerMessage.text;
    if (textMessage.isNotEmpty) {
      Message message = Message();
      message.idUser = _idLoggedUser;
      message.message = textMessage;
      message.urlImage = "";
      message.type = "texto";

      _saveMessage(_idLoggedUser, _idRecipientUser, message);
      _saveMessage(_idRecipientUser, _idLoggedUser, message);
      _saveConversation(message);
    }
  }

  _saveConversation(Message msg){
    //Remetente
    Conversation cSend = Conversation();
    cSend.idSender = _idLoggedUser;
    cSend.idRecipient = _idRecipientUser;
    cSend.message = msg.message;
    cSend.name = widget.contact.name;
    cSend.photo = widget.contact.urlImage;
    cSend.typeMessage = msg.type;
    cSend.save();

    //Destinatário
    Conversation cRecipient = Conversation();
    cRecipient.idSender = _idRecipientUser;
    cRecipient.idRecipient = _idLoggedUser;
    cRecipient.message = msg.message;
    cRecipient.name = widget.contact.name;
    cRecipient.photo = widget.contact.urlImage;
    cRecipient.typeMessage = msg.type;
    cRecipient.save();
  }

  _saveMessage(String idSender, String idRecipient, Message msg) async {
    await db
        .collection("mensagens")
        .document(idSender)
        .collection(idRecipient)
        .add(msg.toMap());

    _controllerMessage.clear();
  }

  _sendPhoto() async {
    File selectedImage ;
    selectedImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    _climbingImage = true;
    String nameImage = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference rootFolder = storage.ref();
    StorageReference archive = rootFolder
        .child("mensagens")
        .child(_idLoggedUser)
        .child(nameImage + ".jpg");

    //Upload da imagem
    StorageUploadTask task = archive.putFile(selectedImage);

    //Controlar progresso do upload
    task.events.listen((StorageTaskEvent storageEvent){
      if(storageEvent.type == StorageTaskEventType.progress){
        setState(() {
          _climbingImage = true;
        });
      } else if(storageEvent.type == StorageTaskEventType.success){
        setState(() {
          _climbingImage = false;
        });
      }
    });

    //Recuperar url da imagem
    task.onComplete.then((StorageTaskSnapshot snapshot){
      _recoverUrlImage(snapshot);
    });
  }

  Future _recoverUrlImage(StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();

    Message message = Message();
    message.idUser = _idLoggedUser;
    message.message = "";
    message.urlImage = url;
    message.type = "imagem";

    _saveMessage(_idLoggedUser, _idRecipientUser, message);
    _saveMessage(_idRecipientUser, _idLoggedUser, message);
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
                        borderRadius: BorderRadius.circular(32)),
                    prefixIcon:
                        _climbingImage
                          ? CircularProgressIndicator()
                          : IconButton(icon: Icon(Icons.camera_alt), onPressed: _sendPhoto)),
              ),
            ),
          ),
          FloatingActionButton(
            backgroundColor: Color(0xff075E54),
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
            mini: true,
            onPressed: _sendMessage,
          )
        ],
      ),
    );

    var stream = StreamBuilder(
      stream: db
          .collection("mensagens")
          .document(_idLoggedUser)
          .collection(_idRecipientUser)
          .snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: <Widget>[
                  Text("Carregando mensagens"),
                  CircularProgressIndicator()
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            QuerySnapshot querySnapshot = snapshot.data;
            if (snapshot.hasError) {
              return Text("Erro ao carregar os dados.");
            } else {
              return Expanded(
                child: ListView.builder(
                    itemCount: querySnapshot.documents.length,
                    itemBuilder: (context, index) {
                      List<DocumentSnapshot> messages = querySnapshot.documents.toList();
                      DocumentSnapshot item = messages[index];

                      double widthContainer =
                          MediaQuery.of(context).size.width * 0.8;
                      Alignment alignment = Alignment.centerRight;
                      Color color = Color(0xffd2ffa5);
                      if (_idLoggedUser != item["idUser"]) {
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child:
                            item["type"] == "texto"
                              ? Text(item["message"],style: TextStyle(fontSize: 18),)
                              : Image.network(item["urlImage"]),
                          ),
                        ),
                      );
                    }),
              );
            }
            break;
        }
      },
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
                image: AssetImage("images/bg.png"), fit: BoxFit.cover)),
        child: SafeArea(
            child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              stream,
              messageBox,
            ],
          ),
        )),
      ),
    );
  }
}
