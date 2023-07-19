import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:methodej/common/loading.dart';
import 'package:methodej/screens/Calendar/EditCourse.dart';
import '../../common/globals.dart' as globals;
import '../common/constants.dart';
import '../models/CourseArguments.dart';
import '../models/Revision.dart';
import '../models/course.dart';
import 'Calendar/CalendarPage.dart';
import 'package:methodej/models/ModifyRev.dart';

class CoursePage extends StatefulWidget {
  CoursePage({this.item});
  final item;
  @override
  State<CoursePage> createState() => _CoursePageState(item: this.item);
}

class _CoursePageState extends State<CoursePage> {
  _CoursePageState({required this.item});

  final Course item;

  Widget build(BuildContext context) {
    String moiTronc(int number) {
      switch (number) {
        case 1:
          return "Jan";
          break;
        case 2:
          return "Fév";
          break;
        case 3:
          return "Mar";
          break;
        case 4:
          return "Avr";
          break;
        case 5:
          return "Mai";
          break;
        case 6:
          return "Jui";
          break;
        case 7:
          return "Jui";
          break;
        case 8:
          return "Aou";
          break;
        case 9:
          return "Sep";
          break;
        case 10:
          return "Oct";
          break;
        case 11:
          return "Nov";
          break;
        case 12:
          return "Dec";
          break;
        default:
          return "Jan";
          break;
      }
    }

    Future<bool> updateRevision({required Revision revisionInfo}) async {
      print(revisionInfo.dateFait);
      print(revisionInfo.revisionToJson());
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
    }

    Future<List<Course>> GetCourses() async {
      Uri url = Uri.parse(
          urlDB + "api/courses/user/" + (globals.idUser as int).toString());
      final response = await http.get(url);
      List jsonMap = jsonDecode(response.body);
      List<Course> toutesLesCourses = <Course>[];
      jsonMap.map((m) => new Course.fromJson(m)).forEach((element) {
        toutesLesCourses.add(element);
      });
      print('i');
      return toutesLesCourses;
    }

    Future<bool> deleteRevision({required Revision revisionInfo}) async {
      Uri url =
          Uri.parse(urlDB + "api/revisions/" + revisionInfo.id.toString());
      print(url);
      final reponse = await http.delete(url);
      print(reponse.body);
      globals.dataChange = true;
      globals.countChange = true;

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

    Route _editRoute() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => EditCourse(
          courseArguments: new CourseArguments(
              id: item.id ?? 0,
              matiere: item.matiere ?? '',
              cours: item.cours ?? '',
              nomLogo: item.nomLogo ?? ''),
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

    Widget _popupDialogVerifyDelete(BuildContext context) {
      return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
          child: Container(
              padding: const EdgeInsets.only(
                  right: 6.0, left: 6.0, top: 30, bottom: 12),
              height: 180,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Supprimer cette révision ?",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Cela aura pour effet de supprimer définitivement la révision",
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
                                bool result = await deleteRevision(
                                    revisionInfo: new Revision(
                                        id: this
                                            .item
                                            .revisions?[
                                                this.item.numRevActuel as int]
                                            .id,
                                        datePrevu: this
                                            .item
                                            .revisions?[
                                                this.item.numRevActuel as int]
                                            .datePrevu,
                                        dateFait: DateTime.now()));
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialogDelete(context, result),
                                );

                                await Future.delayed(Duration(seconds: 1));

                                Navigator.pop(context);
                                Navigator.pop(context);
                                List<Revision> listeRev = <Revision>[];
                                for (var i = 0;
                                    i <
                                        (this.item.revisions as List<Revision>)
                                            .length;
                                    i++) {
                                  if (i != this.item.numRevActuel) {
                                    listeRev.add((this.item.revisions
                                        as List<Revision>)[i]);
                                  }
                                }
                                Course newCourse = Course(
                                    id: this.item.id,
                                    cours: this.item.cours,
                                    matiere: this.item.matiere,
                                    user: this.item.user,
                                    revisions: listeRev,
                                    nomLogo: this.item.nomLogo);
                                newCourse.numRevActuel = 0;
                                if (newCourse.revisions?.length as int > 0) {
                                  Navigator.pushNamed(context, '/CoursePage',
                                      arguments: newCourse);
                                } else {
                                  Navigator.of(context).push(_calendarRoute());
                                }
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

    void reportFast(int num) async {
      if (num == 0) {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              _buildPopupDialogUpdate(context, null),
        );
        bool result = await updateRevision(
            revisionInfo: new Revision(
                id: item.revisions?[item.numRevActuel as int].id,
                datePrevu: DateTime.now(),
                dateFait: DateTime(0000)));
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              _buildPopupDialogUpdate(context, result),
        );

        await Future.delayed(Duration(seconds: 1));

        Navigator.pop(context);
        Navigator.pop(context);

        List<Revision> listeRev = <Revision>[];
        for (var i = 0;
            i < (this.item.revisions as List<Revision>).length;
            i++) {
          if (i == this.item.numRevActuel) {
            Revision newRev = Revision(
                id: (this.item.revisions as List<Revision>)[i].id,
                datePrevu: DateTime.now(),
                dateFait: DateTime(0000));
            listeRev.add(newRev);
          } else {
            listeRev.add((this.item.revisions as List<Revision>)[i]);
          }
        }
        listeRev.sort((a, b) =>
            (a.datePrevu as DateTime).compareTo(b.datePrevu as DateTime));
        Course newCourse = Course(
            id: this.item.id,
            cours: this.item.cours,
            matiere: this.item.matiere,
            user: this.item.user,
            revisions: listeRev,
            nomLogo: this.item.nomLogo);
        newCourse.numRevActuel = null;
        Navigator.pushNamed(context, '/CoursePage', arguments: newCourse);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              _buildPopupDialogUpdate(context, null),
        );
        bool result = await updateRevision(
            revisionInfo: new Revision(
                id: item.revisions?[item.numRevActuel as int].id,
                datePrevu: (item.revisions?[item.numRevActuel as int].datePrevu
                        as DateTime)
                    .add(Duration(days: num)),
                dateFait: DateTime(0000)));
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              _buildPopupDialogUpdate(context, result),
        );

        await Future.delayed(Duration(seconds: 1));

        Navigator.pop(context);
        Navigator.pop(context);

        List<Revision> listeRev = <Revision>[];
        for (var i = 0;
            i < (this.item.revisions as List<Revision>).length;
            i++) {
          if (i == this.item.numRevActuel) {
            Revision newRev = Revision(
                id: (this.item.revisions as List<Revision>)[i].id,
                datePrevu: (item.revisions?[item.numRevActuel as int].datePrevu
                        as DateTime)
                    .add(Duration(days: num)),
                dateFait: DateTime(0000));
            listeRev.add(newRev);
          } else {
            listeRev.add((this.item.revisions as List<Revision>)[i]);
          }
        }
        listeRev.sort((a, b) =>
            (a.datePrevu as DateTime).compareTo(b.datePrevu as DateTime));
        Course newCourse = Course(
            id: this.item.id,
            cours: this.item.cours,
            matiere: this.item.matiere,
            user: this.item.user,
            revisions: listeRev,
            nomLogo: this.item.nomLogo);
        newCourse.numRevActuel = null;
        Navigator.pushNamed(context, '/CoursePage', arguments: newCourse);
      }
    }

    return Scaffold(
        backgroundColor: Color.fromRGBO(242, 244, 255, 1),
        resizeToAvoidBottomInset: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.08,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(_calendarRoute());
                          },
                          child: Icon(Icons.close),
                        ),
                        GestureDetector(
                          onTap: () async {
                            Navigator.of(context).push(_editRoute());
                          },
                          child: SvgPicture.asset(
                            'images/create-outline.svg',
                            semanticsLabel: 'Acme Logo',
                            width: 26,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color.fromRGBO(146, 39, 249, 1),
                                        Color.fromRGBO(99, 59, 243, 1)
                                      ])),
                              width: 50,
                              height: 50,
                              child: this.item.nomLogo != ""
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          (this.item.nomLogo as String),
                                          width: 30,
                                          height: 30,
                                          semanticsLabel: 'Acme Logo',
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ],
                                    )
                                  : null,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                this.item.matiere as String,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.black),
                              ),
                              Text(
                                this.item.cours as String,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12,
                                    color: Colors.black),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        // c'st parce que ya cet row que ça marche pas mais on peut pas l'enlever car sinon on peut pas mettre le plus etc

                        children: [
                          ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: this.item.revisions?.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Stack(children: [
                                    Container(
                                        width: 70,
                                        height: 85,
                                        decoration: const BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        margin: EdgeInsets.only(
                                            left: 8, right: 8, top: 7),
                                        child: TextButton(
                                          onPressed: () async {
                                            this.item.numRevActuel = index;
                                            setState(() {});
                                          },
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  this
                                                      .item
                                                      .revisions?[index]
                                                      .datePrevu
                                                      ?.day
                                                      .toString() as String,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 24,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  moiTronc(this
                                                      .item
                                                      .revisions?[index]
                                                      .datePrevu
                                                      ?.month as int),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 17,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                    this.item.revisions?[index].dateFait ==
                                                null ||
                                            this
                                                    .item
                                                    .revisions?[index]
                                                    .dateFait ==
                                                DateTime(0000)
                                        ? Container(
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color.fromARGB(
                                                    255, 213, 213, 213)),
                                            width: 20,
                                            height: 20,
                                            child: Icon(
                                              Icons.check,
                                              size: 13,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Container(
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color.fromARGB(
                                                    255, 115, 0, 255)),
                                            width: 20,
                                            height: 20,
                                            child: Icon(
                                              Icons.check,
                                              size: 13,
                                              color: Colors.white,
                                            ),
                                          )
                                  ]),
                                  index == this.item.numRevActuel
                                      ? Container(
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  Color.fromRGBO(18, 0, 40, 1)),
                                          width: 10,
                                          height: 10,
                                        )
                                      : Text(''),
                                ],
                              );
                            },
                          ),
                          this.item.revisions?.length as int < 4
                              ? Column(children: [
                                  Container(
                                      width: 70,
                                      height: 85,
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      margin: EdgeInsets.only(
                                          left: 8, right: 8, top: 7),
                                      child: TextButton(
                                          onPressed: () async {
                                            Navigator.pushNamed(
                                                context, '/addrev',
                                                arguments: this.item);
                                          },
                                          child: Text('+',
                                              style: TextStyle(
                                                  color: Colors.black))))
                                ])
                              : Text(''),
                          this.item.revisions?.length as int < 3
                              ? Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        width: 70,
                                        height: 85,
                                        decoration: const BoxDecoration(
                                            color: Color.fromARGB(
                                                116, 255, 255, 255),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        margin: EdgeInsets.only(
                                            left: 8, right: 8, top: 7),
                                        child: Text(''))
                                  ],
                                )
                              : Text(''),
                          this.item.revisions?.length as int < 2
                              ? Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        width: 70,
                                        height: 85,
                                        decoration: const BoxDecoration(
                                            color: Color.fromARGB(
                                                116, 255, 255, 255),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        margin: EdgeInsets.only(
                                            left: 8, right: 8, top: 7),
                                        child: Text(''))
                                  ],
                                )
                              : Text('')
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    this.item.numRevActuel != null
                        ? Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 100,
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                              Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      height: 100,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Reporter la révision",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                height: 30,
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                decoration: const BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 221, 236, 244),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                7))),
                                                child: TextButton(
                                                    onPressed: () async {
                                                      reportFast(0);
                                                    },
                                                    child: Text(
                                                      "Aujourd'hui",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.black),
                                                    )),
                                              ),
                                              Container(
                                                height: 30,
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                decoration: const BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 221, 236, 244),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                7))),
                                                child: TextButton(
                                                    onPressed: () async {
                                                      reportFast(-1);
                                                    },
                                                    child: Text(
                                                      'La veille',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.black),
                                                    )),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                height: 30,
                                                decoration: const BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 221, 236, 244),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                7))),
                                                child: TextButton(
                                                    onPressed: () {
                                                      reportFast(1);
                                                    },
                                                    child: Text(
                                                      'Le lendemain',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.black),
                                                    )),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 70,
                                      height: 70,
                                      child: TextButton(
                                          onPressed: () async {
                                            Navigator.pushNamed(
                                                context, '/ModifRev',
                                                arguments: this.item);
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll<
                                                          Color>(
                                                      Color.fromRGBO(
                                                          18, 0, 40, 1)),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14.0),
                                              ))),
                                          child: Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white,
                                          )),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        : Text("Sélectionne une révison")
                  ],
                ),
              ),
              this.item.numRevActuel != null
                  ? Column(
                      children: [
                        this
                                        .item
                                        .revisions?[
                                            this.item.numRevActuel as int]
                                        .dateFait ==
                                    null ||
                                this
                                        .item
                                        .revisions?[
                                            this.item.numRevActuel as int]
                                        .dateFait ==
                                    DateTime(0000)
                            ? Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: 60,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _buildPopupDialogUpdate(
                                              context, null),
                                    );
                                    bool result = await updateRevision(
                                        revisionInfo: new Revision(
                                            id: this
                                                .item
                                                .revisions?[this
                                                    .item
                                                    .numRevActuel as int]
                                                .id,
                                            datePrevu: this
                                                .item
                                                .revisions?[this
                                                    .item
                                                    .numRevActuel as int]
                                                .datePrevu,
                                            dateFait: DateTime.now()));
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _buildPopupDialogUpdate(
                                              context, result),
                                    );

                                    await Future.delayed(Duration(seconds: 1));

                                    Navigator.pop(context);
                                    Navigator.pop(context);

                                    List<Revision> listeRev = <Revision>[];
                                    for (var i = 0;
                                        i <
                                            (this.item.revisions
                                                    as List<Revision>)
                                                .length;
                                        i++) {
                                      if (i == this.item.numRevActuel) {
                                        Revision newRev = Revision(
                                            id: (this.item.revisions
                                                    as List<Revision>)[i]
                                                .id,
                                            datePrevu: (this.item.revisions
                                                    as List<Revision>)[i]
                                                .datePrevu,
                                            dateFait: DateTime.now());
                                        listeRev.add(newRev);
                                      } else {
                                        listeRev.add((this.item.revisions
                                            as List<Revision>)[i]);
                                      }
                                    }
                                    Course newCourse = Course(
                                        id: this.item.id,
                                        cours: this.item.cours,
                                        matiere: this.item.matiere,
                                        user: this.item.user,
                                        revisions: listeRev,
                                        nomLogo: this.item.nomLogo);
                                    newCourse.numRevActuel =
                                        this.item.numRevActuel;
                                    Navigator.pushNamed(context, '/CoursePage',
                                        arguments: newCourse);
                                  },
                                  child: Text(
                                    "C'est fait !",
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
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: 60,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _buildPopupDialogUpdate(
                                              context, null),
                                    );

                                    bool result = await updateRevision(
                                        revisionInfo: new Revision(
                                            id: this
                                                .item
                                                .revisions?[this
                                                    .item
                                                    .numRevActuel as int]
                                                .id,
                                            datePrevu: this
                                                .item
                                                .revisions?[this
                                                    .item
                                                    .numRevActuel as int]
                                                .datePrevu,
                                            dateFait: DateTime(0000)));

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _buildPopupDialogUpdate(
                                              context, result),
                                    );

                                    await Future.delayed(Duration(seconds: 1));

                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    List<Revision> listeRev = <Revision>[];
                                    for (var i = 0;
                                        i <
                                            (this.item.revisions
                                                    as List<Revision>)
                                                .length;
                                        i++) {
                                      if (i == this.item.numRevActuel) {
                                        Revision newRev = Revision(
                                            id: (this.item.revisions
                                                    as List<Revision>)[i]
                                                .id,
                                            datePrevu: (this.item.revisions
                                                    as List<Revision>)[i]
                                                .datePrevu,
                                            dateFait: DateTime(0000));
                                        listeRev.add(newRev);
                                      } else {
                                        listeRev.add((this.item.revisions
                                            as List<Revision>)[i]);
                                      }
                                    }
                                    Course newCourse = Course(
                                        id: this.item.id,
                                        cours: this.item.cours,
                                        matiere: this.item.matiere,
                                        user: this.item.user,
                                        revisions: listeRev,
                                        nomLogo: this.item.nomLogo);
                                    newCourse.numRevActuel =
                                        this.item.numRevActuel;
                                    Navigator.pushNamed(context, '/CoursePage',
                                        arguments: newCourse);
                                  },
                                  child: Text(
                                    "Annuler",
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
                        TextButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _popupDialogVerifyDelete(context),
                              );
                            },
                            child: Text(
                              'Supprimer la révision',
                              style: TextStyle(color: Colors.red),
                            )),
                        SizedBox(
                          height: 40,
                        )
                      ],
                    )
                  : Text('')
            ],
          ),
        ));
  }
}
