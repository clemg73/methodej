import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../common/constants.dart';
import '../../common/loading.dart';
import '../../models/CourseArguments.dart';
import '../../models/Revision.dart';
import '../../models/course.dart';
import '../../models/shema.dart';
import 'package:http/http.dart' as http;
import '../../common/globals.dart' as globals;
import 'package:dio/dio.dart';

import '../../models/user.dart';
import '../Calendar/CalendarPage.dart';

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}

class Premium extends StatefulWidget {
  const Premium({super.key});

  @override
  State<Premium> createState() => _PremiumState();
}

const String planID = 'premium_2';

const List<String> _kProductIds = <String>[
  planID,
];

class _PremiumState extends State<Premium> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      _subscription.resume();
    });
    initStoreInfo();
    super.initState();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _notFoundIds = [];
        //_consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        //_consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        //_consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    //List<String> consumables = await ConsumableStore.load();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      //_consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      var iosPlatformAddition = _inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Route _calendarRoute() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => Calendar(
          page: 0,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, -1.0);
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

    if (_purchasePending) {
      return Stack(
        children: const [
          Opacity(
            opacity: 0.3,
            child: ModalBarrier(dismissible: false, color: Colors.grey),
          ),
          Center(
            child: CupertinoActivityIndicator(
              color: Colors.white,
            ),
          ),
        ],
      );
    } else {
      return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        resizeToAvoidBottomInset: false,
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 60,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.close),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Compte",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GradientText(
                              'Premium',
                              style: const TextStyle(
                                  fontSize: 48, fontWeight: FontWeight.w600),
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(146, 39, 249, 1),
                                Color.fromRGBO(99, 59, 243, 1)
                              ]),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (Rect bounds) => RadialGradient(
                                center: Alignment.topCenter,
                                colors: [
                                  Color.fromRGBO(146, 39, 249, 1),
                                  Color.fromRGBO(99, 59, 243, 1)
                                ],
                              ).createShader(bounds),
                              child: SvgPicture.asset(
                                "images/check.svg",
                                width: 30,
                                height: 30,
                                semanticsLabel: 'Acme Logo',
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Nombres de cours ",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            GradientText(
                              'illimité',
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(146, 39, 249, 1),
                                Color.fromRGBO(99, 59, 243, 1)
                              ]),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (Rect bounds) => RadialGradient(
                                center: Alignment.topCenter,
                                colors: [
                                  Color.fromRGBO(146, 39, 249, 1),
                                  Color.fromRGBO(99, 59, 243, 1)
                                ],
                              ).createShader(bounds),
                              child: SvgPicture.asset(
                                "images/check.svg",
                                width: 30,
                                height: 30,
                                semanticsLabel: 'Acme Logo',
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Nombres de révisions par cours: ",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            GradientText(
                              '10',
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(146, 39, 249, 1),
                                Color.fromRGBO(99, 59, 243, 1)
                              ]),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (Rect bounds) => RadialGradient(
                                center: Alignment.topCenter,
                                colors: [
                                  Color.fromRGBO(146, 39, 249, 1),
                                  Color.fromRGBO(99, 59, 243, 1)
                                ],
                              ).createShader(bounds),
                              child: SvgPicture.asset(
                                "images/check.svg",
                                width: 30,
                                height: 30,
                                semanticsLabel: 'Acme Logo',
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Tous les futurs contenue payant  ",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            GradientText(
                              'à vie',
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(146, 39, 249, 1),
                                Color.fromRGBO(99, 59, 243, 1)
                              ]),
                            ),
                          ],
                        )
                      ]),

                  _buildProductList(),
                  // _buildPremiumBox()
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  /*Card _buildPremiumBox() {
    if (_loading) {
      return const Card(
          child: (ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Fetching consumables...'))));
    }
    if (!_isAvailable || _notFoundIds.contains(planID)) {
      return const Card();
    }
    const ListTile consumableHeader =
        ListTile(title: Text('Purchased consumables'));

    return Card(
        child: Column(children: <Widget>[
      consumableHeader,
      _purchases.length > 0
          ? IconButton(
              icon: const Icon(
                Icons.stars,
                size: 42.0,
                color: Colors.orange,
              ),
              splashColor: Colors.yellowAccent,
              onPressed: () {/*consume(id)*/},
            )
          : Text("pas premium")
    ]));
  }*/

  Column _buildProductList() {
    if (_loading) {
      return Column(
        children: [
          CupertinoActivityIndicator(
            color: Colors.black,
          ),
          SizedBox(
            height: 50,
          )
        ],
      );
    }
    if (!_isAvailable) {
      return Column(
        children: [
          CupertinoActivityIndicator(
            color: Colors.black,
          ),
          SizedBox(
            height: 50,
          )
        ],
      );
    }

    List<Column> productList = <Column>[];

    productList.addAll(_products.map(
      (ProductDetails productDetails) {
        return Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 1.5,
              color: Color.fromRGBO(242, 244, 255, 1),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GradientText(
                  '1,99€',
                  style: const TextStyle(
                      fontSize: 48, fontWeight: FontWeight.w600),
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(146, 39, 249, 1),
                    Color.fromRGBO(99, 59, 243, 1)
                  ]),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                late PurchaseParam purchaseParam;

                purchaseParam = PurchaseParam(
                  productDetails: productDetails,
                  applicationUserName: null,
                );

                if (productDetails.id == planID) {
                  _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        Color.fromRGBO(146, 39, 249, 0.9),
                        Color.fromRGBO(99, 59, 243, 0.9)
                      ]),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Continuer",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            /*TextButton(
              onPressed: () => {},
              child: Text(
                "Restaurer mes achats",
                style: TextStyle(color: Colors.black),
              ),
            ),*/
            SizedBox(
              height: 50,
            )
          ],
        );
      },
    ));

    return Column(children: productList);
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    setState(() {
      _purchases.add(purchaseDetails);
      _purchasePending = false;
    });
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  Future<bool> _verifyPurchase() async {
    print("acheter");
    try {
      User user = User(name: "", mdp: "", premium: true);
      Response response = await Dio().put(
        urlDB + "api/user/managepremium/" + globals.idUser.toString(),
        data: user.toJsonForDoPremium(),
      );

      print('Premium updated: ${response.data}');

      return true;
    } catch (e) {
      print('Error creating course: $e');
      return false;
    }
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {}
  Route _calendarRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Calendar(
        page: 0,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, -1.0);
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

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          bool valid = await _verifyPurchase();
          if (valid) {
            deliverProduct(purchaseDetails);
            Navigator.of(context).push(_calendarRoute());
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    });
  }
}

//------------------------------------------------------

/*const String planID = 'premium_1';

const List<String> _kProductIds = <String>[
  planID,
];

class _MyAppTest extends StatefulWidget {
  const _MyAppTest({super.key});
  @override
  _MyAppStateTest createState() => _MyAppStateTest();
}

class _MyAppStateTest extends State<_MyAppTest> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      _subscription.resume();
    });
    initStoreInfo();
    super.initState();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _notFoundIds = [];
        //_consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        //_consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        //_consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    //List<String> consumables = await ConsumableStore.load();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      //_consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      var iosPlatformAddition = _inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stack = [];
    if (_queryProductError == null) {
      stack.add(
        ListView(
          children: [
            _buildConnectionCheckTile(),
            _buildProductList(),
            _buildPremiumBox()
            //_buildConsumableBox(),
            //_buildRestoreButton(),
          ],
        ),
      );
    } else {
      stack.add(Center(
        child: Text(_queryProductError!),
      ));
    }
    if (_purchasePending) {
      stack.add(
        Stack(
          children: const [
            Opacity(
              opacity: 0.3,
              child: ModalBarrier(dismissible: false, color: Colors.grey),
            ),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('IAP Example'),
        ),
        body: Stack(
          children: stack,
        ),
      ),
    );
  }

  Card _buildConnectionCheckTile() {
    if (_loading) {
      return const Card(child: ListTile(title: Text('Trying to connect...')));
    }
    final Widget storeHeader = ListTile(
      leading: Icon(_isAvailable ? Icons.check : Icons.block,
          color: _isAvailable ? Colors.green : ThemeData.light().errorColor),
      title: Text(
          'The store is ' + (_isAvailable ? 'available' : 'unavailable') + '.'),
    );
    final List<Widget> children = <Widget>[storeHeader];

    if (!_isAvailable) {
      children.addAll([
        const Divider(),
        ListTile(
          title: Text('Not connected',
              style: TextStyle(color: ThemeData.light().errorColor)),
          subtitle: const Text(
              'Unable to connect to the payments processor. Has this app been configured correctly? See the example README for instructions.'),
        ),
      ]);
    }
    return Card(child: Column(children: children));
  }

  Card _buildProductList() {
    if (_loading) {
      return const Card(
          child: (ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Fetching products...'))));
    }
    if (!_isAvailable) {
      return const Card();
    }
    const ListTile productHeader = ListTile(title: Text('Products for Sale'));
    List<ListTile> productList = <ListTile>[];

    if (_notFoundIds.isNotEmpty) {
      productList.add(ListTile(
          title: Text('[${_notFoundIds.join(", ")}] not found',
              style: TextStyle(color: ThemeData.light().errorColor)),
          subtitle: const Text(
              'This app needs special configuration to run. Please see example/README.md for instructions.')));
    }

    productList.addAll(_products.map(
      (ProductDetails productDetails) {
        return ListTile(
            title: Text(
              productDetails.title,
            ),
            subtitle: Text(
              productDetails.description,
            ),
            trailing: TextButton(
              child: Text(productDetails.price),
              style: TextButton.styleFrom(
                backgroundColor: Colors.green[800],
                primary: Colors.white,
              ),
              onPressed: () {
                late PurchaseParam purchaseParam;

                purchaseParam = PurchaseParam(
                  productDetails: productDetails,
                  applicationUserName: null,
                );
                //}

                if (productDetails.id == planID) {
                  _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
                }
              },
            ));
      },
    ));

    return Card(
        child: Column(
            children: <Widget>[productHeader, const Divider()] + productList));
  }

  Card _buildPremiumBox() {
    if (_loading) {
      return const Card(
          child: (ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Fetching consumables...'))));
    }
    if (!_isAvailable || _notFoundIds.contains(planID)) {
      return const Card();
    }
    const ListTile consumableHeader =
        ListTile(title: Text('Purchased consumables'));

    return Card(
        child: Column(children: <Widget>[
      consumableHeader,
      _purchases.length > 0
          ? IconButton(
              icon: const Icon(
                Icons.stars,
                size: 42.0,
                color: Colors.orange,
              ),
              splashColor: Colors.yellowAccent,
              onPressed: () {/*consume(id)*/},
            )
          : Text("pas premium")
    ]));
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    setState(() {
      _purchases.add(purchaseDetails);
      _purchasePending = false;
    });
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {}

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    });
  }
}
*/