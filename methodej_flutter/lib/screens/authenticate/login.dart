import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:methodej/screens/authenticate/welcomPage.dart';
import '../../common/constants.dart';
import '../../common/loading.dart';
import '../../models/user.dart';
import '../../common/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool emptyMailForSendMail = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<String> connectionUser({required User userInfo}) async {
      try {
        Response response = await Dio().post(
          urlDB + "api/user/connection",
          data: userInfo.toJson(),
        );

        print('User connected: ${response.data}');

        return response.data;
      } catch (e) {
        print('Error connection user: $e');
        return '{"id": 0,"userid": 0, "token": ""}';
      }
    }

    Future<bool> sendEmail(String email) async {
      try {
        Response response = await Dio().post(
          urlDB + "api/user/restorepassword/" + email,
        );

        print('email send: ${response.data}');

        return true;

        //retrievedCourse = Course.fromJson(response.data);
      } catch (e) {
        print('Error email send: $e');
        return false;
      }
    }

    Route _returnRoute() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => Welcome(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    }

    Widget _buildPopupDialogMailSend(BuildContext context, bool? result) {
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
                    child: Image(
                      image: AssetImage("images/334-loader-5.webp"),
                    ),
                    width: MediaQuery.of(context).size.width * 0.2,
                  ))
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
                            "Email envoyé",
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

    Widget _popupDialogVerifyDelete(BuildContext context, String email) {
      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
        child: Container(
          padding:
              const EdgeInsets.only(right: 6.0, left: 6.0, top: 30, bottom: 12),
          width: 400,
          height: 180,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Envoyer un email de récupération de mot de passe à: ",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                email,
                style: TextStyle(
                    color: Color.fromRGBO(150, 150, 150, 1),
                    fontWeight: FontWeight.w300),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 130,
                      height: 50,
                      child: TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Annuler',
                          style: TextStyle(color: Color.fromRGBO(18, 0, 40, 1)),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Color.fromARGB(255, 236, 236, 236)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ))),
                      ),
                    ),
                    Container(
                      width: 130,
                      height: 50,
                      child: TextButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildPopupDialogMailSend(context, null),
                            );
                            bool result = await sendEmail(email);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildPopupDialogMailSend(context, result),
                            );

                            await Future.delayed(Duration(seconds: 1));

                            Navigator.pop(context);
                            Navigator.pop(context);
                            //Navigator.pop(context);
                          },
                          child: Text(
                            'Envoyer',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  Color.fromRGBO(18, 0, 40, 1)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )))),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      );
    }

    return loading
        ? Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Color.fromARGB(255, 243, 243, 243),
            body: Center(
                child: Loading(
              size: 100,
            )))
        : Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Color.fromARGB(255, 243, 243, 243),
            body: Container(
                height: MediaQuery.of(context).size.height,
                /*decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Color.fromRGBO(146, 39, 249, 1),
                      Color.fromRGBO(99, 59, 243, 1)
                    ])),*/
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 55,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 15, right: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: () => Navigator.of(context)
                                        .push(_returnRoute()),
                                    icon: Icon(Icons.arrow_back)),
                                Text(
                                  'Connexion',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextFormField(
                              autofocus: true,
                              controller: emailController,
                              decoration: InputDecoration(
                                  hintText: 'Email',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide.none),
                                  filled: true,
                                  fillColor: Colors.white),
                              validator: (value) =>
                                  value!.isEmpty ? "Enter an email" : null,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          emptyMailForSendMail
                              ? Text(
                                  "Veuillez renseigner un email",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 10),
                                )
                              : Container(),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextFormField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                  hintText: 'Mot de passe',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide.none),
                                  filled: true,
                                  fillColor: Colors.white),
                              obscureText: true,
                              validator: (value) => value!.length < 6
                                  ? "Entrez un mot de passe avec plus de 4 characteres"
                                  : null,
                            ),
                          ),
                          SizedBox(height: 5),
                          TextButton(
                              onPressed: () => {
                                    if (emailController.value.text != "")
                                      {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              _popupDialogVerifyDelete(context,
                                                  emailController.value.text),
                                        )
                                      }
                                    else
                                      {
                                        setState(() {
                                          emptyMailForSendMail = true;
                                        })
                                      }
                                  },
                              child: Text("Mot de passe oublié ?",
                                  style: TextStyle(color: Colors.black))),
                          SizedBox(height: 30),
                          SizedBox(height: 5),
                          Text(
                            error,
                            style: TextStyle(color: Colors.red),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => loading = true);
                                  loading = true;
                                  var password = passwordController.value.text;
                                  var email = emailController.value.text;
                                  String result = await connectionUser(
                                      userInfo: new User(
                                          id: null,
                                          name: email,
                                          mdp: password,
                                          premium: false));
                                  var obj = json.decode(result);
                                  print(obj);
                                  if (obj['id'] == 0) {
                                    setState(() {
                                      loading = false;
                                      error = "Email ou mot de passe incorect";
                                    });
                                  } else {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    //ID
                                    globals.idUser = obj['id'];
                                    await prefs.setInt(
                                        'compteID', obj['id'] as int);
                                    print("compte id:" +
                                        prefs.getInt('compteID').toString());

                                    //MAIL
                                    globals.mailUser = obj['name'].toString();
                                    await prefs.setString(
                                        'compteMail', obj['name'].toString());
                                    print("compte mail:" +
                                        prefs
                                            .getString('compteMail')
                                            .toString());

                                    Navigator.pushNamed(
                                      context,
                                      '/calendar0',
                                    );
                                  }
                                }
                              },
                              child: Text(
                                "Se connecter",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          Color.fromRGBO(18, 0, 40, 1)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ))),
                            ),
                          ),
                          TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/register'),
                              child: Text(
                                "Pas encore de compte ? S'inscrire",
                                style: TextStyle(color: Colors.black),
                              )),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      )
                    ],
                  ),
                )),
          );
  }
}
