import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  String _idSender;
  String _idRecipient;
  String _name;
  String _message;
  String _photo;
  String _typeMessage;

  Conversation();

  save() async {
    Firestore db = Firestore.instance;
    await db.collection("conversations")
            .document(this.idSender)
            .collection("last_conversation")
            .document(this.idRecipient)
            .setData(this.toMap());
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "idSender": this.idSender,
      "idRecipient": this.idRecipient,
      "name": this.name,
      "message": this.message,
      "photo": this.photo,
      "typeMessage": this.typeMessage,
    };
    return map;
  }

  String get idSender => _idSender;

  set idSender(String value) {
    _idSender = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get message => _message;

  String get photo => _photo;

  set photo(String value) {
    _photo = value;
  }

  set message(String value) {
    _message = value;
  }

  String get idRecipient => _idRecipient;

  String get typeMessage => _typeMessage;

  set typeMessage(String value) {
    _typeMessage = value;
  }

  set idRecipient(String value) {
    _idRecipient = value;
  }

}