class Usuario {
  String _name;
  String _email;
  String _pass;

  Usuario();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "name": this.name,
      "email": this.email
    };
    return map;
  }

  String get pass => _pass;

  set pass(String value) {
    _pass = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

}