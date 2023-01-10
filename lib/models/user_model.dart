class UserModel {
  String? uid;
  String? email;
  String? password;
  String? name;
  String? goal;
  String? photoURL;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.password,
    this.goal,
    this.photoURL,
  });

  // UserModel.fromJson(Map<String, dynamic> json) {
  //   id = json['id'];
  //   name = json['name'];
  //   email = json['email'];
  //   password = json['password'];
  //   goal = json['goal'];
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'email': email,
  //     'password': password,
  //     'name': name,
  //     'goal': goal,
  //   };
  // }
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      goal: map['goal'],
      name: map['name'],
      password: map['password'],
    );
  }

  //get photoUrl => null;
//sending to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullname': name,
    };
  }
}
