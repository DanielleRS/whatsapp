import 'package:flutter/material.dart';
import 'package:whatsapp/model/Conversation.dart';
import 'package:whatsapp/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContactsTab extends StatefulWidget {
  @override
  _ContactsTabState createState() => _ContactsTabState();
}

class _ContactsTabState extends State<ContactsTab> {

  String _idLoggedUser;
  String _emailLoggedUser;

  Future<List<Usuario>> _recoverContacts() async {
    Firestore db = Firestore.instance;
    QuerySnapshot querySnapshot =
        await db.collection("usuarios").getDocuments();
    List<Usuario> listUsers = List();
    for (DocumentSnapshot item in querySnapshot.documents) {
      var data = item.data;
      if(data["email"] == _emailLoggedUser) continue;

      Usuario user = Usuario();
      user.idUser = item.documentID;
      user.email = data["email"];
      user.name = data["name"];
      user.urlImage = data["urlImage"];

      listUsers.add(user);
    }
    return listUsers;
  }

  _recoverUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser loggedUser = await auth.currentUser();
    _idLoggedUser = loggedUser.uid;
    _emailLoggedUser = loggedUser.email;
  }

  @override
  void initState() {
    super.initState();
    _recoverUserData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Usuario>>(
      future: _recoverContacts(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: <Widget>[
                  Text("Carregando contatos"),
                  CircularProgressIndicator()
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  List<Usuario> listItems = snapshot.data;
                  Usuario user = listItems[index];
                  return ListTile(
                    onTap: (){
                      Navigator.pushNamed(
                          context,
                          "/messages",
                        arguments: user
                      );
                    },
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    leading: CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: Colors.grey,
                        backgroundImage: user.urlImage != null
                            ? NetworkImage(user.urlImage)
                            : null),
                    title: Text(
                      user.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  );
                });
            break;
        }
      },
    );
  }
}
