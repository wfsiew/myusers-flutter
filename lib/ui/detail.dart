
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:myusers_flutter/services/user.service.dart';
import 'package:myusers_flutter/models/user.dart';
import 'package:myusers_flutter/helpers.dart';

class Detail extends StatefulWidget {
  Detail({Key key, this.title}) : super(key: key);

  static const String routeName = '/Detail';

  final String title;

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {

  @override
  void initState() {
    super.initState();
  }

  Future<User> load(int id) async {
    User o;
    try {
      o = await getUser(id);
    }

    catch (error) {
      handleError(context, error, () {
        load(id);
      });
    }

    return o;
  }

  void onDeleteUser(int id) async {
    bool b = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(''),
          content: Text('Are you sure you want to delete this user?'),
          actions: <Widget>[
            FlatButton(
              child: Text('NO'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text('YES'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      }
    ) ?? false;
    
    if (b) {
      await deleteUser(id);
      Navigator.pop(context, true);
    }
  }

  Widget buildContent(BuildContext context, AsyncSnapshot snapshot) {
    User o = snapshot.data;

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Image.network(o.avatar),
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '${o.email}',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                  child: Text(
                    '${o.firstName} ${o.lastName}',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    int id = ModalRoute.of(context).settings.arguments;
    var f = new FutureBuilder(
      future: load(id),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());

          default:
            return buildContent(context, snapshot);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: f,
      persistentFooterButtons: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 2.0, right: 2.0),
                  child: RaisedButton(
                    elevation: 5,
                    color: Colors.blue,
                    child: Text('Edit'),
                    onPressed: () {

                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 2.0, right: 2.0),
                  child: RaisedButton(
                    elevation: 5,
                    color: Colors.blue,
                    child: Text('Delete'),
                    onPressed: () {
                      onDeleteUser(id);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        
      ],
    );
  }
}