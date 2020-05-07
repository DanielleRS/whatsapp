import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Home.dart';

void main(){

  WidgetsFlutterBinding.ensureInitialized();

  Firestore.instance
  .collection("usuarios")
  .document("001")
  .setData({"nome": "Jamilton"});

  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}
