import 'pageinfo.dart';

class UserList {
  int id;
  String email;
  String firstName;
  String lastName;
  String avatar;

  UserList({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.avatar
  });

  factory UserList.fromJson(Map<String, dynamic> json) {
    return UserList(
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
  List<UserList> userList;

  UserListResponse({
    this.pageInfo,
    this.userList
  });

  factory UserListResponse.fromJson(Map<String, dynamic> json) {
    var ls = json['data'] as List;
    List<UserList> lx = ls.map<UserList>((x) => UserList.fromJson(x)).toList();
    return UserListResponse(
      pageInfo: PageInfo.fromJson(json),
      userList: lx
    );
  }
}