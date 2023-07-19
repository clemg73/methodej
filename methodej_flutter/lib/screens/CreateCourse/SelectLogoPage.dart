import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/CourseArguments.dart';
import '../Calendar/CalendarPage.dart';
import '../Calendar/EditCourse.dart';
import 'CreateCoursePage.dart';

class SelectLogo extends StatefulWidget {
  SelectLogo({this.courseArguments});
  final courseArguments;

  @override
  State<SelectLogo> createState() =>
      _SelectLogoState(courseArguments: this.courseArguments);
}

class _SelectLogoState extends State<SelectLogo> {
  _SelectLogoState({this.courseArguments});
  final courseArguments;
  String nomLogo = '';

  Widget build(BuildContext context) {
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
              color: name == nomLogo
                  ? Color.fromRGBO(18, 0, 40, 1)
                  : Color.fromRGBO(242, 244, 255, 1)),
        )
      ]);
    }

    Route _returnRoute() {
      switch ((courseArguments as CourseArguments).page) {
        case "create":
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                CreateCourse(
              // ignore: unnecessary_new
              courseArguments: new CourseArguments(
                  matiere: (courseArguments as CourseArguments).matiere,
                  cours: (courseArguments as CourseArguments).cours,
                  shema: (courseArguments as CourseArguments).shema,
                  nomLogo: nomLogo == ''
                      ? (courseArguments as CourseArguments).nomLogo
                      : nomLogo),
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
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
          break;
        case "edit":
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => EditCourse(
              // ignore: unnecessary_new
              courseArguments: new CourseArguments(
                  id: (courseArguments as CourseArguments).id,
                  matiere: (courseArguments as CourseArguments).matiere,
                  cours: (courseArguments as CourseArguments).cours,
                  nomLogo: nomLogo == ''
                      ? (courseArguments as CourseArguments).nomLogo
                      : nomLogo),
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
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
          break;
        default:
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                Calendar(page: 0),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
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
          break;
      }
    }

    return Scaffold(
        backgroundColor: Color.fromRGBO(242, 244, 255, 1),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                          Navigator.of(context).push(_returnRoute());
                        },
                        child: Icon(Icons.arrow_back)),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Sélectionner\nun logo',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 32,
                          color: Colors.black),
                    ),
                  ]),
            ),
            SizedBox(height: 30),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 4,
                  children: <Widget>[
                    logoChoice("images/logo/bio.svg"),
                    logoChoice("images/logo/math.svg"),
                    logoChoice("images/logo/reseau.svg"),
                    logoChoice("images/logo/code.svg"),
                    logoChoice("images/logo/basketball-outline.svg"),
                    logoChoice("images/logo/book-outline.svg"),
                    logoChoice("images/logo/bulb-outline.svg"),
                    logoChoice("images/logo/camera-outline.svg"),
                    logoChoice("images/logo/cart-outline.svg"),
                    logoChoice("images/logo/cash-outline.svg"),
                    logoChoice("images/logo/chatbubbles-outline.svg"),
                    logoChoice("images/logo/cloud-outline.svg"),
                    logoChoice("images/logo/cog-outline.svg"),
                    logoChoice("images/logo/desktop-outline.svg"),
                    logoChoice("images/logo/earth-outline.svg"),
                    logoChoice("images/logo/extension-puzzle-outline.svg"),
                    logoChoice("images/logo/film-outline.svg"),
                    logoChoice("images/logo/fitness-outline.svg"),
                    logoChoice("images/logo/flask-outline.svg"),
                    logoChoice("images/logo/flower-outline.svg"),
                    logoChoice("images/logo/heart-dislike-outline.svg"),
                    logoChoice("images/logo/heart-outline.svg"),
                    logoChoice("images/logo/image-outline.svg"),
                    logoChoice("images/logo/language-outline.svg"),
                    logoChoice("images/logo/library-outline.svg"),
                    logoChoice("images/logo/location-outline.svg"),
                    logoChoice("images/logo/medical-outline.svg"),
                    logoChoice("images/logo/medkit-outline.svg"),
                    logoChoice("images/logo/musical-notes-outline.svg"),
                    logoChoice("images/logo/newspaper-outline.svg"),
                    logoChoice("images/logo/nutrition-outline.svg"),
                    logoChoice("images/logo/pie-chart-outline.svg"),
                    logoChoice("images/logo/planet-outline.svg"),
                    logoChoice("images/logo/podium-outline.svg"),
                    logoChoice("images/logo/pulse-outline.svg"),
                    logoChoice("images/logo/school-outline.svg"),
                    logoChoice("images/logo/server-outline.svg"),
                    logoChoice("images/logo/skull-outline.svg"),
                    logoChoice("images/logo/stats-chart-outline.svg"),
                    logoChoice("images/logo/terminal-outline.svg"),
                    logoChoice("images/logo/trending-up-outline.svg"),
                  ],
                ),
              ),
            )
          ]),
        ));
  }
}
