import 'dart:io';

import 'package:flutter/material.dart';
import 'package:methodej/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/globals.dart' as globals;
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'consumable_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MethodeJ();
  }
}

class MethodeJ extends StatefulWidget {
  const MethodeJ({Key? key}) : super(key: key);

  @override
  MethodeJState createState() => MethodeJState();
}

class MethodeJState extends State<MethodeJ> {
  late Future<int> _id;

  @override
  void initState() {
    super.initState();
    _id = SharedPreferences.getInstance().then((SharedPreferences prefs) {
      return prefs.getInt('compteID') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _id,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data != 0) {
              print(snapshot.data);
              globals.idUser = snapshot.data;
              return MaterialApp(
                title: 'Methode J',
                initialRoute: '/calendar0',
                onGenerateRoute: (settings) =>
                    RouteGenerator.generateRoute(settings),
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                debugShowCheckedModeBanner: false,
              );
            } else {
              print(snapshot.data);
              return MaterialApp(
                title: 'Methode J',
                initialRoute: '/welcome',
                onGenerateRoute: (settings) =>
                    RouteGenerator.generateRoute(settings),
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                debugShowCheckedModeBanner: false,
              );
            }
        }
      },
    );
  }
/*
  @override
  Widget build(BuildContext context) {
    Future<bool> connect() async {
      // Obtain shared preferences.

      SharedPreferences.getInstance().then((SharedPreferences prefs) {
        var id = prefs.getString('compte');
        if (id != null) {
          globals.idUser = int.parse(id);
        }
        return id != null;
      });
    }

    String connect2() {
      SharedPreferences.getInstance().then((SharedPreferences prefs) {
        var id = prefs.getString('compte');
        if (id != null) {
          globals.idUser = int.parse(id);
        }
        return id != null;
      });
    }

    return FutureBuilder<int>(
        future: _id,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Text(
                  'Button tapped ${snapshot.data} time${snapshot.data == 1 ? '' : 's'}.\n\n'
                  'This should persist across restarts.',
                );
              }
          }
        });

    /*return connect2() == 'true'
        ? MaterialApp(
            title: 'Methode J',
            initialRoute: '/calendar0',
            onGenerateRoute: (settings) =>
                RouteGenerator.generateRoute(settings),
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            debugShowCheckedModeBanner: false,
          )
        : MaterialApp(
            title: 'Methode J',
            initialRoute: '/welcome',
            onGenerateRoute: (settings) =>
                RouteGenerator.generateRoute(settings),
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            debugShowCheckedModeBanner: false,
          );*/
  }
}

/*
// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'SharedPreferences Demo',
      home: SharedPreferencesDemo(),
    );
  }
}

class SharedPreferencesDemo extends StatefulWidget {
  const SharedPreferencesDemo({Key? key}) : super(key: key);

  @override
  SharedPreferencesDemoState createState() => SharedPreferencesDemoState();
}

class SharedPreferencesDemoState extends State<SharedPreferencesDemo> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> _counter;

  Future<void> _incrementCounter() async {
    final SharedPreferences prefs = await _prefs;
    final int counter = (prefs.getInt('counter') ?? 0) + 1;

    setState(() {
      _counter = prefs.setInt('counter', counter).then((bool success) {
        return counter;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _counter = _prefs.then((SharedPreferences prefs) {
      return prefs.getInt('counter') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SharedPreferences Demo'),
      ),
      body: Center(
          child: FutureBuilder<int>(
              future: _counter,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Text(
                        'Button tapped ${snapshot.data} time${snapshot.data == 1 ? '' : 's'}.\n\n'
                        'This should persist across restarts.',
                      );
                    }
                }
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}*/*/

}
