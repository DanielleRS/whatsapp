import 'package:flutter/material.dart';

import 'Cadastro.dart';
import 'Configurations.dart';
import 'Home.dart';
import 'Login.dart';
import 'Messages.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch(settings.name){
      case "/":
        return MaterialPageRoute(
          builder: (_) => Login()
        );
      case "/login":
        return MaterialPageRoute(
            builder: (_) => Login()
        );
      case "/cadastro":
        return MaterialPageRoute(
            builder: (_) => Cadastro()
        );
      case "/home":
        return MaterialPageRoute(
            builder: (_) => Home()
        );
      case "/configurations":
        return MaterialPageRoute(
            builder: (_) => Configurations()
        );
      case "/messages":
        return MaterialPageRoute(
            builder: (_) => Messages(args)
        );
      default:
        _routeError();
    }
  }

  static Route<dynamic> _routeError(){
    return MaterialPageRoute(
      builder: (_){
        return Scaffold(
          appBar: AppBar(title: Text("Tela não encontrada!"),),
          body: Center(
            child: Text("Tela não encontrada!"),
          ),
        );
      }
    );
  }
}