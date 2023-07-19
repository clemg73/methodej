import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/services.dart';

import 'package:flutter_svg/svg.dart';
import 'package:methodej/screens/Profil/ProfilPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeleton_text/skeleton_text.dart';

import 'package:flutter/material.dart';
import 'package:polygon/polygon.dart';

import '../../common/constants.dart';
import '../../models/course.dart';
import '../CreateCourse/CreateCoursePage.dart';
import 'CalendarPage.dart';
import 'day_view.dart';
import 'package:http/http.dart' as http;
import '../../common/globals.dart' as globals;
import 'dart:math';
import 'package:animator/animator.dart';
import 'package:skeleton_text/skeleton_text.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key, required this.page}) : super(key: key);
  final page;

  @override
  State<Calendar> createState() => _CalendarState(page: page);
}

class _CalendarState extends State<Calendar>
    with SingleTickerProviderStateMixin {
  _CalendarState({required this.page});
  double taille = 30;
  late AnimationController _controllerAnim;
  var page;
  PageController _pageController = PageController(initialPage: 4);
  PageController _pageControllerCount =
      PageController(initialPage: globals.lastPage_countController);

  Widget pageViewDay = Container();
  Widget graph = Container(height: 100, width: 100, color: Colors.red);
  Widget days = Container();

  late Future<List<double>> nbRevToPourcent;

  int monthSelected = DateTime.now().month;
  int yearSelected = DateTime.now().year;

  int pageRelatif = globals.lastPage_countController;

  bool daysSlideBar = true;

  @override
  void initState() {
    bool load = false;

    monthSelected = DateTime.now().month + globals.lastPage_countController - 2;

    if (monthSelected < 1) {
      monthSelected = 12 + monthSelected;
      yearSelected--;
    }
    if (monthSelected > 12) {
      monthSelected -= 12;
      yearSelected++;
    }

    _controllerAnim = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..repeat();

    //_pageController = PageController(initialPage: 1);

    Widget profileSection = Container(
        padding: const EdgeInsets.only(top: 25, right: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('images/lake.jpg'),
            )
          ],
        ));

    Future<List> loadFunction() async {
      //eviter de requeter tout le temps
      print("requete");
      Uri url = Uri.parse(
          urlDB + "api/courses/user/" + (globals.idUser as int).toString());
      String token = globals.token;

      final headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      };
      final response = await http.get(url, headers: headers);
      List jsonMap2 = jsonDecode(response.body);
      return jsonMap2;
    }

    // Calcule du nombre de jours avant et apres la date d'aujourd'hui
    List<int> nbDayCalc() {
      int nbDayAvant = 0;
      int nbDayApres = 0;

      for (int nb = -2; nb <= 2; nb++) {
        int yearSelect = DateTime.now().year;
        int monthSelect = DateTime.now().month + nb;

        if (monthSelect <= 0) {
          monthSelect = 12 + monthSelect;
          yearSelect--;
        }
        if (monthSelect > 12) {
          monthSelect -= 12;
          yearSelect++;
        }

        int nbJourForThisMonth = 0;

        if (DateTime(yearSelect, monthSelect, 29).day < 10) {
          nbJourForThisMonth = 28;
        } else if (DateTime(yearSelect, monthSelect, 30).day < 10) {
          nbJourForThisMonth = 29;
        } else if (DateTime(yearSelect, monthSelect, 31).day < 10) {
          nbJourForThisMonth = 30;
        } else {
          nbJourForThisMonth = 31;
        }

        if (nb > 0) {
          nbDayApres += nbJourForThisMonth;
        } else if (nb < 0) {
          nbDayAvant += nbJourForThisMonth;
        } else {
          nbDayApres += nbJourForThisMonth - DateTime.now().day;
          nbDayAvant += DateTime.now().day - 1;
        }
      }

      List<int> liste = <int>[];
      print("zzzzzz" + (-nbDayAvant).toString());
      liste.add(-nbDayAvant);
      liste.add(nbDayApres);
      return liste;
    }

    _pageController = PageController(
        initialPage: globals.lastPage_coursesController != null
            ? globals.lastPage_coursesController as int
            : -nbDayCalc()[0]);

    Future<List<int>> countRev() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (globals.countChange) {
        int min = nbDayCalc()[0];
        int max = nbDayCalc()[1];

        final uri = Uri.http(
            "methodej.azurewebsites.net",
            "/api/courses/count/user/" +
                (globals.idUser as int).toString() +
                "/" +
                min.toString() +
                "/" +
                max.toString());

        String token = globals.token;
        final headers = {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          'Connection': 'keep-alive',
          'Authorization': 'Bearer $token',
        };

        final response = await http.get(
          uri,
          headers: headers,
        );
        String reponse = response.body;
        print("reponse: " + jsonDecode(reponse).toString());
        reponse = reponse.replaceAll('[', '');
        reponse = reponse.replaceAll(']', '');

        await prefs.setString('count', reponse);

        List<int> chaine = reponse.split(',').map((e) => int.parse(e)).toList();
        print("longueur liste reponse count" + chaine.length.toString());

        globals.countChange = false;

        return chaine;
      } else {
        List<int> nbCount = <int>[];

        await Future.delayed(
            Duration(milliseconds: 1),
            () => nbCount = prefs
                .getString('count')
                .toString()
                .split(',')
                .map((e) => int.parse(e))
                .toList());
        return nbCount;
      }
    }

    Future<List<double>> countRevToPourcent() async {
      List<int> liste = await countRev();
      int max = liste.reduce(math.max);
      List<double> listeD = <double>[];
      liste.forEach((element) {
        max != 0 ? listeD.add(element * 100 / max) : listeD.add(0);
      });
      return listeD;
    }

    nbRevToPourcent = countRevToPourcent();

    Future<List<Course>> fetchCourses(int num, List? jsonMap) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (globals.dataChange) {
        print("taille: " + (jsonMap as List).length.toString());

        List<Course> toutesLesCoursesFaites = <Course>[];
        List<Course> toutesLesCoursesNonFaites = <Course>[];
        int compte = 0;
        jsonMap?.map((m) => new Course.fromJson(m)).forEach((element) {
          int i = 0;
          element.revisions?.forEach((element2) {
            //revision sélectionner par rapport a la page
            DateTime dateVoulu = DateTime(
                DateTime.now().add(Duration(days: num)).year,
                DateTime.now().add(Duration(days: num)).month,
                DateTime.now().add(Duration(days: num)).day);
            DateTime dateElement = DateTime(
                element2.datePrevu?.year as int,
                element2.datePrevu?.month as int,
                element2.datePrevu?.day as int);
            if (dateVoulu == dateElement) {
              element.numRevActuel = i;
              if (element2.dateFait != null) {
                toutesLesCoursesFaites.add(element);
              } else {
                toutesLesCoursesNonFaites.add(element);
              }
            }
            i++;
          });
          compte++;
        });

        List<Course> ensemble =
            toutesLesCoursesFaites + toutesLesCoursesNonFaites;

        String json = '[';
        ensemble.forEach((element) {
          json += element.courseToJsonForPref() + ',';
        });
        if (json.length > 3) json = json.substring(0, json.length - 1);
        json += ']';

        await prefs.setString('courses' + (num).toString(), json);

        globals.dataChange = false;

        return toutesLesCoursesFaites + toutesLesCoursesNonFaites;
      } else {
        List<Course> courses = <Course>[];

        Future.delayed(
            Duration(milliseconds: 1),
            jsonDecode(prefs.getString('courses' + (num).toString()).toString())
                .map((m) => new Course.fromJson(m))
                .forEach((element) {
              element != Course() && (element as Course).cours != null
                  ? print('eee')
                  : print("tout null");
              element != Course() && (element as Course).cours != null
                  ? courses.add(element)
                  : null;
            }));
        return courses;
      }
    }

    DayCalc(int addDay) {
      DateTime dateCalc = DateTime.now().add(Duration(days: addDay));
      switch (dateCalc.weekday) {
        case 1:
          return "Lun";
          break;
        case 2:
          return "Mar";
          break;
        case 3:
          return "Mer";
          break;
        case 4:
          return "Jeu";
          break;
        case 5:
          return "Ven";
          break;
        case 6:
          return "Sam";
          break;
        case 7:
          return "Dim";
          break;
        default:
          return "Lun";
          break;
      }
    }

    pageViewDay = globals.dataChange
        ? Expanded(
            child: FutureBuilder<List>(
                future: loadFunction(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? PageView(
                          controller: _pageController,
                          children: <Widget>[
                            for (int i = nbDayCalc()[0];
                                i <= nbDayCalc()[1];
                                i++)
                              DayView(
                                  num: (i).toString(),
                                  products:
                                      fetchCourses(i, snapshot.data as List)),
                          ],
                        )
                      : Text("");
                }),
          )
        : Expanded(
            child: PageView(
              controller: _pageController,
              children: <Widget>[
                for (int i = nbDayCalc()[0]; i <= nbDayCalc()[1]; i++)
                  DayView(num: (i).toString(), products: fetchCourses(i, null)),
              ],
            ),
          );
  }

  Widget build(BuildContext context) {
    int nbDaysCalc = 0;

    _pageController.addListener(() {
      if (_pageController.page?.round() == _pageController.page) {
        globals.lastPage_coursesController =
            (_pageController.page as double).toInt();

        setState(() {});
      }
    });

    DayCalcEntier(DateTime day) {
      switch (day.weekday) {
        case 1:
          return "Lundi";
          break;
        case 2:
          return "Mardi";
          break;
        case 3:
          return "Mercredi";
          break;
        case 4:
          return "Jeudi";
          break;
        case 5:
          return "Vendredi";
          break;
        case 6:
          return "Samedi";
          break;
        case 7:
          return "Dimanche";
          break;
        default:
          return "Lundi";
          break;
      }
    }

    Container daysOne(int nb, List<double> list) {
      int yearSelect = DateTime.now().year;
      int monthSelect = DateTime.now().month + nb;
      int nbDaysMax = 0;

      while (monthSelect <= 0) {
        monthSelect = 12 + monthSelect;
        yearSelect--;
      }
      while (monthSelect > 12) {
        monthSelect -= 12;
        yearSelect++;
      }

      if (DateTime(yearSelect, monthSelect, 29).day < 10) {
        nbDaysMax = 28;
      } else if (DateTime(yearSelect, monthSelect, 30).day < 10) {
        nbDaysMax = 29;
      } else if (DateTime(yearSelect, monthSelect, 31).day < 10) {
        nbDaysMax = 30;
      } else {
        nbDaysMax = 31;
      }
      nbDaysCalc += nbDaysMax;

      int nbDaysCalc2 = nbDaysCalc;

      PageController pageController = PageController(
          initialPage: globals.lastPage_countController == nb + 2
              ? globals.lastPage_oneCountController != null
                  ? globals.lastPage_oneCountController as int
                  : DateTime.now().day - 1
              : nb == 0
                  ? DateTime.now().day - 1
                  : 0,
          viewportFraction: 0.22);

      pageController.addListener(() {
        if (pageController.page?.round() == pageController.page) {
          HapticFeedback.mediumImpact();
          _pageController.animateToPage(
              nbDaysCalc2 - nbDaysMax + ((pageController.page?.toInt()) ?? 1),
              duration: Duration(milliseconds: 300),
              curve: Curves.linear);
          globals.lastPage_oneCountController =
              (pageController.page as double).toInt();
        }
      });

      return Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        child: PageView(
          controller: pageController,
          scrollDirection: Axis.horizontal,
          children: [
            for (int i = 1; i <= nbDaysMax; i++)
              Container(
                height: 100,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          color: Color.fromRGBO(242, 244, 255, 1)),
                      width: 70,
                      height: 90,
                      margin: const EdgeInsets.all(7),
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(13),
                                  bottomRight: Radius.circular(13),
                                ),
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color.fromRGBO(146, 39, 249, 0.9),
                                      Color.fromRGBO(99, 59, 243, 0.9)
                                    ]),
                              ),
                              height: 90 *
                                  (list[nbDaysCalc2 - nbDaysMax + i - 1] /
                                      100)),
                          TextButton(
                              onPressed: (() {
                                /*_pageController.animateToPage(
                                    nbDaysCalc2 - nbDaysMax + i - 1,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.linear);*/
                                pageController.animateToPage((i - 1),
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.linear);
                                HapticFeedback.mediumImpact();

                                _pageController.animateToPage(
                                    nbDaysCalc2 -
                                        nbDaysMax +
                                        ((pageController.page?.toInt()) ?? 1),
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.linear);
                                globals.lastPage_oneCountController =
                                    (pageController.page as double).toInt();
                              }),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    i.toString(),
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 27),
                                  ),
                                  Text(
                                    DayCalcEntier(
                                        DateTime(yearSelect, monthSelect, i)),
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 10),
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    }

    String getMonth(int month) {
      switch (month) {
        case 1:
          return "Janvier";
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
          return "erreur";
          break;
      }
    }

    days = FutureBuilder<List<double>>(
        future: nbRevToPourcent,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? GestureDetector(
                  onPanUpdate: (details) {
                    if (details.delta.dy > 0) {
                      setState(() {
                        daysSlideBar = false;
                      });
                    }
                    if (details.delta.dy < 0) {
                      setState(() {
                        daysSlideBar = true;
                      });
                    }
                  },
                  child: Container(
                    height: daysSlideBar ? 240 : 130,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                    child: Container(
                      margin: EdgeInsets.only(top: 30), // ***
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40)),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 210, 210, 210),
                            blurRadius: 20,
                            spreadRadius: 2,
                          )
                        ],
                      ),

                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                        onPressed: (() {
                                          if (pageRelatif > 0) {
                                            monthSelected--;

                                            if (monthSelected <= 0) {
                                              monthSelected = 12;
                                            }

                                            _pageControllerCount
                                                .animateToPage(
                                                    (((_pageControllerCount.page
                                                                as double)
                                                            .toInt()) -
                                                        1),
                                                    duration: Duration(
                                                        milliseconds: 300),
                                                    curve: Curves.linear)
                                                .then((value) => globals
                                                        .lastPage_countController =
                                                    (_pageControllerCount.page
                                                            as double)
                                                        .toInt());
                                            globals.lastPage_oneCountController =
                                                0;
                                            pageRelatif--;

                                            setState(() {});
                                          }
                                        }),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.arrow_back,
                                              color: pageRelatif > 0
                                                  ? Color.fromARGB(255, 0, 0, 0)
                                                  : Colors.grey,
                                              size: 20,
                                            ),
                                            Text(
                                              (monthSelected - 1) > 0
                                                  ? " " +
                                                      getMonth(
                                                          monthSelected - 1)
                                                  : " " + getMonth(12),
                                              style: TextStyle(
                                                  color: pageRelatif > 0
                                                      ? Color.fromARGB(
                                                          255, 0, 0, 0)
                                                      : Colors.grey,
                                                  fontWeight: FontWeight.w400),
                                            )
                                          ],
                                        )),
                                    Text(getMonth(monthSelected),
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontWeight: FontWeight.w800,
                                            fontSize: 25)),
                                    TextButton(
                                        onPressed: (() {
                                          if (pageRelatif < 4) {
                                            monthSelected++;
                                            if (monthSelected > 12) {
                                              monthSelected = 1;
                                            }

                                            _pageControllerCount
                                                .animateToPage(
                                                    (((_pageControllerCount.page
                                                                as double)
                                                            .toInt()) +
                                                        1),
                                                    duration: Duration(
                                                        milliseconds: 300),
                                                    curve: Curves.linear)
                                                .then((value) => globals
                                                        .lastPage_countController =
                                                    (_pageControllerCount.page
                                                            as double)
                                                        .toInt());
                                            globals.lastPage_oneCountController =
                                                0;

                                            pageRelatif++;

                                            setState(() {});
                                          }
                                        }),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              (monthSelected + 1) <= 12
                                                  ? getMonth(
                                                          monthSelected + 1) +
                                                      " "
                                                  : getMonth(1),
                                              style: TextStyle(
                                                  color: pageRelatif < 4
                                                      ? Color.fromARGB(
                                                          255, 0, 0, 0)
                                                      : Colors.grey,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Icon(
                                              Icons.arrow_forward,
                                              color: pageRelatif < 4
                                                  ? Color.fromARGB(255, 0, 0, 0)
                                                  : Colors.grey,
                                              size: 20,
                                            ),
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            daysSlideBar
                                ? Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 130,
                                    child: PageView(
                                      controller: _pageControllerCount,
                                      physics: NeverScrollableScrollPhysics(),
                                      children: <Widget>[
                                        daysOne(
                                            -2, snapshot.data as List<double>),
                                        daysOne(
                                            -1, snapshot.data as List<double>),
                                        daysOne(
                                            0, snapshot.data as List<double>),
                                        daysOne(
                                            1, snapshot.data as List<double>),
                                        daysOne(
                                            2, snapshot.data as List<double>),
                                      ],
                                    ))
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
                  height: daysSlideBar ? 240 : 130,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Container(
                      margin: EdgeInsets.only(top: 30), // ***
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40)),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 210, 210, 210),
                            blurRadius: 20,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SkeletonAnimation(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Color.fromRGBO(242, 244, 255, 1),
                                      ),
                                      width: 50,
                                      height: 20,
                                    ),
                                  ),
                                  SkeletonAnimation(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Color.fromRGBO(242, 244, 255, 1),
                                      ),
                                      width: 100,
                                      height: 20,
                                    ),
                                  ),
                                  SkeletonAnimation(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Color.fromRGBO(242, 244, 255, 1),
                                      ),
                                      width: 50,
                                      height: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SkeletonAnimation(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13),
                                      color: Color.fromRGBO(242, 244, 255, 1),
                                    ),
                                    width: 70,
                                    height: 90,
                                  ),
                                ),
                                SkeletonAnimation(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13),
                                      color: Color.fromRGBO(242, 244, 255, 1),
                                    ),
                                    width: 70,
                                    height: 90,
                                  ),
                                ),
                                SkeletonAnimation(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13),
                                      color: Color.fromRGBO(242, 244, 255, 1),
                                    ),
                                    width: 70,
                                    height: 90,
                                  ),
                                ),
                                SkeletonAnimation(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13),
                                      color: Color.fromRGBO(242, 244, 255, 1),
                                    ),
                                    width: 70,
                                    height: 90,
                                  ),
                                ),
                                SkeletonAnimation(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13),
                                      color: Color.fromRGBO(242, 244, 255, 1),
                                    ),
                                    width: 70,
                                    height: 90,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )));
        });

    Route _settingsRoute() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => Profil(),
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

    Route _reloadRoute() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            Calendar(page: 0),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 0.0);
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

    Widget header = Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        GestureDetector(
            onTap: () {
              Navigator.of(context).push(_settingsRoute());
            },
            child: Icon(Icons.settings)),
        GestureDetector(
            onTap: () {
              globals.countChange = true;
              globals.dataChange = true;
              Navigator.of(context).push(_reloadRoute());
            },
            child: Icon(Icons.sync)),
      ]),
    );

    Widget pointGris = Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
        width: 8,
        height: 8,
      ),
    );

    Widget pointBlanc = Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        width: 8,
        height: 8,
      ),
    );

    Row pointsRow(int num) {
      Row laRow = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          num - 3 == -3 ? pointBlanc : pointGris,
          num - 3 == -2 ? pointBlanc : pointGris,
          num - 3 == -1 ? pointBlanc : pointGris,
          num - 3 == 0 ? pointBlanc : pointGris,
          num - 3 == 1 ? pointBlanc : pointGris,
          num - 3 == 2 ? pointBlanc : pointGris,
          num - 3 == 3 ? pointBlanc : pointGris,
        ],
      );

      return laRow;
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

    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 244, 255, 1),
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Container(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.075,
            ),
            header,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () =>
                        {Navigator.of(context).push(_createRoute())},
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: MediaQuery.of(context).size.width * 0.12,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (Rect bounds) => RadialGradient(
                          center: Alignment.topCenter,
                          colors: [
                            Color.fromRGBO(146, 39, 249, 0.9),
                            Color.fromRGBO(99, 59, 243, 0.9)
                          ],
                        ).createShader(bounds),
                        child: Icon(
                          Icons.add,
                        ),
                      ),
                    )),
                TextButton(
                    onPressed: () =>
                        {Navigator.pushNamed(context, '/search', arguments: 0)},
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: MediaQuery.of(context).size.width * 0.12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (Rect bounds) => RadialGradient(
                          center: Alignment.topCenter,
                          colors: [
                            Color.fromRGBO(146, 39, 249, 0.9),
                            Color.fromRGBO(99, 59, 243, 0.9)
                          ],
                        ).createShader(bounds),
                        child: Icon(
                          Icons.search,
                        ),
                      ),
                    ))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            pageViewDay,
          ])),
          days
        ],
      ),
    );
  }
}
