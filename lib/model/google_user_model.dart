class GoogleUser {
  String? displayName;
  String? email;
  String? photoURL;

  //constructor
  GoogleUser({this.displayName, this.email, this.photoURL});

  // we need to create map
  GoogleUser.fromJson(Map<String, dynamic> json) {
    displayName = json["displayName"];
    photoURL = json["photoUrl"];
    email = json["email"];
  }
  Map<String, dynamic> toJson() {
    // object - data
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['displayName'] = displayName;
    data['email'] = email;
    data['photoUrl]'] = photoURL;

    return data;
  }
}
