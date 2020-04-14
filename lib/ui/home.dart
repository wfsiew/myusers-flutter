import 'package:flutter/material.dart';
import 'dart:async';
import 'package:myusers_flutter/services/user.service.dart';
import 'package:myusers_flutter/models/userlist.dart';
import 'package:myusers_flutter/helpers.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  static const String routeName = '/Home';

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int currIndex = 0;
  ScrollController scr = ScrollController();
  List<UserList> ls = <UserList>[];
  int page = 1;
  bool isLoading = false;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    load();
    scr.addListener(() {
      if (scr.position.pixels == scr.position.maxScrollExtent) {
        loadMore();
      }
    });
  }

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }

  void load() async {
    try {
      setState(() {
        isLoading = true;
      });
      var o = await getUsers();
      setState(() {
        page = 1;
        ls = o.userList;
        isLoading = false;
      });
    }

    catch(error) {
      setState(() {
       isLoading = false;
       handleError(context, error, load);
      });
    }
  }

  void loadMore() async {
    int p = page + 1;
    try {
      var o = await getUsers(page = p);
      if (o.userList.length < 1) {
        return;
      }

      setState(() {
        page = p;
        ls.addAll(o.userList);
      });
    }

    catch(error) {
      handleError(context, error, loadMore);
    }
  }

  Future<void> refreshData() async {
    try {
      var o = await getUsers();
      ls.clear();
      setState(() {
        page = 1;
        ls = o.userList;
      });
    }

    catch(error) {
      handleError(context, error, () async {
        await refreshData();
      });
    }
  }

  Widget buildRow(UserList o) {
    return Card(
      child: ListTile(
        title: Text(
          '${o.email}',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.black
          )
        ),
        subtitle: Text('${o.firstName} ${o.lastName}'),
        leading: Image.network(o.avatar),
        trailing: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            child: Text('${o.id}')
          ),
        ),
      )
    );
  }

  Widget buildList() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      child: ListView.builder(
        padding: const EdgeInsets.all(2.0),
        controller: scr,
        itemCount: ls.length,
        itemBuilder: (context, i) {
          UserList o = ls[i];
          return buildRow(o);
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[],
      ),
      body: RefreshIndicator(
        key: refreshIndicatorKey,
        onRefresh: refreshData,
        child: buildList(),
      ),
    );
  }
}