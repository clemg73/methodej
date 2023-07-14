import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const textInputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    contentPadding: EdgeInsets.all(12),
    errorBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1)),
    focusedErrorBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1)),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueGrey, width: 1)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 1)));

Container myNavigationBar(BuildContext context, String laPage) {
  return Container(
    height: 142,
    //color: Colors.blue,
    child: Container(
      //padding: const EdgeInsets.only(bottom: 41),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Stack(alignment: AlignmentDirectional.center, children: [
          Container(
            margin: const EdgeInsets.only(top: 41),
            child: Container(
              height: 61,
              width: 350,
              padding: const EdgeInsets.only(bottom: 10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(17))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      Navigator.pushNamed(context, '/calendar', arguments: 0);
                    },
                    icon: laPage == "calendar"
                        ? const Icon(
                            Icons.home_filled,
                            color: Color.fromRGBO(99, 59, 243, 1),
                            size: 35,
                          )
                        : const Icon(
                            Icons.home_outlined,
                            color: Colors.black,
                            size: 35,
                          ),
                  ),
                  IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      Navigator.pushNamed(context, '/calendar', arguments: 0);
                    },
                    icon: laPage == ""
                        ? const Icon(
                            Icons.work_rounded,
                            color: Color.fromRGBO(99, 59, 243, 1),
                            size: 35,
                          )
                        : const Icon(
                            Icons.work_outline_outlined,
                            color: Colors.black,
                            size: 35,
                          ),
                  ),
                  Container(
                    width: 82,
                    height: 122,
                  ),
                  IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      Navigator.pushNamed(context, '/calendar', arguments: 0);
                    },
                    icon: laPage == ""
                        ? const Icon(
                            Icons.widgets_rounded,
                            color: Color.fromRGBO(99, 59, 243, 1),
                            size: 35,
                          )
                        : const Icon(
                            Icons.widgets_outlined,
                            color: Colors.black,
                            size: 35,
                          ),
                  ),
                  IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      Navigator.pushNamed(context, '/login', arguments: 0);
                    },
                    icon: laPage == "login"
                        ? const Icon(
                            Icons.person,
                            color: Color.fromRGBO(99, 59, 243, 1),
                            size: 35,
                          )
                        : const Icon(
                            Icons.person_outline,
                            color: Colors.black,
                            size: 35,
                          ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/addCourse',
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      //border: Border.all(color: Color.fromRGBO(38, 37, 70, 1), width: 5),
                      gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(146, 39, 249, 1),
                            Color.fromRGBO(99, 59, 243, 1)
                          ])),
                  width: 75,
                  height: 75,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          size: 45,
                          color: Colors.white,
                        )
                      ]),
                ),
              )),
        ])
      ]),
    ),
  );
}

SizedBox navBar(BuildContext context, String laPage) {
  return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Stack(alignment: AlignmentDirectional.bottomCenter, children: <
          Widget>[
        SvgPicture.asset(
          'images/navBarBG.svg',
          semanticsLabel: 'Acme Logo',
          width: MediaQuery.of(context).size.width,
          color: Color.fromRGBO(50, 0, 90, 1),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/calendar', arguments: 0);
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                        Color.fromRGBO(255, 255, 255, 1)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ))),
                child: laPage == "calendar"
                    ? const Icon(
                        Icons.calendar_month_outlined,
                        color: Color.fromRGBO(99, 59, 243, 1),
                        size: 35,
                      )
                    : const Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.black,
                        size: 35,
                      ),
              ),
            ),
            Container(
              width: 70,
              height: 70,
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/addCourse', arguments: 0);
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                        Color.fromRGBO(255, 255, 255, 1)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ))),
                child: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.black,
                  size: 35,
                ),
              ),
            ),
            Container(
              width: 70,
              height: 70,
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/stat', arguments: 0);
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                        Color.fromRGBO(255, 255, 255, 1)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ))),
                child: laPage == "stat"
                    ? const Icon(
                        Icons.graphic_eq_outlined,
                        color: Color.fromRGBO(99, 59, 243, 1),
                        size: 35,
                      )
                    : const Icon(
                        Icons.graphic_eq_outlined,
                        color: Colors.black,
                        size: 35,
                      ),
              ),
            ),
          ],
        )
      ]));
}

const urlDB = 'https://methodej.azurewebsites.net/';
//const urlDB = 'https://localhost:7217/';
