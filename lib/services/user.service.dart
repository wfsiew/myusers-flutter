import 'package:dio/dio.dart';
import 'dart:async';
import 'package:myusers_flutter/models/user.dart';
import 'package:myusers_flutter/constants.dart';

final String url = '${Constants.USERS_URL}';
final Dio dio = Dio(BaseOptions(connectTimeout: 5000, receiveTimeout: 15000));

Future<UserListResponse> getUsers([int page = 1]) async {
  UserListResponse o;

  try {
    var res = await dio.get(url, queryParameters: { 'page': page, 'per_page': 50 });
    o = UserListResponse.fromJson(res.data);
  }

  catch (error) {
    throw(error);
  }

  return o;
}

Future<User> getUser(int id) async {
  User o;

  try {
    var res = await dio.get('$url/$id');
    var data = res.data;
    o = User.fromJson(data['data']);
  }

  catch (error) {
    throw(error);
  }

  return o;
}

Future<void> deleteUser(int id) async {
  try {
    await dio.delete('$url/$id');
  }

  catch (error) {
    throw(error);
  }
}