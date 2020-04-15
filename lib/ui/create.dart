import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:myusers_flutter/shared/widget/input-field.dart';
import 'package:myusers_flutter/services/user.service.dart';
import 'package:myusers_flutter/validator/general.dart';
import 'package:myusers_flutter/helpers.dart';

class Create extends StatefulWidget {
  Create({Key key, this.title}) : super(key: key);

  static const String routeName = '/Create';

  final String title;

  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {

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

  void showRetry(DioError error) {
    handleError(context, error, () async {
      await onSubmit();
    });
  }

  Future<void> onSubmit() async {
    var valid = formKey.currentState.validate();
    if (!valid) {
      return;
    }

    try {
      var o = {
        name: name,
        job: job
      };
      await createUser(o);
      Navigator.pop(context, true);
    }

    catch (error) {
      showRetry(error);
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
            child: Text('Create'),
            onPressed: !isValid ? null : () async {
              await onSubmit();
            },
          ),
        )
      ],
    );
  }
}