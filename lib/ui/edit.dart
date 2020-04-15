import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:myusers_flutter/shared/widget/input-field.dart';
import 'package:myusers_flutter/services/user.service.dart';
import 'package:myusers_flutter/validator/general.dart';
import 'package:myusers_flutter/helpers.dart';

class Edit extends StatefulWidget {
  Edit({Key key, this.title}) : super(key: key);

  static const String routeName = '/Edit';

  final String title;

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {

  String name;
  String job;
  bool isValid = false;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
     isValid = formKey.currentState?.validate() ?? false;
    });
  }

  void showRetry(DioError error, int id) {
    handleError(context, error, () async {
      await onSubmit(id);
    });
  }

  Future<void> onSubmit(int id) async {
    var valid = formKey.currentState.validate();
    if (!valid) {
      return;
    }

    try {
      var o = {
        name: name,
        job: job
      };
      await updateUser(id, o);
      Navigator.pop(context, true);
    }

    catch (error) {
      showRetry(error, id);
    }
  }

  Widget buildContent() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: formKey,
        child: ListView(
          children: <Widget>[
            InputField(
              label: 'Name',
              onChanged: (String s) {
                setState(() {
                 name = s;
                 isValid = formKey.currentState.validate();
                });
              },
              validator: (s) {
                return vRequired(s, 'Name');
              },
            ),
            InputField(
              label: 'Job',
              onChanged: (String s) {
                setState(() {
                 job = s;
                 isValid = formKey.currentState.validate();
                });
              },
              validator: (s) {
                return vRequired(s, 'Job');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int id = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: buildContent(),
      persistentFooterButtons: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: 2.0, right: 2.0),
          child: RaisedButton(
            elevation: 5,
            color: Colors.blue,
            child: Text('Update'),
            onPressed: !isValid ? null : () async {
              await onSubmit(id);
            },
          ),
        )
      ],
    );
  }
} 