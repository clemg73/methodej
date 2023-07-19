import 'package:methodej/models/shema.dart';

class CourseArguments {
  final int? id;
  final String? matiere;
  final String? cours;
  final Shema? shema;
  final String? nomLogo;
  final String? page;

  CourseArguments(
      {this.id, this.matiere, this.cours, this.shema, this.nomLogo, this.page});
}
