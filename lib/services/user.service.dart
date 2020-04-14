import 'package:dio/dio.dart';
import 'dart:async';
import 'package:myusers_flutter/models/userlist.dart';
import 'package:myusers_flutter/constants.dart';

final String url = '${Constants.USERS_URL}';
final Dio dio = Dio(BaseOptions(connectTimeout: 5000, receiveTimeout: 15000));

Future<UserListResponse> getUsers([int page = 1]) async {
  UserListResponse o;

  try {
    var res = await dio.get(url, queryParameters: { 'page': page });
    o = UserListResponse.fromJson(res.data);
  }

  catch (error) {
    throw(error);
  }

  return o;
}