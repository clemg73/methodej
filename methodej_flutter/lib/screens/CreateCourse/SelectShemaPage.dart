import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:methodej/models/CourseArguments.dart';
import '../../common/constants.dart';
import '../../common/loading.dart';
import '../../models/Revision.dart';
import '../../models/course.dart';
import '../../models/shema.dart';
import 'package:http/http.dart' as http;
import '../../common/globals.dart' as globals;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CreateCoursePage.dart';

class SelectShema extends StatefulWidget {
  SelectShema({this.courseArguments});
  final courseArguments;
  @override
  State<SelectShema> createState() =>
      _SelectShemaState(courseArguments: this.courseArguments);
}

class _SelectShemaState extends State<SelectShema> {
  _SelectShemaState({this.courseArguments});
  final courseArguments;

  int year = DateTime.now().year;
  int month = DateTime.now().month;

  PageController _pageController = PageController(initialPage: 1);

  Shema shemaSelectionne = new Shema(id: 9, name: "Schema 1", jours: "1");

  late Future<List<Shema>> lesShemasFuture;
  late List<Shema> lesShemas;

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  initState() {
    shemaSelectionne = this.courseArguments != null
        ? (this.courseArguments as CourseArguments).shema as Shema
        : new Shema(id: 9, name: "Schema 1", jours: "1");

    Uri url2 = Uri.parse(
        urlDB + "api/shema/user/" + (globals.idUser as int).toString());

    Future<List<Shema>> fetchShemas() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final response = await http.get(url2);
      List jsonMap = jsonDecode(response.body);

      List<Shema> toutLesShemas = <Shema>[];
      toutLesShemas = jsonMap.map((m) => new Shema.fromJson(m)).toList();

      String json = '[';
      toutLesShemas.forEach((element) {
        json += element.schemaToJsonForPref() + ',';
      });
      if (json.length > 3) json = json.substring(0, json.length - 1);
      json += ']';
      //print(json);

      await prefs.setString('schemas', json);

      globals.schemasChange = false;

      return toutLesShemas;
    }

    Future<List<Shema>> extractSchemas() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      List<Shema> shemas = <Shema>[];
      Future.delayed(
          Duration(seconds: 2),
          jsonDecode(prefs.getString('schemas').toString())
              .map((m) => new Shema.fromJson(m))
              .forEach((element) {
            shemas.add(element);
          }));
      return shemas;
    }

    if (globals.schemasChange)
      lesShemasFuture = fetchShemas();
    else
      lesShemasFuture = extractSchemas();
    lesShemas = <Shema>[];
  }

  Widget build(BuildContext context) {
    Future<bool> deleteShema({required Shema shemaInfo}) async {
      Uri url = Uri.parse(urlDB + "api/shema/" + shemaInfo.id.toString());
      print(url);
      final reponse = await http.delete(url);
      globals.schemasChange = true;
      print(reponse.body);
      return reponse.body != null;
    }

    Container unElementCalendrierTypo(
        String element, String typo, bool active) {
      FontWeight weight = FontWeight.w400;
      var color = Colors.black;
      if (typo == "lettre")
        weight = FontWeight.w700;
      else if (typo == 'jourGris') color = Color.fromRGBO(98, 94, 131, 1);

      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            color: active ? Color.fromRGBO(18, 0, 40, 1) : Colors.transparent),
        width: 30,
        height: 30,
        child: Center(
          child: Text(
            element,
            style: active
                ? TextStyle(
                    fontWeight: weight, fontSize: 15, color: Colors.white)
                : TextStyle(fontWeight: weight, fontSize: 15, color: color),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    bool GetSelect(int date) {
      bool ok = false;
      (shemaSelectionne.toListInt() as List<int>).forEach((element) {
        if (year == DateTime.now().add(Duration(days: element)).year &&
            month == DateTime.now().add(Duration(days: element)).month &&
            date == DateTime.now().add(Duration(days: element)).day) {
          ok = true;
        }
        print(year);
        print(DateTime.now().add(Duration(days: element)).year);
      });

      return ok;
    }

    Container unElementCalendrier(int jour, int semaine) {
      int premierJour = DateTime(year, month, 1).weekday;
      int jourCalcule =
          DateTime(year, month, jour + (8 - premierJour) + (7 * (semaine - 2)))
              .day;
      bool select = GetSelect(jourCalcule);
      if (semaine == 1) {
        if (jour >= premierJour) {
          return unElementCalendrierTypo(jourCalcule.toString(), '', select);
        } else {
          return unElementCalendrierTypo(
              jourCalcule.toString(), 'jourGris', false);
        }
      } else if (semaine == 6 || semaine == 5) {
        if (jourCalcule <= 14)
          return unElementCalendrierTypo(
              jourCalcule.toString(), 'jourGris', false);
        else
          return unElementCalendrierTypo(jourCalcule.toString(), '', select);
      } else {
        return unElementCalendrierTypo(jourCalcule.toString(), '', select);
      }
    }

    GetNameMonth() {
      switch (month) {
        case 1:
          return "Janvier ";
          break;
        case 2:
          return "Février";
          break;
        case 3:
          return "Mars";
          break;
        case 4:
          return "Avril";
          break;
        case 5:
          return "Mai";
          break;
        case 6:
          return "Juin";
          break;
        case 7:
          return "Juillet";
          break;
        case 8:
          return "Aout";
          break;
        case 9:
          return "Septembre";
          break;
        case 10:
          return "Octobre";
          break;
        case 11:
          return "Novembre";
          break;
        case 12:
          return "Decembre";
          break;
        default:
          return "Janvier";
          break;
      }
    }

    Route _returnRoute() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => CreateCourse(
          courseArguments: new CourseArguments(
                  matiere:
                      (this.courseArguments as CourseArguments).matiere ?? '',
                  cours: (this.courseArguments as CourseArguments).cours ?? '',
                  shema: shemaSelectionne,
                  nomLogo: (this.courseArguments as CourseArguments).nomLogo) ??
              '',
        ),
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
                    child: Loading(size: 100),
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

    Widget _popupDialogVerifyDelete(
        BuildContext context, List<Shema> lesShemasList, int index) {
      return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
          child: Container(
              padding: const EdgeInsets.only(
                  right: 12.0, left: 12.0, top: 30, bottom: 12),
              height: 180,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Supprimer ce schéma ?",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Cela aura pour effet de supprimer définitivement ce schéma de révision",
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
                          width: MediaQuery.of(context).size.width * 0.3,
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
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 50,
                          child: TextButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialogDelete(context, null),
                                );

                                bool result = await deleteShema(
                                    shemaInfo: lesShemasList[index]);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialogDelete(context, result),
                                );

                                await Future.delayed(Duration(seconds: 1));

                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);

                                List<Shema> listeShemas = <Shema>[];
                                for (var i = 0; i < lesShemasList.length; i++) {
                                  print(i.toString() + ' ' + index.toString());
                                  if (i != index) {
                                    listeShemas.add(lesShemasList[i]);
                                    print("ok");
                                  }
                                }

                                setState(() {
                                  lesShemas = listeShemas;
                                  shemaSelectionne = new Shema(
                                      id: 9, name: "Shema1", jours: "1");
                                });
                              },
                              child: Text('Supprimer',
                                  style: TextStyle(color: Colors.white)),
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

    Widget corp = SingleChildScrollView(
        child: Column(children: [
      SizedBox(
        height: 70,
      ),
      Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(_returnRoute());
              },
              child: Icon(Icons.arrow_back)),
          SizedBox(
            height: 30,
          ),
          Text(
            'Sélectionner\nun schéma',
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 32, color: Colors.black),
          ),
        ]),
      ),
      SizedBox(height: 10),
      Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
        child: lesShemas.length == 0
            ? FutureBuilder<List<Shema>>(
                future: lesShemasFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? (snapshot.data as List<Shema>).isNotEmpty
                          ? ListView.builder(
                              controller: _pageController,
                              scrollDirection: Axis.horizontal,
                              itemCount: (snapshot.data as List<Shema>).length,
                              itemBuilder: (context, index) {
                                return Column(children: [
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.02),
                                    child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        height: 90,
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              shemaSelectionne = ((snapshot.data
                                                  as List<Shema>)[index]);
                                            });
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll<
                                                      Color>(Colors.white),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14.0),
                                              )),
                                              side: shemaSelectionne ==
                                                      ((snapshot.data as List<
                                                          Shema>)[index])
                                                  ? MaterialStateProperty.all(
                                                      BorderSide(
                                                          color: Colors.white,
                                                          width: 1,
                                                          style: BorderStyle
                                                              .solid))
                                                  : null),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      (snapshot.data as List<
                                                              Shema>)[index]
                                                          .name as String,
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                  Row(
                                                    children: [
                                                      for (var element in (snapshot
                                                                  .data
                                                              as List<
                                                                  Shema>)[index]
                                                          .toListInt() as List<int>)
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 10),
                                                          decoration: BoxDecoration(
                                                              color: Color
                                                                  .fromRGBO(18,
                                                                      0, 40, 1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7)),
                                                          height: 25,
                                                          width: 25,
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                    element
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white))
                                                              ]),
                                                        ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        _popupDialogVerifyDelete(
                                                            context,
                                                            snapshot.data
                                                                as List<Shema>,
                                                            index),
                                                  );
                                                },
                                                child: SvgPicture.asset(
                                                  'images/trash-outline.svg',
                                                  semanticsLabel: 'Acme Logo',
                                                  width: 20,
                                                  color: Color.fromARGB(
                                                      255, 255, 0, 0),
                                                ),
                                              )
                                            ],
                                          ),
                                        )),
                                  )
                                ]);
                              },
                            )
                          : Center(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Aucun schémas',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            ))
                      : Center(
                          child: Loading(
                          size: 50,
                        ));
                },
              )
            : ListView.builder(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                itemCount: lesShemas.length,
                itemBuilder: (context, index) {
                  return Column(children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.02,
                          left: MediaQuery.of(context).size.width * 0.02),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: 90,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                shemaSelectionne = (lesShemas[index]);
                              });
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Colors.white),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.0),
                                )),
                                side: shemaSelectionne == (lesShemas[index])
                                    ? MaterialStateProperty.all(BorderSide(
                                        color: Colors.white,
                                        width: 1,
                                        style: BorderStyle.solid))
                                    : null),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(lesShemas[index].name as String,
                                        style: TextStyle(color: Colors.black)),
                                    Row(
                                      children: [
                                        for (var element in lesShemas[index]
                                            .toListInt() as List<int>)
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            decoration: BoxDecoration(
                                                color: Color.fromRGBO(
                                                    18, 0, 40, 1),
                                                borderRadius:
                                                    BorderRadius.circular(7)),
                                            height: 25,
                                            width: 25,
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(element.toString(),
                                                      style: TextStyle(
                                                          color: Colors.white))
                                                ]),
                                          ),
                                      ],
                                    )
                                  ],
                                ),
                                TextButton(
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _buildPopupDialogDelete(
                                              context, null),
                                    );
                                    bool result = await deleteShema(
                                        shemaInfo: lesShemas[index]);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _buildPopupDialogDelete(
                                              context, result),
                                    );

                                    await Future.delayed(Duration(seconds: 1));

                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    List<Shema> listeShemas = <Shema>[];
                                    for (var i = 0; i < lesShemas.length; i++) {
                                      if (i != index) {
                                        listeShemas.add(lesShemas[i]);
                                      }
                                    }

                                    setState(() {
                                      lesShemas = listeShemas;
                                      shemaSelectionne = new Shema(
                                          id: 9, name: "Schema1", jours: "1");
                                    });
                                  },
                                  child: SvgPicture.asset(
                                    'images/trash-outline.svg',
                                    semanticsLabel: 'Acme Logo',
                                    width: 20,
                                    color: Color.fromARGB(255, 255, 0, 0),
                                  ),
                                )
                              ],
                            ),
                          )),
                    )
                  ]);
                },
              ),
      ),
      SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 70,
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/addShema',
                  arguments: this.courseArguments);
            },
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0),
                ))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Créer un schéma", style: TextStyle(color: Colors.black)),
                Container(
                    child: Icon(
                  Icons.add,
                  color: Colors.black,
                ))
              ],
            ),
          )),
      SizedBox(height: 20),
      Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    width: 40,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        if (month == 1) {
                          month = 12;
                          year--;
                        } else
                          month--;
                        setState(() {});
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              Color.fromRGBO(18, 0, 40, 1)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ))),
                      child: Text("<", style: TextStyle(color: Colors.white)),
                    )),
                Text(
                  GetNameMonth() + ' ' + year.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: Colors.black),
                ),
                SizedBox(
                    width: 40,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        if (month == 12) {
                          month = 1;
                          year++;
                        } else {
                          month++;
                        }
                        setState(() {});
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              Color.fromRGBO(18, 0, 40, 1)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ))),
                      child: Text(">", style: TextStyle(color: Colors.white)),
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                unElementCalendrierTypo('L', 'lettre', false),
                unElementCalendrierTypo('M', 'lettre', false),
                unElementCalendrierTypo('M', 'lettre', false),
                unElementCalendrierTypo('J', 'lettre', false),
                unElementCalendrierTypo('V', 'lettre', false),
                unElementCalendrierTypo('S', 'lettre', false),
                unElementCalendrierTypo('D', 'lettre', false),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                unElementCalendrier(1, 1),
                unElementCalendrier(2, 1),
                unElementCalendrier(3, 1),
                unElementCalendrier(4, 1),
                unElementCalendrier(5, 1),
                unElementCalendrier(6, 1),
                unElementCalendrier(7, 1),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                unElementCalendrier(1, 2),
                unElementCalendrier(2, 2),
                unElementCalendrier(3, 2),
                unElementCalendrier(4, 2),
                unElementCalendrier(5, 2),
                unElementCalendrier(6, 2),
                unElementCalendrier(7, 2),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                unElementCalendrier(1, 3),
                unElementCalendrier(2, 3),
                unElementCalendrier(3, 3),
                unElementCalendrier(4, 3),
                unElementCalendrier(5, 3),
                unElementCalendrier(6, 3),
                unElementCalendrier(7, 3),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                unElementCalendrier(1, 4),
                unElementCalendrier(2, 4),
                unElementCalendrier(3, 4),
                unElementCalendrier(4, 4),
                unElementCalendrier(5, 4),
                unElementCalendrier(6, 4),
                unElementCalendrier(7, 4),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                unElementCalendrier(1, 5),
                unElementCalendrier(2, 5),
                unElementCalendrier(3, 5),
                unElementCalendrier(4, 5),
                unElementCalendrier(5, 5),
                unElementCalendrier(6, 5),
                unElementCalendrier(7, 5),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                unElementCalendrier(1, 6),
                unElementCalendrier(2, 6),
                unElementCalendrier(3, 6),
                unElementCalendrier(4, 6),
                unElementCalendrier(5, 6),
                unElementCalendrier(6, 6),
                unElementCalendrier(7, 6),
              ],
            ),
          ],
        ),
      ),
      SizedBox(
        height: 20,
      )
    ]));

    return Container(
      color: Color.fromRGBO(242, 244, 255, 1),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: corp,
      ),
    );
  }
}
