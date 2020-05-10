import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Configurations extends StatefulWidget {
  @override
  _ConfigurationsState createState() => _ConfigurationsState();
}

class _ConfigurationsState extends State<Configurations> {

  TextEditingController _controllerName = TextEditingController();
  File _image;

  Future _recoverImage(String sourceImage) async {
    File selectedImage ;
    switch(sourceImage){
      case "camera":
        selectedImage = await ImagePicker.pickImage(source: ImageSource.camera);
        break;
      case "galeria":
        selectedImage = await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      _image = selectedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Configurações"),),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage("https://firebasestorage.googleapis.com/v0/b/whatsapp-97983.appspot.com/o/profiles%2Fperfil5.jpg?alt=media&token=a08096ce-d56c-4fbe-8509-cca4c7922ffb"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Text("Câmera"),
                      onPressed: (){
                        _recoverImage("camera");
                      },
                    ),
                    FlatButton(
                      child: Text("Galeria"),
                      onPressed: (){
                        _recoverImage("galeria");
                      },
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerName,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Nome",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                      child: Text(
                        "Salvar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Colors.green,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)
                      ),
                      onPressed: () {

                      }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
