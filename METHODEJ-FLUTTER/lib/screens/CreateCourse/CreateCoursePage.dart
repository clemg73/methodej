import 'dart:convert';

import 'package:flutter/cupertino.dart';
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

class CreateCourse extends StatefulWidget {
  CreateCourse({this.courseArguments});
  final courseArguments;
  @override
  State<CreateCourse> createState() =>
      _CreateCourseState(courseArguments: this.courseArguments);
}

class _CreateCourseState extends State<CreateCourse> {
  _CreateCourseState({this.courseArguments});
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

  Shema shemaSelectionne = new Shema(id: 9, name: "Schema 1", jours: "1");

  PageController _pageController = PageController(initialPage: 0);

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
      shemaSelectionne = (m as CourseArguments).shema as Shema ??
          new Shema(id: 9, name: "Schema 1", jours: "1");
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
      shemaSelectionne = new Shema(id: 9, name: "Schema 1", jours: "1");
    }

    print("nomLogo:" + nomLogo + "//");
  }

  Widget build(BuildContext context) {
    Future<bool> getUserCountNumbersCoursesMonth() async {
      Uri url = Uri.parse(urlDB +
          "api/courses/countByMonth/user/" +
          (globals.idUser as int).toString());

      final response = await http.get(url);
      return int.parse(response.body) < globals.nbCoursesMaxFreeAccount;
    }

    Future<bool> createCourse({required Course courseInfo}) async {
      try {
        print(courseInfo.courseToJson());
        Response response = await Dio().post(
          urlDB + "api/courses",
          data: courseInfo.courseToJson(),
        );

        print('Course created: ${response.data}');
        globals.dataChange = true;
        globals.countChange = true;

        return true;

        //retrievedCourse = Course.fromJson(response.data);
      } catch (e) {
        print('Error creating course: $e');
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

    _pageController.addListener(() {
      if (_pageController.page?.round() == _pageController.page) {
        setState(() {});
      }
    });

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
                                "Cours créé",
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
                                'Ajouter\nun cours',
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
                        maxLength: 30,
                        decoration: InputDecoration(
                            hintText: 'Matière',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none),
                            filled: true,
                            fillColor: Colors.white),
                        validator: (value) => value!.length > 30
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
                        maxLength: 30,
                        decoration: InputDecoration(
                            hintText: 'Cours',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none),
                            filled: true,
                            fillColor: Colors.white),
                        validator: (value) => value!.length > 30
                            ? "Nom du cours trop grand"
                            : null,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 12.0),
                              width: MediaQuery.of(context).size.width * 0.67,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(shemaSelectionne.name as String,
                                      style: TextStyle(color: Colors.black)),
                                  Row(
                                    children: [
                                      for (var element in shemaSelectionne
                                          .toListInt() as List<int>)
                                        Container(
                                          margin: EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                              color:
                                                  Color.fromRGBO(18, 0, 40, 1),
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
                            ),
                            Container(
                              width: 70,
                              height: 70,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/selectShemaArg',
                                        arguments: new CourseArguments(
                                            matiere:
                                                matiereController.value.text,
                                            cours: coursController.value.text,
                                            shema: shemaSelectionne,
                                            nomLogo: nomLogo));
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll<Color>(
                                              Color.fromRGBO(18, 0, 40, 1)),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14.0),
                                      ))),
                                  child: Icon(Icons.arrow_forward)),
                            ),
                          ],
                        )),
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
                                  matiere: matiereController.value.text,
                                  cours: coursController.value.text,
                                  shema: shemaSelectionne,
                                  nomLogo: nomLogo,
                                  page: "create"));
                        },
                        child: Text(
                          'Plus de logos',
                          style: TextStyle(
                              color: Color.fromRGBO(18, 0, 40, 1),
                              decoration: TextDecoration.underline),
                        ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    FutureBuilder<bool>(
                        future: getUserCountNumbersCoursesMonth(),
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? snapshot.data as bool
                                  ? Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      height: 60,
                                      child: TextButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() => loading = true);
                                            loading = true;
                                            var nomMatiere =
                                                matiereController.value.text;
                                            var nomCours =
                                                coursController.value.text;
                                            List<Revision> laListe =
                                                <Revision>[];
                                            shemaSelectionne
                                                .toListInt()
                                                ?.forEach((element) {
                                              laListe.add(Revision(
                                                  datePrevu: DateTime.now().add(
                                                      Duration(
                                                          days: element))));
                                            });
                                            Course leCours = Course(
                                                matiere: nomMatiere,
                                                cours: nomCours,
                                                user: null,
                                                revisions: laListe,
                                                dateCreation: DateTime.now(),
                                                nomLogo: nomLogo);
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  _buildPopupDialog(
                                                      context, null),
                                            );
                                            bool result = await createCourse(
                                                courseInfo: leCours);
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  _buildPopupDialog(
                                                      context, result),
                                            );
                                            await Future.delayed(
                                                Duration(seconds: 1));
                                            Navigator.pushNamed(
                                              context,
                                              '/calendar0',
                                            );
                                          }
                                        },
                                        child: Text(
                                          "Ajouter",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll<Color>(
                                                    Color.fromRGBO(
                                                        18, 0, 40, 1)),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ))),
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          height: 60,
                                          child: TextButton(
                                            onPressed: () async {},
                                            child: Text(
                                              "Ajouter",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll<
                                                            Color>(
                                                        Color.fromARGB(
                                                            69, 18, 0, 40)),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ))),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: Text(
                                              "Vous avez dépassé le nombre d'ajout de cours par mois qu'un compte gratuit offre",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w600),
                                              textAlign: TextAlign.center,
                                            )),
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  '/premium',
                                                );
                                              },
                                              child: Text(
                                                "Passer à un compte premium",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.w600,
                                                    decoration: TextDecoration
                                                        .underline),
                                                textAlign: TextAlign.center,
                                              ),
                                            ))
                                      ],
                                    )
                              : Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  height: 60,
                                  child: TextButton(
                                    onPressed: () async {},
                                    child: CupertinoActivityIndicator(
                                      color: Colors.white,
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll<Color>(
                                                Color.fromARGB(255, 18, 0, 40)),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ))),
                                  ),
                                );
                        }),
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
