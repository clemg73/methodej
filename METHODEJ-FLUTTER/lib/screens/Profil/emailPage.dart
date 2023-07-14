import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:methodej/models/user.dart';

import '../../common/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/loading.dart';
import '../Calendar/CalendarPage.dart';
import '../../common/globals.dart' as globals;

class MailChange extends StatefulWidget {
  MailChange();

  @override
  State<MailChange> createState() => _MailChangeState();
}

class _MailChangeState extends State<MailChange> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    Future<bool> updateUser({required User user}) async {
      try {
        Response response = await Dio().put(
          urlDB + "api/user/" + globals.idUser.toString(),
          data: user.toJson(),
        );

        print('user updated ${response.data}');
        globals.dataChange = true;
        globals.countChange = true;

        return true;
      } catch (e) {
        print('Error updating user: $e');
        return false;
      }
    }

    bool isValidEmail(String value) {
      return RegExp(
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(value);
    }

    Widget _buildPopupDialogUpdate(BuildContext context, bool? result) {
      return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(26.0)),
          child: Container(
            padding: const EdgeInsets.only(
                right: 12.0, left: 12.0, top: 40, bottom: 12),
            width: 300,
            height: 300,
            child: result == null
                ? Center(
                    child: Container(
                        child: /*Image(
                      image: AssetImage("images/334-loader-5.webp"),
                    ),*/
                            Loading(
                    size: 100,
                  )))
                : result
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Image(
                              image: AssetImage(
                                  "images/37-approve-checked-simple-outline.webp"),
                            ),
                            width: MediaQuery.of(context).size.width * 0.2,
                          ),
                          Text(
                            "Email mis à jour",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.black),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Erreur",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.black),
                          ),
                          Container(
                            width: 200,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "OK",
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          Color.fromRGBO(151, 71, 255, 1)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ))),
                            ),
                          ),
                        ],
                      ),
          ));
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 244, 255, 1),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 70,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Modifier mon \nadreese email',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 30,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: TextFormField(
                                    autofocus: true,
                                    controller: emailController,
                                    decoration: InputDecoration(
                                        hintText: 'Email',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            borderSide: BorderSide.none),
                                        filled: true,
                                        fillColor: Colors.white),
                                    validator: (value) =>
                                        isValidEmail(value as String)
                                            ? null
                                            : "Email invalide",
                                  ),
                                ),
                                SizedBox(height: 30),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  height: 60,
                                  child: TextButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              _buildPopupDialogUpdate(
                                                  context, null),
                                        );
                                        bool result = await updateUser(
                                            user: User(
                                                name:
                                                    emailController.value.text,
                                                mdp: ""));
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              _buildPopupDialogUpdate(
                                                  context, result),
                                        );

                                        await Future.delayed(
                                            Duration(seconds: 1));

                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text(
                                      "Modifier",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll<Color>(
                                                Color.fromRGBO(18, 0, 40, 1)),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ))),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
