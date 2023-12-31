// Flutter imports:
import 'package:QRTest_v2_test1/wallet/my_wallet.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:package_info_plus/package_info_plus.dart';

// Project imports:
import 'package:QRTest_v2_test1/utils/wallet/wallet_utils.dart';
import 'package:QRTest_v2_test1/wfv2/home/wf_home.dart';
import 'package:QRTest_v2_test1/widget/button.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EasyLoading.instance.maskType = EasyLoadingMaskType.black;
    updateInfo();
  }

  String? appName, packageName, version, buildNumber;

  void updateInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      appName = packageInfo.appName;
      packageName = packageInfo.packageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    WalletUtils t1 = WalletUtils.getInstance();
    print(t1.test);
    t1.test = "test2";
    WalletUtils t2 = WalletUtils.getInstance();
    print(t2.test);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            normalButton("Show My Wallet", () {
              // EasyLoading.show(status: 'Sending');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyWalletPage()),
              );
            }),
            const SizedBox(height: 20),
            normalButton("WalletConnect_V2", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WFHomePage()),
              );
            }),
            const SizedBox(height: 20),
            // normalButton("Wallet_Connect_V2", () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => const WCHome()),
            //   );
            // }),
            const SizedBox(height: 60),
            Text("version: $version ($buildNumber)"),
          ],
        ),
      ),
    );
  }
}
