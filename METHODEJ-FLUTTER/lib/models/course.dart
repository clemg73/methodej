import '../../common/globals.dart' as globals;

import 'package:methodej/models/Revision.dart';

class Course {
  final int? id;
  final String? matiere;
  final String? cours;
  final String? user;
  final List<Revision>? revisions;
  final DateTime? dateCreation;
  final String? nomLogo;

  int? numRevActuel;

  Course(
      {this.id,
      this.matiere,
      this.cours,
      this.user,
      this.revisions,
      this.dateCreation,
      this.nomLogo});

  factory Course.fromMap(Map<String, dynamic> json) {
    List<Revision> laListe = <Revision>[];
    json['revisions'].map((m) => new Revision.fromJson(m)).forEach((element) {
      laListe.add(element);
    });
    return Course(
        id: json['id'],
        matiere: json['matiere'],
        cours: json['cours'],
        user: null,
        revisions: laListe,
        dateCreation: DateTime.parse(json['date']),
        nomLogo: json['nomLogo']);
  }
  factory Course.fromJson(Map<String, dynamic> json) {
    try {
      List<Revision> laListe = <Revision>[];
      (json['revisions'] as List)
          .map((m) => Revision.fromJson(m))
          .forEach((element) {
        laListe.add(new Revision(
            id: element.id,
            datePrevu: element.datePrevu,
            dateFait: element.dateFait));
      });
      Course leCours = Course(
          id: json['id'],
          matiere: json['matiere'],
          cours: json['cours'],
          user: null,
          revisions: laListe,
          dateCreation: DateTime.parse(json['date']),
          nomLogo: json['nomLogo']);
      leCours.numRevActuel = json['numRevActuel'];
      return leCours;
    } catch (e) {
      return Course();
    }
  }

  String ListRevisionToString() {
    String temp = '[';
    revisions?.forEach((element) {
      String jour = (element.datePrevu?.day as int).toString();
      if ((element.datePrevu?.day as int) < 10)
        jour = '0' + (element.datePrevu?.day as int).toString();
      temp += '{' +
          '"dateprevu":"' +
          (element.datePrevu?.year.toString() as String) +
          "-" +
          dateToString(element.datePrevu?.month as int) +
          "-" +
          jour +
          'T00:00:00",' +
          '"datefait":null},';
    });
    temp = temp.substring(0, temp.length - 1) + ']';
    return temp;
  }

  String dateToString(int num) {
    String temp = '';
    num as int < 10
        ? temp = '0' + (num.toString() as String)
        : temp = num.toString() as String;
    return temp;
  }

  String courseToJson() {
    return '{"matiere":"' +
        (matiere as String) +
        '","cours":"' +
        (cours as String) +
        '","user":{"id":' +
        (globals.idUser as int).toString() +
        ',"name":"","mdp":""},"revisions": ' +
        ListRevisionToString() +
        ',"date":"' +
        (dateCreation?.year.toString() as String) +
        "-" +
        dateToString(dateCreation?.month as int) +
        "-" +
        dateToString(dateCreation?.day as int) +
        'T00:00:00","nomLogo":"' +
        (nomLogo as String) +
        '"}';
  }

  // Obligé de dupliquer les deux fonctions il faut de smajuscule dans les champs: datePrevu et dateFait et aussi il faut l'id je crois mais pas sur

  String ListRevisionToStringForPref() {
    String temp = '[';
    revisions?.forEach((element) {
      String jourDP = (element.datePrevu?.day as int).toString();
      if ((element.datePrevu?.day as int) < 10)
        jourDP = '0' + (element.datePrevu?.day as int).toString();

      String jourDF = (element.dateFait?.day ?? 0 as int).toString();
      if ((element.dateFait?.day ?? 0 as int) < 10)
        jourDF = '0' + (element.dateFait?.day ?? 0 as int).toString();

      String dateFait = element.dateFait != null
          ? '"' +
              (element.dateFait?.year.toString() as String) +
              "-" +
              dateToString(element.dateFait?.month as int) +
              "-" +
              jourDF +
              'T00:00:00"'
          : 'null';

      temp += '{"id":' +
          element.id.toString() +
          ',"datePrevu":"' +
          (element.datePrevu?.year.toString() as String) +
          "-" +
          dateToString(element.datePrevu?.month as int) +
          "-" +
          jourDP +
          'T00:00:00",' +
          '"dateFait":' +
          dateFait +
          '},';
    });
    temp = temp.substring(0, temp.length - 1) + ']';
    return temp;
  }

  String courseToJsonForPref() {
    return '{"id":' +
        id.toString() +
        ',"matiere":"' +
        (matiere as String) +
        '","cours":"' +
        (cours as String) +
        '","user":{"id":' +
        (globals.idUser as int).toString() +
        ',"name":"","mdp":""},"revisions": ' +
        ListRevisionToStringForPref() +
        ',"date":"' +
        (dateCreation?.year.toString() as String) +
        "-" +
        dateToString(dateCreation?.month as int) +
        "-" +
        dateToString(dateCreation?.day as int) +
        'T00:00:00","nomLogo":"' +
        (nomLogo as String) +
        '","numRevActuel":' +
        numRevActuel.toString() +
        '}';
  }

  String courseToJsonForEdit() {
    print("l'id est" + (id.toString() as String));
    return '{"id":' +
        (id.toString() as String) +
        ',"matiere":"' +
        (matiere as String) +
        '","cours":"' +
        (cours as String) +
        '","user":{"id":' +
        (globals.idUser as int).toString() +
        ',"name":"","mdp":""},"revisions": [],"date":"' +
        (dateCreation?.year.toString() as String) +
        "-" +
        dateToString(dateCreation?.month as int) +
        "-" +
        dateToString(dateCreation?.day as int) +
        'T00:00:00","nomLogo":"' +
        (nomLogo as String) +
        '"}';
  }
}
