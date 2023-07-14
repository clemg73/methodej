import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../common/constants.dart';
import '../../common/loading.dart';
import '../../models/user.dart';
import '../../common/globals.dart' as globals;
import '../Profil/PolitiquePage.dart';
import 'welcomPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isChecked = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<User> createUser({required User userInfo}) async {
      try {
        Response response = await Dio().post(
          urlDB + "api/user",
          data: userInfo.toJson(),
        );

        print('User created: ${response.data}');
        return User(
            id: response.data['id'],
            name: response.data['name'],
            mdp: response.data['mdp']);
      } catch (e) {
        print('Error creating user: $e');
        return User(id: 0, name: "", mdp: "");
      }
    }

    bool isValidEmail(String value) {
      return RegExp(
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(value);
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
              /* decoration: const BoxDecoration(
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
                                "S'inscrire",
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
                            validator: (value) => isValidEmail(value as String)
                                ? null
                                : "Email invalide",
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                hintText: 'Mot de passe',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Colors.white),
                            validator: (value) => value!.length < 10
                                ? "Entrez un mot de passe avec au moins 10 characteres"
                                : null,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red),
                        ),
                        SizedBox(height: 10),
                        TextButton(
                            onPressed: () => {
                                  Navigator.pushNamed(
                                    context,
                                    '/politique',
                                  )
                                },
                            child: Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              height: 60,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Politique de protection des données personnelles",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.black,
                                  )
                                ],
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white),
                            )),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Row(
                                children: [
                                  Checkbox(
                                    fillColor: MaterialStatePropertyAll<Color>(
                                        Color.fromRGBO(18, 0, 40, 1)),
                                    value: isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isChecked = value!;
                                      });
                                    },
                                  ),
                                  Flexible(
                                    child: Text(
                                      "J'accepte la Politique de protection des données personnelles",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 60,
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  isChecked) {
                                setState(() => loading = true);
                                loading = true;
                                var password = passwordController.value.text;
                                var email = emailController.value.text;
                                User result = await createUser(
                                    userInfo: new User(
                                        id: null, name: email, mdp: password));

                                if (result.id == 0) {
                                  setState(() {
                                    loading = false;
                                    error = "Email déjà utilisé";
                                  });
                                } else {
                                  globals.idUser = result.id;
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setInt(
                                      'compteID', result.id as int);
                                  print(prefs.getInt('compteID'));

                                  //MAIL
                                  globals.mailUser = result.name.toString();
                                  await prefs.setString(
                                      'compteMail', result.name.toString());
                                  print("compte mail:" +
                                      prefs.getString('compteMail').toString());

                                  Navigator.pushNamed(
                                    context,
                                    '/calendar0',
                                  );
                                }
                              }
                            },
                            child: Text(
                              "S'inscrire",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                                backgroundColor: isChecked
                                    ? MaterialStatePropertyAll<Color>(
                                        Color.fromRGBO(18, 0, 40, 1))
                                    : MaterialStatePropertyAll<Color>(
                                        Color.fromARGB(86, 18, 0, 40)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ))),
                          ),
                        ),
                        TextButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/login'),
                            child: Text(
                              "Déjà un compte ? Se connecter",
                              style: TextStyle(color: Colors.black),
                            )),
                        SizedBox(
                          height: 30,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
