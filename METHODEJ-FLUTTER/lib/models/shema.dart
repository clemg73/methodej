import '../../common/globals.dart' as globals;

class Shema {
  final int? id;
  final String? name;
  final String? jours;

  Shema({this.id, this.name, this.jours});

  List<int>? toListInt() {
    List<int> laListe = <int>[];
    jours?.split(',').forEach((element) {
      laListe.add(int.parse(element));
    });
    return laListe;
  }

  factory Shema.fromMap(Map<String, dynamic> json) {
    return Shema(id: json['id'], name: json['name'], jours: json['jours']);
  }
  factory Shema.fromJson(Map<String, dynamic> json) {
    return Shema(id: json['id'], name: json['name'], jours: json['jours']);
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "jours": jours,
        "user": {
          "id": (globals.idUser as int).toString(),
          "name": "",
          "mdp": ""
        }
      };

  String schemaToJsonForPref() {
    return '{"id":' +
        id.toString() +
        ',"name": "' +
        name.toString() +
        '","jours":"' +
        jours.toString() +
        '","user": {"id": ' +
        (globals.idUser as int).toString() +
        ',"name": "","mdp": ""}' +
        '}';
  }
}
