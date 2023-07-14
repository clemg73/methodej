import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:methodej/common/loading.dart';
import 'package:methodej/models/ModifyRev.dart';
import '../../common/constants.dart';
import '../../models/Revision.dart';
import '../../models/course.dart';
import '../../models/shema.dart';
import 'package:http/http.dart' as http;
import '../../common/globals.dart' as globals;

class CourseItem extends StatefulWidget {
  CourseItem({this.item});
  final item;
  @override
  State<CourseItem> createState() => _CourseItemState(item: this.item);
}

class _CourseItemState extends State<CourseItem> {
  _CourseItemState({required this.item});

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

    Future<bool> deleteRevision({required Revision revisionInfo}) async {
      Uri url =
          Uri.parse(urlDB + "api/revisions/" + revisionInfo.id.toString());
      print(url);
      final reponse = await http.delete(url);
      globals.dataChange = true;
      globals.countChange = true;

      print(reponse.body);
      return reponse.body != null;
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

    Widget _buildPopupDialogGoCal(BuildContext context, List<Course> lesCours) {
      return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(26.0)),
          child: Container(
              padding: const EdgeInsets.only(
                  right: 12.0, left: 12.0, top: 40, bottom: 12),
              width: 300,
              height: 450,
              child: Column(children: [
                ElevatedButton(
                  onPressed: () async {},
                  child: Text(
                    "Je reporte cette révision",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ])));
    }

    Widget _buildPopupDialog(BuildContext context, Course leCour) {
      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(26.0)),
        child: Container(
          padding: const EdgeInsets.only(
              right: 12.0, left: 12.0, top: 40, bottom: 12),
          width: 350,
          height: 450,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
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
                          ? Container(
                              child: Image.asset("images/logo/logo_" +
                                  (this.item.nomLogo as String) +
                                  ".png"))
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
              SizedBox(
                height: 25,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: leCour.revisions?.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(238, 239, 238, 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            margin: EdgeInsets.only(left: 8, right: 8),
                            padding: EdgeInsets.only(
                                left: 15, top: 10, right: 15, bottom: 0),
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    leCour.revisions?[index].datePrevu?.day
                                        .toString() as String,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 24,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    moiTronc(leCour.revisions?[index].datePrevu
                                        ?.month as int),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ));
                      },
                    ),
                  ],
                ),
              ),
              this.item.revisions?[this.item.numRevActuel as int].dateFait ==
                      null
                  ? Column(
                      children: [
                        SizedBox(
                          height: 25.0,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildPopupDialogUpdate(context, null),
                              );
                              bool result = await updateRevision(
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
                                    _buildPopupDialogUpdate(context, result),
                              );

                              await Future.delayed(Duration(seconds: 1));

                              if ((this
                                      .item
                                      .revisions?[this.item.numRevActuel as int]
                                      .datePrevu
                                      ?.difference(DateTime.now())
                                      .inHours as int) >=
                                  0) {
                                Navigator.pushNamed(context, '/calendar',
                                    arguments: (this
                                            .item
                                            .revisions?[
                                                this.item.numRevActuel as int]
                                            .datePrevu
                                            ?.difference(DateTime.now())
                                            .inDays as int) +
                                        1);
                              } else {
                                Navigator.pushNamed(context, '/calendar',
                                    arguments: this
                                        .item
                                        .revisions?[
                                            this.item.numRevActuel as int]
                                        .datePrevu
                                        ?.difference(DateTime.now())
                                        .inDays);
                              }
                            },
                            child: Text(
                              "C'est fait !",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Color.fromRGBO(151, 71, 255, 1)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ))),
                          ),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () async {
                              List<Course> leFuture = await GetCourses();
                              if (leFuture != null) {
                                print(leFuture);
                                Navigator.pushNamed(context, '/ModifRev',
                                    arguments: ModifyRev(
                                        cours: this.item, lesCours: leFuture));
                              }
                            },
                            child: Text(
                              "Je reporte cette révision",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Color.fromRGBO(60, 19, 113, 1)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ))),
                          ),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: 60,
                          child: ElevatedButton(
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

                              if ((this
                                      .item
                                      .revisions?[this.item.numRevActuel as int]
                                      .datePrevu
                                      ?.difference(DateTime.now())
                                      .inHours as int) >=
                                  0) {
                                Navigator.pushNamed(context, '/calendar',
                                    arguments: (this
                                            .item
                                            .revisions?[
                                                this.item.numRevActuel as int]
                                            .datePrevu
                                            ?.difference(DateTime.now())
                                            .inDays as int) +
                                        1);
                              } else {
                                Navigator.pushNamed(context, '/calendar',
                                    arguments: this
                                        .item
                                        .revisions?[
                                            this.item.numRevActuel as int]
                                        .datePrevu
                                        ?.difference(DateTime.now())
                                        .inDays);
                              }
                            },
                            child: Text(
                              "Supprimer",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Color.fromRGBO(151, 0, 0, 1)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ))),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 20.0,
                        ),
                        Icon(
                          Icons.check,
                          size: 70,
                          color: Color.fromRGBO(99, 59, 243, 1),
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildPopupDialogUpdate(context, null),
                              );

                              bool result = await updateRevision(
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
                                      dateFait: DateTime(0000)));

                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildPopupDialogUpdate(context, result),
                              );

                              await Future.delayed(Duration(seconds: 3));
                              print(this
                                  .item
                                  .revisions?[this.item.numRevActuel as int]
                                  .datePrevu
                                  ?.difference(DateTime.now())
                                  .inDays as int);
                              if ((this
                                      .item
                                      .revisions?[this.item.numRevActuel as int]
                                      .datePrevu
                                      ?.difference(DateTime.now())
                                      .inHours as int) >=
                                  0) {
                                Navigator.pushNamed(context, '/calendar',
                                    arguments: (this
                                            .item
                                            .revisions?[
                                                this.item.numRevActuel as int]
                                            .datePrevu
                                            ?.difference(DateTime.now())
                                            .inDays as int) +
                                        1);
                              } else {
                                Navigator.pushNamed(context, '/calendar',
                                    arguments: this
                                        .item
                                        .revisions?[
                                            this.item.numRevActuel as int]
                                        .datePrevu
                                        ?.difference(DateTime.now())
                                        .inDays);
                              }
                            },
                            child: Text(
                              "Annulé",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Color.fromRGBO(151, 71, 255, 1)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ))),
                          ),
                        ),
                      ],
                    )

              /*ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),*/
            ],
          ),
        ),
      );
    }

    return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 400, end: 0),
        duration: Duration(milliseconds: 500),
        builder: (BuildContext context, double size, Widget? child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    height: 100,
                    width: 3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: this
                                    .item
                                    .revisions?[this.item.numRevActuel as int]
                                    .dateFait ==
                                null
                            //? Color.fromRGBO(240, 240, 240, 1)
                            ? Colors.white
                            : Color.fromRGBO(146, 39, 249, 1)),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 0, right: 10, top: 25),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: this
                                  .item
                                  .revisions?[this.item.numRevActuel as int]
                                  .dateFait !=
                              null
                          ? LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                  Color.fromRGBO(146, 39, 249, 1),
                                  Color.fromRGBO(99, 59, 243, 1)
                                ])
                          : LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                  Color.fromARGB(255, 255, 255, 255),
                                  Color.fromARGB(255, 255, 255, 255)
                                ]),
                    ),
                    width: 40,
                    height: 40,
                    child: TextButton(
                      onPressed: () async {
                        if (this
                                .item
                                .revisions?[this.item.numRevActuel as int]
                                .dateFait ==
                            null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialogUpdate(context, null),
                          );
                          bool result = await updateRevision(
                              revisionInfo: new Revision(
                                  id: this
                                      .item
                                      .revisions?[this.item.numRevActuel as int]
                                      .id,
                                  datePrevu: this
                                      .item
                                      .revisions?[this.item.numRevActuel as int]
                                      .datePrevu,
                                  dateFait: DateTime.now()));
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialogUpdate(context, result),
                          );

                          await Future.delayed(Duration(seconds: 1));

                          if ((this
                                  .item
                                  .revisions?[this.item.numRevActuel as int]
                                  .datePrevu
                                  ?.difference(DateTime.now())
                                  .inHours as int) >=
                              0) {
                            Navigator.pushNamed(context, '/calendar',
                                arguments: (this
                                        .item
                                        .revisions?[
                                            this.item.numRevActuel as int]
                                        .datePrevu
                                        ?.difference(DateTime.now())
                                        .inDays as int) +
                                    1);
                          } else {
                            Navigator.pushNamed(context, '/calendar',
                                arguments: this
                                    .item
                                    .revisions?[this.item.numRevActuel as int]
                                    .datePrevu
                                    ?.difference(DateTime.now())
                                    .inDays);
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialogUpdate(context, null),
                          );

                          bool result2 = await updateRevision(
                              revisionInfo: new Revision(
                                  id: this
                                      .item
                                      .revisions?[this.item.numRevActuel as int]
                                      .id,
                                  datePrevu: this
                                      .item
                                      .revisions?[this.item.numRevActuel as int]
                                      .datePrevu,
                                  dateFait: DateTime(0000)));

                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialogUpdate(context, result2),
                          );

                          await Future.delayed(Duration(seconds: 3));
                          print(this
                              .item
                              .revisions?[this.item.numRevActuel as int]
                              .datePrevu
                              ?.difference(DateTime.now())
                              .inDays as int);
                          if ((this
                                  .item
                                  .revisions?[this.item.numRevActuel as int]
                                  .datePrevu
                                  ?.difference(DateTime.now())
                                  .inHours as int) >=
                              0) {
                            Navigator.pushNamed(context, '/calendar',
                                arguments: (this
                                        .item
                                        .revisions?[
                                            this.item.numRevActuel as int]
                                        .datePrevu
                                        ?.difference(DateTime.now())
                                        .inDays as int) +
                                    1);
                          } else {
                            Navigator.pushNamed(context, '/calendar',
                                arguments: this
                                    .item
                                    .revisions?[this.item.numRevActuel as int]
                                    .datePrevu
                                    ?.difference(DateTime.now())
                                    .inDays);
                          }
                        }
                      },
                      child: Center(
                          child: Icon(
                        Icons.check,
                        color: this
                                    .item
                                    .revisions?[this.item.numRevActuel as int]
                                    .dateFait !=
                                null
                            ? Colors.white
                            : Color.fromARGB(255, 214, 214, 214),
                      )),
                      style: ButtonStyle(
                          backgroundColor: this
                                      .item
                                      .revisions?[this.item.numRevActuel as int]
                                      .dateFait !=
                                  null
                              ? MaterialStatePropertyAll<Color>(
                                  Color.fromRGBO(151, 71, 255, 1))
                              : MaterialStatePropertyAll<Color>(
                                  Color.fromARGB(255, 255, 255, 255)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ))),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 5 + size, bottom: 5),
                width: MediaQuery.of(context).size.width * 0.7,
                height: 90,
                child: TextButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )),
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.white)),

                    //backgroundColor: MaterialStatePropertyAll<Color>(Color.fromRGBO(240, 240, 240, 1))),
                    onPressed: () {
                      /*showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopupDialog(context, this.item as Course),
                      );*/
                      item.revisions!.sort((a, b) => (a.datePrevu as DateTime)
                          .compareTo(b.datePrevu as DateTime));
                      Navigator.pushNamed(context, '/CoursePage',
                          arguments: this.item);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20, right: 10),
                          height: 50,
                          width: 3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color.fromRGBO(146, 39, 249, 1),
                                    Color.fromRGBO(99, 59, 243, 1)
                                  ])),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 3, right: 10),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color.fromRGBO(146, 39, 249, 1),
                                    Color.fromRGBO(99, 59, 243, 1)
                                  ]),
                            ),
                            width: 50,
                            height: 50,
                            child: this.item.nomLogo != ""
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        (this.item.nomLogo as String),
                                        width: 30,
                                        height: 30,
                                        semanticsLabel: 'Acme Logo',
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                overflow: TextOverflow.ellipsis,
                                this.item.matiere as String,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.black),
                              ),
                              Text(
                                overflow: TextOverflow.ellipsis,
                                this.item.cours as String,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
              ),
            ],
          );
        });
  }
}
