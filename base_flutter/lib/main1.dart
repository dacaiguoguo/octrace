import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  String getStr = "";

  // ignore: unused_element
  _getIPAddress() async {
    var testUrl = "https://itunes.apple.com/lookup?id=475966832";
    // var testUrl = "http://10.200.5.103/users/sign_in";
    var httpClient = HttpClient();
    httpClient.connectionTimeout = const Duration(seconds: 3);

    String result;
    try {
      var request = await httpClient.getUrl(Uri.parse(testUrl));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var data = await response.transform(utf8.decoder).join();
        var data2 = jsonDecode(data);

        // print(data.toString());
        result = data2;

        //result = data['origin'];
        //  print("result --- > "+result);
      } else {
        result =
            '22 Error getting IP address:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = '22Failed getting IP address';
    }
    // If the widget was removed from the tree while the message was in flight,
    // we want to discard the reply rather than calling setState to update our
    // non-existent appearance.
    if (!mounted) return;
    setState(() {
      getStr = result;
    });
  }

  void getDioRequestFunction0() async {
    late Client client;
    if (Platform.isIOS) {
      final config = URLSessionConfiguration.ephemeralSessionConfiguration()
        ..allowsCellularAccess = false
        ..allowsConstrainedNetworkAccess = false
        ..allowsExpensiveNetworkAccess = false;
      client = CupertinoClient.fromSessionConfiguration(config);
    } else {}

    final response = await client.get(Uri.https(
      'httpbin.org',
      '/ip',
    ));
    setState(() {
      getStr = response.body.toString();
    });
  }

  void getDioRequestFunction() async {
    ///创建Dio对象
    Dio dio = Dio();
    dio.httpClientAdapter = NativeAdapter(
      cupertinoConfiguration:
          URLSessionConfiguration.ephemeralSessionConfiguration()
            ..allowsCellularAccess = false
            ..allowsConstrainedNetworkAccess = false
            ..allowsExpensiveNetworkAccess = false,
    );
    if (kDebugMode) {
      print('dio.httpClientAdapter');
      print(dio.httpClientAdapter);
    }

    ///请求地址 获取用户列表
    String url = "https://httpbin.org/ip";

    ///发起get请求
    var response = await dio.get(url);

    ///响应数据
    var data = response.data;
    setState(() {
      getStr = data.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
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
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You5 have pushed the button this many times:',
            ),
            Text(
              getStr,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getDioRequestFunction,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
