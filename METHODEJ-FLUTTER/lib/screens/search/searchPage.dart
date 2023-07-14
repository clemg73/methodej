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
import '../Calendar/CourseItem.dart';
import '../CreateCourse/CreateCoursePage.dart';
import 'searchCourseItem.dart';

class Search extends StatefulWidget {
  Search();
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  _SearchState();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String error = '';

  final searchController = TextEditingController();

  List<Course> products = <Course>[];

  late String search;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    search = '';
  }

  Widget build(BuildContext context) {
    Future<List<Course>> fetchCourses({required String search}) async {
      Uri url = Uri.parse(urlDB +
          "api/courses/search/" +
          search +
          '&' +
          (globals.idUser as int).toString());
      final response = await http.get(url);
      List jsonMap = jsonDecode(response.body);
      List<Course> toutesLesCourses = <Course>[];
      jsonMap.map((m) => new Course.fromJson(m)).forEach((element) {
        toutesLesCourses.add(element);
      });
      return toutesLesCourses;
    }

    Route _createRoute() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => CreateCourse(
          courseArguments: null,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
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

    Widget corp = Form(
        key: _formKey,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(children: [
                  Text(
                    'Rechercher',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 32,
                        color: Colors.black),
                  )
                ]),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  controller: searchController,
                  onChanged: (text) async {
                    /*products = <Course>[];
                    List<Course> temp = await fetchCourses(search: text);
                    print('-------');
                    products = temp;
                    temp.forEach((element) {
                      print(element.courseToJson());
                    });*/

                    search = text;
                    setState(() => {});
                  },
                  decoration: InputDecoration(
                      hintText: 'Votre recherche',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Color.fromARGB(255, 255, 255, 255)),
                  validator: (value) =>
                      value!.isEmpty ? "Entre une recherche" : null,
                ),
              ),
              /*Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 60,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      var string = searchController.value.text;
                      List<Course> temp = await fetchCourses(search: string);
                      setState(() => products = temp);
                    }
                  },
                  child: Text(
                    "Rechercher",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                          Color.fromRGBO(18, 0, 40, 1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ))),
                ),
              ),*/
              SizedBox(
                height: 50,
              )
            ],
          ),
        ));

    Widget coursesSection = SizedBox(
      child: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.only(top: 40, bottom: 10),
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 100),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      if (products.length != 0 && products.length != null) {
                        return Container(
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 90,
                          child: TextButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  )),
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          Color.fromARGB(255, 255, 255, 255))),
                              onPressed: () {
                                products[index].revisions!.sort((a, b) =>
                                    (a.datePrevu as DateTime)
                                        .compareTo(b.datePrevu as DateTime));
                                Navigator.pushNamed(context, '/CoursePage',
                                    arguments: products[index]);
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 20, right: 10),
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
                                    margin: const EdgeInsets.only(
                                        left: 3, right: 10),
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
                                      child: products[index].nomLogo != ""
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  (products[index].nomLogo
                                                      as String),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        products[index].matiere as String,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        products[index].cours as String,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12,
                                            color: Colors.black),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                        );
                      } else {
                        return Text("Pas de résultats");
                      }
                    },
                  )))
        ],
      ),
    );

    Widget coursesSectionFutur = FutureBuilder<List<Course>>(
        future: fetchCourses(search: search),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? (snapshot.data as List<Course>).isNotEmpty
                  ? Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 100),
                        itemCount: (snapshot.data as List<Course>).length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(top: 5, bottom: 5),
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 90,
                            child: TextButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    )),
                                    backgroundColor: MaterialStatePropertyAll<
                                            Color>(
                                        Color.fromARGB(255, 255, 255, 255))),
                                onPressed: () {
                                  (snapshot.data as List<Course>)[index]
                                      .revisions!
                                      .sort((a, b) => (a.datePrevu as DateTime)
                                          .compareTo(b.datePrevu as DateTime));
                                  Navigator.pushNamed(context, '/CoursePage',
                                      arguments: (snapshot.data
                                          as List<Course>)[index]);
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 20, right: 10),
                                      height: 50,
                                      width: 3,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Color.fromRGBO(146, 39, 249, 1),
                                                Color.fromRGBO(99, 59, 243, 1)
                                              ])),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 3, right: 10),
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
                                        child: (snapshot.data
                                                        as List<Course>)[index]
                                                    .nomLogo !=
                                                ""
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    ((snapshot.data as List<
                                                            Course>)[index]
                                                        .nomLogo as String),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          (snapshot.data as List<Course>)[index]
                                              .matiere as String,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          (snapshot.data as List<Course>)[index]
                                              .cours as String,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 12,
                                              color: Colors.black),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                          );
                        },
                      ),
                    )
                  : Text('Aucun résultat pour votre recherche')
              : Center(child: CircularProgressIndicator());
        });

    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 244, 255, 1),
      resizeToAvoidBottomInset: false,
      body: Column(children: [
        SizedBox(
          height: 90,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/calendar', arguments: 0);
                },
                child: Icon(Icons.close),
              ),
            ],
          ),
        ),
        corp,
        search != '' ? coursesSectionFutur : Text("Rechercher un cours"),
        SizedBox(
          height: 120,
        )
      ]),
    );
  }
}
