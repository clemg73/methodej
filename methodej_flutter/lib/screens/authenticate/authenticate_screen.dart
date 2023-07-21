

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../common/constants.dart';
import '../../common/loading.dart';
import '../../models/user.dart';
import '../../common/globals.dart' as globals;


class AuthentificateScreen extends StatefulWidget {
  @override
  _AuthentificateScreenState createState() => _AuthentificateScreenState();
}

class _AuthentificateScreenState extends State<AuthentificateScreen> {
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool showSignIn = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  void toggleView(){
    setState(() {
      _formKey.currentState!.reset();
      error = '';
      emailController.text = '';
      passwordController.text = '';
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {

    Future<User> createUser({required User userInfo}) async {
      try {
        Response response = await Dio().post(
          urlDB+"api/user",
          data: userInfo.toJson(),
        );

        print('User created: ${response.data}');
        return User(id: response.data['id'], name: response.data['name'], mdp: response.data['mdp']);
      } catch (e) {
        print('Error creating user: $e');
        return User(id: 0, name: "", mdp: "");
      }

    }

    Future<User> connectionUser({required User userInfo}) async {
      try {
        Response response = await Dio().post(
          urlDB+"api/user/connection",
          data: userInfo.toJson(),
        );

        print('User connected: ${response.data}');



        return User(id: response.data['id'], name: response.data['name'], mdp: response.data['mdp']);

      } catch (e) {
        print('Error connection user: $e');
        return User(id: 0, name: "", mdp: "");
      }

    }


    return loading
      ? Container(child: Image.asset("images/334-loader-5.webp"), width: MediaQuery.of(context).size.width * 0.2,)
      : Scaffold(
        backgroundColor: Colors.white,

      body: Container(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(showSignIn ? 'Sign in à l apppppppppppppp' : 'Register à l app', style: TextStyle(color: Colors.black),),
              SizedBox(height: 30,),
              TextFormField(
                controller: emailController,
                decoration: textInputDecoration.copyWith(hintText: 'email'),
                validator: (value)=>value!.isEmpty ? "Enter an email" : null,
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                controller: passwordController,
                decoration: textInputDecoration.copyWith(hintText: 'password'),
                obscureText: true,
                validator: (value)=>value!.length < 6 ? "Entrez un mot de passe avec plus de 4 characteres" : null,
              ),
              SizedBox(height: 10.0,),
              ElevatedButton(
                  onPressed: () async {
                    if(_formKey.currentState!.validate()) {
                      setState(() => loading = true);
                      loading = true;
                      var password = passwordController.value.text;
                      var email = emailController.value.text;
                      User result = showSignIn
                      ? await connectionUser(userInfo: new User(id: null, name: email, mdp: password))
                      : await createUser(userInfo: new User(id: null, name: email, mdp: password));
                      if(result.id == 0)
                          {
                            setState(() {
                              loading = false;
                              error = "Please supply a valid email";
                            });
                          }else{
                        globals.idUser = result.id;
                        Navigator.pushNamed(
                          context,
                          '/calendar0',
                        );
                      }

                    }
                  },
                  child: Text(
                    showSignIn ? "Sign In" : "Register",
                    style: TextStyle(color: Colors.white),
                  )
              ),
              SizedBox(height: 10),
              Text(
                error,
                style: TextStyle(color: Colors.red),
              ),
              TextButton.icon(onPressed: ()=> toggleView(), icon: Icon(Icons.person, color: Colors.black,), label: Text(showSignIn ? 'Register' : 'Log in', style: TextStyle(color: Colors.black),))
            ],
          ),
        ),
      ),
      );
  }
}


