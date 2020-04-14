import 'pageinfo.dart';

class User {
  int id;
  String email;
  String firstName;
  String lastName;
  String avatar;

  User({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.avatar
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatar: json['avatar']
    );
  }
}

class UserListResponse {
  PageInfo pageInfo;
  List<User> userList;

  UserListResponse({
    this.pageInfo,
    this.userList
  });

  factory UserListResponse.fromJson(Map<String, dynamic> json) {
    var ls = json['data'] as List;
    List<User> lx = ls.map<User>((x) => User.fromJson(x)).toList();
    return UserListResponse(
      pageInfo: PageInfo.fromJson(json),
      userList: lx
    );
  }
}