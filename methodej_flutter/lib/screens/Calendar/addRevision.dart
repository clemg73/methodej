import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:methodej/common/loading.dart';
import 'package:methodej/models/ModifyRev.dart';

import '../../common/constants.dart';
import '../../models/Revision.dart';
import '../../models/course.dart';

import 'package:http/http.dart' as http;
import '../../common/globals.dart' as globals;

class AddRev extends StatefulWidget {
  AddRev({this.item});
  final item;

  @override
  State<AddRev> createState() => _AddRevState(item: this.item);
}

class _AddRevState extends State<AddRev> {
  _AddRevState({required this.item});

  final Course item;

  int year = DateTime.now().year;
  int month = DateTime.now().month;

  DateTime dateChoisi = DateTime.now();

  List<int> numbers = <int>[];

  Future<List<int>> countRev() async {
    String date = '';
    if (month == DateTime.now().month) {
      date = year.toString() +
          '-' +
          month.toString() +
          '-' +
          DateTime.now().day.toString();
    } else {
      date = year.toString() + '-' + month.toString() + '-01';
    }
    print(date);

    final uri = Uri.http(
        "methodej.azurewebsites.net",
        "/api/courses/countForReport/user/" +
            (globals.idUser as int).toString(),
        {'date': date});

    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);
    String reponse = response.body;
    print("reponse: " + jsonDecode(reponse).toString());
    reponse = reponse.replaceAll('[', '');
    reponse = reponse.replaceAll(']', '');
    List<int> chaine = reponse.split(',').map((e) => int.parse(e)).toList();
    return chaine;
  }

  @override
  Widget build(BuildContext context) {
    /*Future<bool> updateRevision({required Revision revisionInfo}) async {
      print(revisionInfo.dateFait);

      try {
        Response response = await Dio().post(
          urlDB + "api/revisions/revisions/update",
          data: revisionInfo.revisionToJson(),
        );

        print('Revision updated ${response.data}');
        globals.dataChange = true;
        globals.countChange = true;

        return true;
      } catch (e) {
        print('Error updating revision: $e');
        return false;
      }
    }*/

    Future<Revision> addRevision({required Revision revisionInfo}) async {
      print(revisionInfo.revisionToJsonForAdd());

      try {
        Response response = await Dio().post(
          urlDB + "api/revisions/addrev/" + item.id.toString(),
          data: revisionInfo.revisionToJsonForAdd(),
        );
        print('Revision add ${response.toString()}');
        globals.dataChange = true;
        globals.countChange = true;

        return Revision.fromJson(jsonDecode(response.toString()));
      } catch (e) {
        print('Error add revision: $e');
        return Revision();
      }
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
                            "Révison mis à jour",
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

    /*int CalculMaxCours() {
      List<DateTime> listDate = <DateTime>[];

      lesCourses.forEach((element) {
        element.revisions?.forEach((element2) {
          listDate.add(DateTime(
              element2.datePrevu?.year as int,
              element2.datePrevu?.month as int,
              element2.datePrevu?.day as int));
        });
      });
      int max = 0;
      listDate.forEach((element) {
        if (element.compareTo(DateTime(DateTime.now().year,
                DateTime.now().month, DateTime.now().day)) >=
            0) {
          int count = 0;
          listDate.forEach((element2) {
            if (element2.compareTo(DateTime(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day)) >=
                0) {
              if (element == element2) {
                count++;
              }
            }
          });
          if (count > max) {
            max = count;
          }
        }
      });

      return max;
    }*/

    Widget unElementCalendrierTypo(String element, String typo, Color colorDay,
        bool pastille, bool selected) {
      FontWeight weight = FontWeight.w400;
      var color = Colors.black;

      if (colorDay == Color.fromRGBO(44, 30, 97, 1))
        color = Colors.white;
      else if (typo == "lettre")
        weight = FontWeight.w700;
      else if (typo == 'jourGris')
        color = Color.fromARGB(26, 0, 0, 0);
      else if (typo == 'jourPasse') color = Color.fromARGB(83, 0, 0, 0);

      if (typo == "lettre" || typo == 'jourGris' || typo == 'jourPasse') {
        return SizedBox(
            width: 40,
            height: 40,
            child: Center(
              child: Text(
                element,
                style:
                    TextStyle(fontWeight: weight, fontSize: 15, color: color),
                textAlign: TextAlign.center,
              ),
            ));
      }

      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topRight,
        children: [
          Container(
              width: 40,
              height: 40,
              child: TextButton(
                onPressed: () {
                  dateChoisi = DateTime(year, month, int.parse(element));
                  setState(() {});
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(colorDay),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      side: selected
                          ? BorderSide(width: 2, color: Colors.black)
                          : BorderSide.none,
                      borderRadius: BorderRadius.circular(14.0),
                    ))),
                child: Center(
                  child: Text(
                    element,
                    style: TextStyle(
                        fontWeight: weight, fontSize: 15, color: color),
                    textAlign: TextAlign.center,
                  ),
                ),
              )),
          pastille == true
              ? Positioned(
                  top: -3,
                  right: -3,
                  child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17),
                          color: Color.fromRGBO(44, 30, 97, 1))))
              : Container()
        ],
      );
    }

    Color GetColor(int date, List<int> nbs) {
      Color laCouleur = Colors.transparent;

      int nbCours = nbs[date];

      int max = nbs.reduce(math.max) == 0 ? 1 : nbs.reduce(math.max);

      return Color.fromARGB((nbCours * 255 / max).toInt(), 233, 30, 98)
          as Color;
    }

    Widget unElementCalendrier(int jour, int semaine, List<int> nbs) {
      int premierJour = DateTime(year, month, 1).weekday;
      int jourCalcule =
          DateTime(year, month, jour + (8 - premierJour) + (7 * (semaine - 2)))
              .day;
      print(jourCalcule);

      bool pastille = false;
      item.revisions?.forEach((element2) {
        if (element2.datePrevu?.year == year &&
            element2.datePrevu?.month == month &&
            element2.datePrevu?.day == jourCalcule) {
          pastille = true;
        }
      });

      bool selected = dateChoisi ==
              DateTime(
                  year, month, jour + (8 - premierJour) + (7 * (semaine - 2)))
          ? true
          : false;

      Color color;
      if (semaine == 1) {
        if (jour >= premierJour) {
          if (DateTime(year, month, jourCalcule).compareTo(item
                  .revisions?[item.numRevActuel as int].datePrevu as DateTime) <
              0) {
            return unElementCalendrierTypo(jourCalcule.toString(), 'jourPasse',
                Colors.transparent, pastille, selected);
          }
          color = GetColor(jourCalcule, nbs);
          return unElementCalendrierTypo(
              jourCalcule.toString(), '', color, pastille, selected);
        } else {
          return unElementCalendrierTypo(jourCalcule.toString(), 'jourGris',
              Colors.transparent, pastille, selected);
        }
      } else if (semaine == 6 || semaine == 5) {
        if (jourCalcule <= 14)
          return unElementCalendrierTypo(jourCalcule.toString(), 'jourGris',
              Colors.transparent, pastille, selected);
        else {
          if (DateTime(year, month, jourCalcule).compareTo(item
                  .revisions?[item.numRevActuel as int].datePrevu as DateTime) <
              0) {
            return unElementCalendrierTypo(jourCalcule.toString(), 'jourPasse',
                Colors.transparent, pastille, selected);
          }
          color = GetColor(jourCalcule, nbs);
          return unElementCalendrierTypo(
              jourCalcule.toString(), '', color, pastille, selected);
        }
      } else {
        if (DateTime(year, month, jourCalcule).compareTo(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day)) <
            0) {
          return unElementCalendrierTypo(jourCalcule.toString(), 'jourPasse',
              Colors.transparent, pastille, selected);
        }
        color = GetColor(jourCalcule, nbs);
        return unElementCalendrierTypo(
            jourCalcule.toString(), '', color, pastille, selected);
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

    Container calendrier(List<int> nbs) {
      return Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(14)),
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
                          setState(() {
                            numbers = nbs;
                          });
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Color.fromRGBO(44, 30, 97, 1)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
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
                          setState(() {
                            numbers = nbs;
                          });
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Color.fromRGBO(44, 30, 97, 1)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0),
                            ))),
                        child: Text(">", style: TextStyle(color: Colors.white)),
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  unElementCalendrierTypo(
                      'L', 'lettre', Colors.transparent, false, false),
                  unElementCalendrierTypo(
                      'M', 'lettre', Colors.transparent, false, false),
                  unElementCalendrierTypo(
                      'M', 'lettre', Colors.transparent, false, false),
                  unElementCalendrierTypo(
                      'J', 'lettre', Colors.transparent, false, false),
                  unElementCalendrierTypo(
                      'V', 'lettre', Colors.transparent, false, false),
                  unElementCalendrierTypo(
                      'S', 'lettre', Colors.transparent, false, false),
                  unElementCalendrierTypo(
                      'D', 'lettre', Colors.transparent, false, false),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  unElementCalendrier(1, 1, nbs),
                  unElementCalendrier(2, 1, nbs),
                  unElementCalendrier(3, 1, nbs),
                  unElementCalendrier(4, 1, nbs),
                  unElementCalendrier(5, 1, nbs),
                  unElementCalendrier(6, 1, nbs),
                  unElementCalendrier(7, 1, nbs),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  unElementCalendrier(1, 2, nbs),
                  unElementCalendrier(2, 2, nbs),
                  unElementCalendrier(3, 2, nbs),
                  unElementCalendrier(4, 2, nbs),
                  unElementCalendrier(5, 2, nbs),
                  unElementCalendrier(6, 2, nbs),
                  unElementCalendrier(7, 2, nbs),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  unElementCalendrier(1, 3, nbs),
                  unElementCalendrier(2, 3, nbs),
                  unElementCalendrier(3, 3, nbs),
                  unElementCalendrier(4, 3, nbs),
                  unElementCalendrier(5, 3, nbs),
                  unElementCalendrier(6, 3, nbs),
                  unElementCalendrier(7, 3, nbs),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  unElementCalendrier(1, 4, nbs),
                  unElementCalendrier(2, 4, nbs),
                  unElementCalendrier(3, 4, nbs),
                  unElementCalendrier(4, 4, nbs),
                  unElementCalendrier(5, 4, nbs),
                  unElementCalendrier(6, 4, nbs),
                  unElementCalendrier(7, 4, nbs),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  unElementCalendrier(1, 5, nbs),
                  unElementCalendrier(2, 5, nbs),
                  unElementCalendrier(3, 5, nbs),
                  unElementCalendrier(4, 5, nbs),
                  unElementCalendrier(5, 5, nbs),
                  unElementCalendrier(6, 5, nbs),
                  unElementCalendrier(7, 5, nbs),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  unElementCalendrier(1, 6, nbs),
                  unElementCalendrier(2, 6, nbs),
                  unElementCalendrier(3, 6, nbs),
                  unElementCalendrier(4, 6, nbs),
                  unElementCalendrier(5, 6, nbs),
                  unElementCalendrier(6, 6, nbs),
                  unElementCalendrier(7, 6, nbs),
                ],
              ),
            ],
          ));
    }

    Widget cal = FutureBuilder<List<int>>(
      future: countRev(),
      builder: (context, snapshot) {
        return snapshot.hasData && (snapshot.data as List<int>) != numbers
            ? calendrier(snapshot.data as List<int>)
            : Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(14)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Loading(
                      size: 100,
                    ),
                  ],
                ));
      },
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 244, 255, 1),
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 70,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back)),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Ajouter\nune révision',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 32,
                            color: Colors.black),
                      ),
                    ]),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FutureBuilder<List<int>>(
                      future:
                          countRev(), // a previously-obtained Future<String> or null
                      builder: (BuildContext context,
                          AsyncSnapshot<List<int>> snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            (snapshot.data as List<int>)
                                .reduce(math.max)
                                .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Color.fromARGB(255, 0, 0, 0)),
                          );
                        } else {
                          return Text('');
                        }
                      }),
                  SvgPicture.asset(
                    'images/caret-down-outline.svg',
                    semanticsLabel: 'Acme Logo',
                    width: 10,
                    color: Color.fromRGBO(31, 6, 63, 1),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 10,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color.fromARGB(10, 233, 30, 98),
                              Color.fromARGB(255, 233, 30, 98)
                            ])),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              cal,
              SizedBox(
                height: 30,
              ),
              Text(
                'Date choisi: ' +
                    dateChoisi.day.toString() +
                    ' ' +
                    GetNameMonth() +
                    ' ' +
                    year.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 60,
                  child: TextButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _buildPopupDialogUpdate(context, null),
                        );
                        Revision result = await addRevision(
                            revisionInfo: new Revision(
                                id: 0,
                                datePrevu: dateChoisi,
                                dateFait: DateTime(0000)));
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _buildPopupDialogUpdate(
                                  context, result != Revision()),
                        );

                        await Future.delayed(Duration(seconds: 1));
                        Navigator.pop(context);
                        Navigator.pop(context);

                        if (result != Revision()) {
                          (item.revisions as List<Revision>).add(result);
                        }
                        item.revisions!.sort((a, b) => (a.datePrevu as DateTime)
                            .compareTo(b.datePrevu as DateTime));
                        Navigator.pushNamed(context, '/CoursePage',
                            arguments: item);
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              Color.fromRGBO(18, 0, 40, 1)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ))),
                      child: Text(
                        "Ajouter",
                        style: TextStyle(color: Colors.white),
                      ))),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
