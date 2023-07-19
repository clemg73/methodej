import 'package:flutter/material.dart';
import 'package:methodej/screens/Calendar/addRevision.dart';
import 'package:methodej/screens/Profil/emailPage.dart';

import 'Calendar/CalendarPage.dart';
import 'Calendar/EditCourse.dart';
import 'Calendar/ModifRev.dart';
import 'CoursePage.dart';
import 'CreateCourse/CreateCoursePage.dart';
import 'CreateCourse/CreateShemaPage.dart';
import 'CreateCourse/SelectLogoPage.dart';
import 'CreateCourse/SelectShemaPage.dart';
import 'Profil/PolitiquePage.dart';
import 'Profil/passwordPage.dart';
import 'Profil/premium.dart';
import 'Profil/testIap.dart';

import 'authenticate/welcomPage.dart';
import 'search/searchPage.dart';
import 'authenticate/authenticate_screen.dart';
import 'Profil/ProfilPage.dart';
import 'authenticate/login.dart';
import 'authenticate/register.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/welcome':
        return MaterialPageRoute(builder: (context) => Welcome());
      case '/login':
        return MaterialPageRoute(builder: (context) => Login());
      case '/register':
        return MaterialPageRoute(builder: (context) => Register());
      case '/authenticate':
        return MaterialPageRoute(builder: (context) => AuthentificateScreen());
      case '/profil':
        return MaterialPageRoute(builder: (context) => Profil());
      case '/calendar0':
        return MaterialPageRoute(builder: (context) => Calendar(page: 0));
      case '/premium':
        return MaterialPageRoute(builder: (context) => Premium());
      case '/search':
        return MaterialPageRoute(builder: (context) => Search());
      case '/politique':
        return MaterialPageRoute(builder: (context) => Politique());
      case '/passwordChange':
        return MaterialPageRoute(builder: (context) => PasswordChange());
      case '/emailChange':
        return MaterialPageRoute(builder: (context) => MailChange());
      case '/calendar':
        return MaterialPageRoute(
            builder: (context) => Calendar(
                  page: settings.arguments,
                ));
      case '/addCourse':
        return MaterialPageRoute(
            builder: (context) => CreateCourse(
                  courseArguments: null,
                ));
      case '/addCourseArg':
        return MaterialPageRoute(
            builder: (context) => CreateCourse(
                  courseArguments: settings.arguments,
                ));
      case '/selectShemaArg':
        return MaterialPageRoute(
            builder: (context) => SelectShema(
                  courseArguments: settings.arguments,
                ));
      case '/addShema':
        return MaterialPageRoute(
            builder: (context) => CreateShema(
                  courseArguments: settings.arguments,
                ));
      case '/ModifRev':
        return MaterialPageRoute(
            builder: (context) => ModifRev(
                  item: settings.arguments,
                ));
      case '/CoursePage':
        return MaterialPageRoute(
            builder: (context) => CoursePage(
                  item: settings.arguments,
                ));
      case '/selectLogo':
        return MaterialPageRoute(
            builder: (context) => SelectLogo(
                  courseArguments: settings.arguments,
                ));
      case '/addrev':
        return MaterialPageRoute(
            builder: (context) => AddRev(
                  item: settings.arguments,
                ));
      case '/editcourse':
        return MaterialPageRoute(
            builder: (context) => EditCourse(
                  courseArguments: settings.arguments,
                ));
      default:
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Text("Error"),
                  centerTitle: true,
                ),
                body: Center(child: Text("Page not found"))));
    }
  }
}
