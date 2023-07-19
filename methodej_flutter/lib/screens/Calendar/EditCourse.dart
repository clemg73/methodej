import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../common/constants.dart';
import '../../common/loading.dart';
import '../../models/CourseArguments.dart';
import '../../models/Revision.dart';
import '../../models/course.dart';
import '../../models/shema.dart';
import 'package:http/http.dart' as http;
import '../../common/globals.dart' as globals;
import 'package:dio/dio.dart';

import '../Calendar/CalendarPage.dart';

class EditCourse extends StatefulWidget {
  EditCourse({this.courseArguments});
  final courseArguments;
  @override
  State<EditCourse> createState() =>
      _EditCourseState(courseArguments: this.courseArguments);
}

class _EditCourseState extends State<EditCourse> {
  _EditCourseState({this.courseArguments});
  final courseArguments;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String error = '';

  String nomLogo = '';
  List<String> logoList = [
    'images/logo/bio.svg',
    'images/logo/math.svg',
    'images/logo/reseau.svg',
    'images/logo/code.svg',
    'images/logo/basketball-outline.svg'
  ];

  final matiereController = TextEditingController();
  final coursController = TextEditingController();

  @override
  void dispose() {
    matiereController.dispose();
    coursController.dispose();

    super.dispose();
  }

  initState() {
    var m = this.courseArguments;
    if (m != null) {
      nomLogo = (m as CourseArguments).nomLogo as String ?? "";
      matiereController.text = (m as CourseArguments).matiere as String ?? "";
      coursController.text = (m as CourseArguments).cours as String ?? "";

      nomLogo != logoList[0] &&
              nomLogo != logoList[1] &&
              nomLogo != logoList[2] &&
              nomLogo != logoList[3] &&
              nomLogo != ""
          ? logoList[0] = nomLogo
          : logoList[0] = logoList[0];
    } else {
      nomLogo = "";
      matiereController.text = "";
      coursController.text = "";
    }
  }

  Widget build(BuildContext context) {
    Future<bool> editCourse({required Course courseInfo}) async {
      try {
        print(courseInfo.courseToJsonForEdit());
        Response response = await Dio().put(
          urlDB + "api/courses",
          data: courseInfo.courseToJsonForEdit(),
        );

        print('Course edited: ${response.data}');
        globals.dataChange = true;
        globals.countChange = true;

        return true;
      } catch (e) {
        print('Error editing course: $e');
        return false;
      }
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

    Widget _buildPopupDialog(BuildContext context, bool? result) {
      return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            padding: const EdgeInsets.only(
                right: 12.0, left: 12.0, top: 40, bottom: 12),
            width: 300,
            height: 300,
            child: /*CircularProgressIndicator()*/
                result == null
                    ? Center(
                        child: Container(
                        child: Loading(size: 100),
                        width: MediaQuery.of(context).size.width * 0.2,
                      ))
                    : result
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Cours modifié",
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
                                    color: Colors.white),
                              ),
                            ],
                          ),
          ));
    }

    logoChoice(String name) {
      return Column(children: [
        Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Color.fromRGBO(18, 0, 40, 1)),
            width: 60,
            height: 60,
            margin: EdgeInsets.only(left: 5, right: 5),
            child: GestureDetector(
              onTap: () {
                nomLogo = name;
                print(nomLogo);
                setState(() {});
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    name,
                    width: 35,
                    height: 35,
                    semanticsLabel: 'Acme Logo',
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ],
              ),
            )),
        SizedBox(
          height: 5,
        ),
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: nomLogo != ''
                  ? name == nomLogo
                      ? Color.fromRGBO(18, 0, 40, 1)
                      : Color.fromRGBO(242, 244, 255, 1)
                  : Color.fromRGBO(242, 244, 255, 1)),
        )
      ]);
    }

    Widget corp = Form(
        key: _formKey,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 70,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
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
                              Text(
                                'Modifier\nle cours',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 32,
                                    color: Colors.black),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        controller: matiereController,
                        maxLength: 18,
                        decoration: InputDecoration(
                            hintText: 'Matière',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none),
                            filled: true,
                            fillColor: Colors.white),
                        validator: (value) => value!.length > 18
                            ? "Nom de la matière trop grand"
                            : null,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        controller: coursController,
                        maxLength: 18,
                        decoration: InputDecoration(
                            hintText: 'Cours',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none),
                            filled: true,
                            fillColor: Colors.white),
                        validator: (value) => value!.length > 18
                            ? "Nom du cours trop grand"
                            : null,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            nomLogo != '' &&
                                    nomLogo != logoList[1] &&
                                    nomLogo != logoList[2] &&
                                    nomLogo != logoList[3]
                                ? logoChoice(nomLogo)
                                : logoChoice(logoList[0]),
                            logoChoice(logoList[1]),
                            logoChoice(logoList[2]),
                            logoChoice(logoList[3])
                          ]),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/selectLogo',
                              arguments: new CourseArguments(
                                  id: (courseArguments as CourseArguments).id,
                                  matiere: matiereController.value.text,
                                  cours: coursController.value.text,
                                  nomLogo: nomLogo,
                                  page: "edit"));
                        },
                        child: Text(
                          'Plus de logos',
                          style: TextStyle(color: Color.fromRGBO(18, 0, 40, 1)),
                        ))
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => loading = true);
                            loading = true;
                            var nomMatiere = matiereController.value.text;
                            var nomCours = coursController.value.text;
                            List<Revision> laListe = <Revision>[];

                            Course leCours = Course(
                                id: (courseArguments as CourseArguments).id,
                                matiere: nomMatiere,
                                cours: nomCours,
                                user: null,
                                revisions: [],
                                dateCreation: DateTime.now(),
                                nomLogo: nomLogo);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildPopupDialog(context, null),
                            );
                            bool result = await editCourse(courseInfo: leCours);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildPopupDialog(context, result),
                            );
                            await Future.delayed(Duration(seconds: 1));
                            Navigator.pushNamed(
                              context,
                              '/calendar0',
                            );
                          }
                        },
                        child: Text(
                          "Modifier",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Color.fromRGBO(18, 0, 40, 1)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ))),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ],
            ),
          ),
        ));

    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 244, 255, 1),
      //resizeToAvoidBottomInset: false,
      body: corp,
    );
  }
}
