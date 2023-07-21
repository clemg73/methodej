import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:methodej/screens/Profil/PolitiquePage.dart';

import '../../common/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Calendar/CalendarPage.dart';
import '../../common/globals.dart' as globals;
import 'package:http/http.dart' as http;

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}

class Profil extends StatelessWidget {
  Profil();

  Widget build(BuildContext context) {
    Route _calendarRoute() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => Calendar(
          page: 0,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, -1.0);
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

    Future<String> getUserMail() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('compteMail').toString();
    }

    Future<int> getUserCountNumbersCoursesMonth() async {
      Uri url = Uri.parse(urlDB +
          "api/courses/countByMonth/user/" +
          (globals.idUser as int).toString());

      final response = await http.get(url);
      print("reponse getUserCountNumbersCoursesMonth: " + response.body);
      if (int.parse(response.body) != -1) {
        return (int.parse(response.body) *
                100 /
                globals.nbCoursesMaxFreeAccount)
            .round();
      } else {
        print("premium");
        return -1;
      }
    }

    Future<bool> deleteAllUserData() async {
      Uri url = Uri.parse(
          urlDB + "api/User/allUserStuff/" + globals.idUser.toString());
      print(url);
      final reponse = await http.delete(url);
      print(reponse.body);
      globals.dataChange = true;
      globals.countChange = true;

      return reponse.body != null;
    }

    Future<bool> deleteUser() async {
      Uri url = Uri.parse(urlDB + "api/User/" + globals.idUser.toString());
      print(url);
      final reponse = await http.delete(url);
      print(reponse.body);

      globals.dataChange = true;
      globals.schemasChange = true;
      globals.countChange = true;
      globals.lastPage_countController = 2;
      globals.lastPage_oneCountController = null;
      globals.lastPage_coursesController = null;
      var prefs = await SharedPreferences.getInstance();
      await prefs.remove('compteID');
      Navigator.pushNamed(
        context,
        '/welcome',
      );

      return reponse.body != null;
    }

    Widget _buildPopupDialogDelete(BuildContext context, bool? result) {
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
                            "Supprétion effectué",
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

    Widget _popupDialogVerifyDeleteAllStuff(BuildContext context) {
      return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
          child: Container(
              padding: const EdgeInsets.only(
                  right: 6.0, left: 6.0, top: 30, bottom: 12),
              width: 400,
              height: 180,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Supprimer vos données ?",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Cela aura pour effet de supprimer tous vos cours, vos révisions et tous vos schémas",
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
                              style: TextStyle(
                                  color: Color.fromRGBO(18, 0, 40, 1)),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Color.fromARGB(255, 236, 236, 236)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
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
                                      _buildPopupDialogDelete(context, null),
                                );
                                bool result = await deleteAllUserData();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialogDelete(context, result),
                                );
                                globals.dataChange = true;
                                globals.schemasChange = true;
                                globals.countChange = true;
                                globals.lastPage_countController = 2;
                                globals.lastPage_oneCountController = null;
                                globals.lastPage_coursesController = null;
                                await Future.delayed(Duration(seconds: 1));

                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Supprimer',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
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
              )));
    }

    Widget _popupDialogVerifyDelete(BuildContext context) {
      return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
          child: Container(
              padding: const EdgeInsets.only(
                  right: 6.0, left: 6.0, top: 30, bottom: 12),
              width: 400,
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Supprimer votre compte ?",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Cela aura pour effet de supprimer définitivement votre compte et toutes ses données",
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
                              style: TextStyle(
                                  color: Color.fromRGBO(18, 0, 40, 1)),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Color.fromARGB(255, 236, 236, 236)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
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
                                      _buildPopupDialogDelete(context, null),
                                );
                                bool result = await deleteUser();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialogDelete(context, result),
                                );
                                globals.dataChange = true;
                                globals.schemasChange = true;
                                globals.countChange = true;
                                globals.lastPage_countController = 2;
                                globals.lastPage_oneCountController = null;
                                globals.lastPage_coursesController = null;
                                await Future.delayed(Duration(seconds: 1));
                              },
                              child: Text(
                                'Supprimer',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
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
              )));
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 244, 255, 1),
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 70,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(_calendarRoute());
                              },
                              child: Icon(Icons.close),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Text(
                                'Réglages',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 32,
                                    color: Colors.black),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.95,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(9),
                                              color: Colors.white),
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: FutureBuilder<int>(
                                                  future:
                                                      getUserCountNumbersCoursesMonth(),
                                                  builder: (context, snapshot) {
                                                    return snapshot.hasData
                                                        ? Row(
                                                            mainAxisAlignment: snapshot
                                                                        .data
                                                                        .toString() !=
                                                                    "-1"
                                                                ? MainAxisAlignment
                                                                    .spaceBetween
                                                                : MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        "Compte",
                                                                        style: TextStyle(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                198,
                                                                                198,
                                                                                198),
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize: 10),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      FutureBuilder<
                                                                              String>(
                                                                          future:
                                                                              getUserMail(),
                                                                          builder:
                                                                              (context, snapshot) {
                                                                            return snapshot.hasData
                                                                                ? Text(
                                                                                    snapshot.data.toString(),
                                                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15),
                                                                                  )
                                                                                : Text("");
                                                                          }),
                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Row(
                                                                          children: [
                                                                            GradientText(
                                                                              snapshot.data.toString() != "-1" ? snapshot.data.toString() + "%" : "Premium",
                                                                              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                                                                              gradient: LinearGradient(colors: [
                                                                                Color.fromRGBO(146, 39, 249, 1),
                                                                                Color.fromRGBO(99, 59, 243, 1)
                                                                              ]),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            snapshot.data.toString() != "-1"
                                                                                ? Column(
                                                                                    children: [
                                                                                      Text("Compte gratuit", style: TextStyle(color: Color.fromARGB(255, 198, 198, 198), fontWeight: FontWeight.w600, fontSize: 10)),
                                                                                      Text(globals.nbCoursesMaxFreeAccount.toString() + " cours / mois", style: TextStyle(color: Color.fromARGB(255, 198, 198, 198), fontWeight: FontWeight.w600, fontSize: 10))
                                                                                    ],
                                                                                  )
                                                                                : Text("")
                                                                          ])
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              snapshot.data
                                                                          .toString() !=
                                                                      "-1"
                                                                  ? TextButton(
                                                                      onPressed:
                                                                          () async {
                                                                        Navigator
                                                                            .pushNamed(
                                                                          context,
                                                                          '/premium',
                                                                        );
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            70,
                                                                        height:
                                                                            70,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(12),
                                                                          gradient: LinearGradient(
                                                                              begin: Alignment.centerRight,
                                                                              end: Alignment.centerLeft,
                                                                              colors: [
                                                                                Color.fromRGBO(146, 39, 249, 1),
                                                                                Color.fromRGBO(99, 59, 243, 1)
                                                                              ]),
                                                                        ),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .arrow_forward,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ))
                                                                  : Text(""),
                                                            ],
                                                          )
                                                        : CupertinoActivityIndicator(
                                                            color: Colors.black,
                                                          );
                                                  }))
                                          /*Stack(
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      height: 13,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(9),
                                                          color: Color.fromRGBO(
                                                              242,
                                                              244,
                                                              255,
                                                              1)),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.6,
                                                      height: 13,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(9),
                                                        gradient: LinearGradient(
                                                            begin: Alignment
                                                                .centerRight,
                                                            end: Alignment
                                                                .centerLeft,
                                                            colors: [
                                                              Color.fromRGBO(
                                                                  146,
                                                                  39,
                                                                  249,
                                                                  1),
                                                              Color.fromRGBO(99,
                                                                  59, 243, 1)
                                                            ]),
                                                      ),
                                                    )
                                                  ],
                                                )*/

                                          ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: TextButton(
                                            onPressed: () => {
                                              Navigator.pushNamed(
                                                context,
                                                '/politique',
                                              )
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 30, right: 30),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    child: Text(
                                                      "Politique de protection \ndes données personnelles",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: ShaderMask(
                                                      blendMode:
                                                          BlendMode.srcIn,
                                                      shaderCallback:
                                                          (Rect bounds) =>
                                                              RadialGradient(
                                                        center:
                                                            Alignment.topCenter,
                                                        colors: [
                                                          Color.fromRGBO(146,
                                                              39, 249, 0.9),
                                                          Color.fromRGBO(
                                                              99, 59, 243, 0.9)
                                                        ],
                                                      ).createShader(bounds),
                                                      child: Icon(
                                                        Icons.description,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll<
                                                            Color>(
                                                        Color.fromARGB(255, 255,
                                                            255, 255)),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ))),
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: TextButton(
                                            onPressed: () => {
                                              Navigator.pushNamed(
                                                context,
                                                '/passwordChange',
                                              )
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 30, right: 30),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    child: Text(
                                                      "Modifier mon mot de passe",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: ShaderMask(
                                                      blendMode:
                                                          BlendMode.srcIn,
                                                      shaderCallback:
                                                          (Rect bounds) =>
                                                              RadialGradient(
                                                        center:
                                                            Alignment.topCenter,
                                                        colors: [
                                                          Color.fromRGBO(146,
                                                              39, 249, 0.9),
                                                          Color.fromRGBO(
                                                              99, 59, 243, 0.9)
                                                        ],
                                                      ).createShader(bounds),
                                                      child: Icon(
                                                        Icons.password,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll<
                                                            Color>(
                                                        Color.fromARGB(255, 255,
                                                            255, 255)),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ))),
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: TextButton(
                                            onPressed: () => {
                                              Navigator.pushNamed(
                                                context,
                                                '/emailChange',
                                              )
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 30, right: 30),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    child: Text(
                                                      "Modifier mon adresse email",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: ShaderMask(
                                                      blendMode:
                                                          BlendMode.srcIn,
                                                      shaderCallback:
                                                          (Rect bounds) =>
                                                              RadialGradient(
                                                        center:
                                                            Alignment.topCenter,
                                                        colors: [
                                                          Color.fromRGBO(146,
                                                              39, 249, 0.9),
                                                          Color.fromRGBO(
                                                              99, 59, 243, 0.9)
                                                        ],
                                                      ).createShader(bounds),
                                                      child: Icon(
                                                        Icons.email,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll<
                                                            Color>(
                                                        Color.fromARGB(255, 255,
                                                            255, 255)),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ))),
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          TextButton(
                                            onPressed: () => {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext
                                                        context) =>
                                                    _popupDialogVerifyDeleteAllStuff(
                                                        context),
                                              )
                                            },
                                            child: Text(
                                              "Supprimer mes données",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 0, 0),
                                                  fontSize: 12),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () => {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext
                                                        context) =>
                                                    _popupDialogVerifyDelete(
                                                        context),
                                              )
                                            },
                                            child: Text(
                                              "Supprimer mon compte",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 0, 0),
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () async {
                        globals.dataChange = true;
                        globals.schemasChange = true;
                        globals.countChange = true;
                        globals.lastPage_countController = 2;
                        globals.lastPage_oneCountController = null;
                        globals.lastPage_coursesController = null;
                        var prefs = await SharedPreferences.getInstance();
                        await prefs.remove('compteID');
                        await prefs.remove('compteMail');
                        Navigator.pushNamed(
                          context,
                          '/welcome',
                        );
                      },
                      child: Text(
                        "Déconnexion",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              Color.fromRGBO(18, 0, 40, 1)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ))),
                    ),
                  ),
                  SizedBox(
                    height: 40,
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
