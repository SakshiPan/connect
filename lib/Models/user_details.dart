class UserDetails {
  late String? uid;
  late String? email;
  late String? username;
  late String? profilePhoto;

  UserDetails({
    required this.uid,
    required this.email,
    required this.username,
    required this.profilePhoto,
  });

  Map<String, dynamic> toMap(UserDetails user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['email'] = user.email;
    data['username'] = user.username;
    data['profilePhoto'] = user.profilePhoto;
    return data;
  }

  UserDetails.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.email = mapData['email'];
    this.username = mapData['username'];
    this.profilePhoto = mapData['profilePhoto'];
  }
}
