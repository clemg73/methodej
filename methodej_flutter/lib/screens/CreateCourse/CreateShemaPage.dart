import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:methodej/common/loading.dart';

import '../../common/constants.dart';
import '../../models/shema.dart';
import 'SelectShemaPage.dart';
import '../../common/globals.dart' as globals;
import 'package:http/http.dart' as http;

class CreateShema extends StatefulWidget {
  CreateShema({this.courseArguments});
  final courseArguments;
  @override
  State<CreateShema> createState() =>
      _CreateShemaState(courseArguments: this.courseArguments);
}

class _CreateShemaState extends State<CreateShema> {
  _CreateShemaState({this.courseArguments});
  final courseArguments;

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String error = '';
  final nameController = TextEditingController();

  List<int> selectDayList = <int>[0];

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<int> getUserCountNumbersCoursesMonth() async {
    Uri url = Uri.parse(urlDB +
        "api/courses/countByMonth/user/" +
        (globals.idUser as int).toString());

    final response = await http.get(url);
    print("reponse getUserCountNumbersCoursesMonth: " + response.body);
    if (int.parse(response.body) != -1) {
      return (int.parse(response.body) * 100 / globals.nbCoursesMaxFreeAccount)
          .round();
    } else {
      print("premium");
      return -1;
    }
  }

  Widget build(BuildContext context) {
    Future<bool> createShema({required Shema shemaInfo}) async {
      //Course? retrievedCourse;

      try {
        Response response = await Dio().post(
          urlDB + "api/shema",
          data: shemaInfo.toJson(),
        );

        print('Shema created: ${response.data}');
        globals.schemasChange = true;

        return true;

        //retrievedCourse = Course.fromJson(response.data);
      } catch (e) {
        print('Error creating shema: $e');
        return false;
      }
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
                                "Shéma créé",
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

    Widget SelectDayWidget(int num) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 60,
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      if (selectDayList[num] >= 10) {
                        selectDayList[num] -= 10;
                      } else {
                        selectDayList[num] = 0;
                      }
                      ;
                      setState(() {});
                    },
                    child: Text(
                      "- -",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Color.fromRGBO(18, 0, 40, 1)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ))),
                  ),
                ),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectDayList[num] > 0) selectDayList[num] -= 1;
                      setState(() {});
                    },
                    child: Text(
                      "-",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Color.fromRGBO(18, 0, 40, 0.9)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ))),
                  ),
                ),
                Container(
                    width: 60,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7)),
                    child: Center(
                        child: Text('J+' + selectDayList[num].toString(),
                            style: TextStyle(color: Colors.black)))),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      selectDayList[num] += 1;
                      setState(() {});
                    },
                    child: Text(
                      "+",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Color.fromRGBO(18, 0, 40, 0.9)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ))),
                  ),
                ),
                SizedBox(
                  width: 60,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      selectDayList[num] += 10;
                      setState(() {});
                    },
                    child: Text(
                      "+ +",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Color.fromRGBO(18, 0, 40, 1)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ))),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      );
    }

    Route _returnRoute() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SelectShema(
          courseArguments: this.courseArguments,
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

    Widget header = Column(children: [
      SizedBox(
        height: 70,
      ),
      Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(_returnRoute());
              },
              child: Icon(Icons.arrow_back)),
          SizedBox(
            height: 30,
          ),
          Text(
            'Créer\nun shéma',
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 32, color: Colors.black),
          ),
        ]),
      ),
    ]);

    Widget form = Form(
      key: _formKey,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            header,
            SizedBox(
              height: 30.0,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  controller: nameController,
                  validator: (value) =>
                      value!.isEmpty ? "Entre un nom pour le shéma" : null,
                  decoration: InputDecoration(
                      hintText: 'Nom du shéma',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.white),
                )),
            SizedBox(
              height: 30.0,
            ),
            for (int i = 0; i < selectDayList.length; i++) SelectDayWidget(i),
            FutureBuilder<int>(
                future: getUserCountNumbersCoursesMonth(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? selectDayList.length < 4 ||
                              (snapshot.data == -1 && selectDayList.length < 10)
                          ? SizedBox(
                              width: 100,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (selectDayList.length < 4 ||
                                      (snapshot.data == -1 &&
                                          selectDayList.length < 10)) {
                                    selectDayList.add(0);
                                  }
                                  setState(() {});
                                },
                                child: Text(
                                  "+",
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                            Color.fromRGBO(18, 0, 40, 1)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ))),
                              ),
                            )
                          : Text("")
                      : CupertinoActivityIndicator(
                          color: Colors.black,
                        );
                }),
            SizedBox(
              height: 10.0,
            ),
            SizedBox(height: 10),
            Text(
              error,
              style: TextStyle(color: Colors.red),
            )
          ],
        ),
      ),
    );

    return Container(
      color: Color.fromRGBO(242, 244, 255, 1),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                form,
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => loading = true);
                            loading = true;
                            var nomShema = nameController.value.text;
                            String jours = '';
                            for (int i = 0; i < selectDayList.length; i++)
                              jours += selectDayList[i].toString() + ',';
                            jours = jours.substring(0, jours.length - 1);
                            Shema leShemaCreer =
                                Shema(name: nomShema, jours: jours);

                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildPopupDialog(context, null),
                            );
                            bool result =
                                await createShema(shemaInfo: leShemaCreer);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildPopupDialog(context, result),
                            );
                            await Future.delayed(Duration(seconds: 1));
                            Navigator.pushNamed(context, '/selectShemaArg',
                                arguments: this.courseArguments);
                          }
                        },
                        child: Text(
                          "Ajouter",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Color.fromRGBO(18, 0, 40, 1)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ))),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}
