import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polygon/polygon.dart';
import '../../common/loading.dart';
import '../../models/course.dart';
import '../../common/polygoneGenerate.dart';
import 'CourseItem.dart';
import 'ListCourses.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:skeleton_text/skeleton_text.dart';

class DayView extends StatefulWidget {
  DayView({Key? key, required this.num, required this.products})
      : super(key: key);
  final String num;
  final Future<List<Course>> products;

  @override
  State<DayView> createState() =>
      _DayViewState(num: this.num, products: this.products);
}

class _DayViewState extends State<DayView> with TickerProviderStateMixin {
  _DayViewState({required this.num, required this.products});
  final String num;
  final Future<List<Course>> products;

  @override
  Widget build(BuildContext context) {
    DayCalc(int addDay) {
      DateTime dateCalc = DateTime.now().add(Duration(days: addDay));
      switch (dateCalc.weekday) {
        case 1:
          return "Lundi " + dateCalc.day.toString();
          break;
        case 2:
          return "Mardi " + dateCalc.day.toString();
          break;
        case 3:
          return "Mercredi " + dateCalc.day.toString();
          break;
        case 4:
          return "Jeudi " + dateCalc.day.toString();
          break;
        case 5:
          return "Vendredi " + dateCalc.day.toString();
          break;
        case 6:
          return "Samedi " + dateCalc.day.toString();
          break;
        case 7:
          return "Dimanche " + dateCalc.day.toString();
          break;
        default:
          return "Lundi " + dateCalc.day.toString();
          break;
      }
    }

    MonthCalc(int addDay) {
      DateTime dateCalc = DateTime.now().add(Duration(days: addDay));
      switch (dateCalc.month) {
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
          return "Janvier";
          break;
      }
    }

    int caclCoursesFait(List<Course> liste) {
      int count = 0;
      liste.forEach((element) {
        if (element.revisions?[element.numRevActuel as int].dateFait != null) {
          count++;
        }
      });
      return count;
    }

    Widget coursesSection = Container(
      width: MediaQuery.of(context).size.width * 0.85,
      child: FutureBuilder<List<Course>>(
        future: products,
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? (snapshot.data as List<Course>).isNotEmpty
                  ? SizedBox(
                      width: 150,
                      child: Column(
                        children: [
                          Expanded(
                              child: CoursesList(
                                  items: snapshot.data as List<Course>))
                        ],
                      ),
                    )
                  : Container(
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Aucune révision de prévu',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            height: 350,
                          )
                        ],
                      )),
                    )
              : Column(
                  children: [
                    SkeletonAnimation(
                        child: Row(
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
                                  color: Color.fromARGB(150, 255, 255, 255)),
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                    left: 0, right: 10, top: 25),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color.fromARGB(150, 255, 255, 255),
                                          Color.fromARGB(150, 255, 255, 255)
                                        ])),
                                width: 40,
                                height: 40),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          width: MediaQuery.of(context).size.width * 0.7,
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
                                          Color.fromARGB(150, 255, 255, 255))),
                              onPressed: () {},
                              child: Row()),
                        ),
                      ],
                    )),
                    SkeletonAnimation(
                      child: Row(
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
                                    color: Color.fromARGB(150, 255, 255, 255)),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 0, right: 10, top: 25),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color.fromARGB(150, 255, 255, 255),
                                          Color.fromARGB(150, 255, 255, 255)
                                        ])),
                                width: 40,
                                height: 40,
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5, bottom: 5),
                            width: MediaQuery.of(context).size.width * 0.7,
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
                                        Color.fromARGB(150, 255, 255, 255))),
                                onPressed: () {},
                                child: Row()),
                          ),
                        ],
                      ),
                    ),
                    SkeletonAnimation(
                      child: Row(
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
                                    color: Color.fromARGB(150, 255, 255, 255)),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 0, right: 10, top: 25),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color.fromARGB(150, 255, 255, 255),
                                          Color.fromARGB(150, 255, 255, 255)
                                        ])),
                                width: 40,
                                height: 40,
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5, bottom: 5),
                            width: MediaQuery.of(context).size.width * 0.7,
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
                                        Color.fromARGB(150, 255, 255, 255))),
                                onPressed: () {},
                                child: Row()),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
        },
      ),
    );

    Container headerDayView() {
      return Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.only(left: 35, right: 35),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          FutureBuilder<List<Course>>(
              future: products,
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? Text(
                        DayCalc(int.parse(this.num)) +
                            ' ' +
                            MonthCalc(int.parse(this.num)),
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black),
                      )
                    : Text('');
              }),
          Row(
            children: [
              FutureBuilder<List<Course>>(
                  future: products,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData
                        ? (snapshot.data as List<Course>).isNotEmpty
                            ? Text(
                                caclCoursesFait(snapshot.data as List<Course>)
                                    .toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color.fromRGBO(146, 39, 249, 1)),
                              )
                            : Text('')
                        : Text('');
                  }),
              FutureBuilder<List<Course>>(
                  future: products,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData
                        ? (snapshot.data as List<Course>).isNotEmpty
                            ? Text(
                                '/' +
                                    (snapshot.data as List<Course>)
                                        .length
                                        .toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black),
                              )
                            : Text('')
                        : Text('');
                  }),
            ],
          )
        ]),
      );
    }

    //Center(child: Container(child: Image.asset("images/334-loader-5.webp"), width: MediaQuery.of(context).size.width * 0.2,)) ;

    /*Widget graphicSection = FutureBuilder<Polygon>(
      future: lePolygone,
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        return snapshot.hasData
            ? snapshot.data as Polygon != null
              ? Container(
                  padding: const EdgeInsets.only(top: 20),
                  child:  DecoratedBox(
                    decoration: ShapeDecoration(
                        shape: PolygonBorder(
                          polygon: snapshot.data as Polygon,
                          radius: 10.0,
                          borderAlign: BorderAlign.outside,

                        ),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color.fromRGBO(146, 39, 249,1), Color.fromRGBO(99, 59, 243, 0)],
                            stops: [0.5, 1]
                        )
                    ),
                    child: SizedBox(
                      height: 100,
                      width: 300,
                    ),
                  )
              )
              : Text('Erreur Shéma', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30, color: Colors.white),)
            : Container();
      },
    );*/

    //CoursesList(items: snapshot.data as List<Course>)

    /*Future<List<double>> createGraph() async {
      return  <double>[0,0,1,0,0,0,0];
    }

    Future<List<double>> t = createGraph();*/

    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      headerDayView(),
      //graphicSection,
      SizedBox(height: 10),

      Expanded(child: coursesSection)
    ]);
  }
}
