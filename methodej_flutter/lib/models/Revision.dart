class Revision {
  final int? id;
  final DateTime? datePrevu;
  final DateTime? dateFait;

  Revision({this.id, this.datePrevu, this.dateFait});

  factory Revision.fromMap(Map<String, dynamic> json) {
    DateTime? dateFaitVar;
    json['dateFait'] != null
        ? dateFaitVar = DateTime.parse(json['dateFait'])
        : dateFaitVar = null;
    return Revision(
        id: json['id'],
        datePrevu: DateTime.parse(json['datePrevu']),
        dateFait: dateFaitVar);
  }
  factory Revision.fromJson(Map<String, dynamic> json) {
    DateTime? dateFaitVar;
    json['dateFait'] != null
        ? dateFaitVar = DateTime.parse(json['dateFait'])
        : dateFaitVar = null;
    return Revision(
        id: json['id'],
        datePrevu: DateTime.parse(json['datePrevu']),
        dateFait: dateFaitVar);
  }

  static String dateToString(int num) {
    String temp = '';
    num as int < 10
        ? temp = '0' + (num.toString() as String)
        : temp = num.toString() as String;
    return temp;
  }

  String DateToJsonForJson() {
    return (datePrevu?.year.toString() as String) +
        "-" +
        dateToString(datePrevu?.month as int) +
        "-" +
        dateToString(datePrevu?.day as int) +
        "T00:00:00";
  }

  String revisionToJson() {
    if (dateFait != DateTime(0000) && dateFait != null)
      return '{"id":"' +
          (id as int).toString() +
          '","datePrevu":"' +
          (datePrevu?.year.toString() as String) +
          "-" +
          dateToString(datePrevu?.month as int) +
          "-" +
          dateToString(datePrevu?.day as int) +
          'T00:00:00","dateFait":"' +
          (dateFait?.year.toString() as String) +
          "-" +
          dateToString(dateFait?.month as int) +
          "-" +
          dateToString(dateFait?.day as int) +
          'T00:00:00"}';
    else
      return '{"id":"' +
          (id as int).toString() +
          '","datePrevu":"' +
          (datePrevu?.year.toString() as String) +
          "-" +
          dateToString(datePrevu?.month as int) +
          "-" +
          dateToString(datePrevu?.day as int) +
          'T00:00:00","dateFait":null}';
  }

  String revisionToJsonForAdd() {
    return '{"datePrevu":"' +
        (datePrevu?.year.toString() as String) +
        "-" +
        dateToString(datePrevu?.month as int) +
        "-" +
        dateToString(datePrevu?.day as int) +
        'T00:00:00","dateFait":null}';
  }
}
