class Message {
  User currentUser;
  List messages;

  Message(this.currentUser, this.messages);

  Map<String, dynamic> toJson() {
    return {
      'currentUser': currentUser.toJson(),
      'messages': messages,
    };
  }
}

class User {
  String name;
  String email;

  User(this.name, this.email);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
    };
  }
}
