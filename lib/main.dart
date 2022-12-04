import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kakao_signup/kakao_login.dart';
import 'package:kakao_signup/main_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
    nativeAppKey: '24b44d44dd618c36734c484693ff74e7',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kakao SignUp',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final viewModel = MainViewModel(KakaoLogin());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('카카오 로그인'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              viewModel.isLogined.toString(),
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Image.network(
                viewModel.user?.kakaoAccount?.profile?.profileImageUrl ??
                    'https://picsum.photos/200'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () async {
                    await viewModel.login();
                    setState(() {});
                  },
                  style: TextButton.styleFrom(
                      side: const BorderSide(color: Colors.amber)),
                  child: const Text('로그인'),
                ),
                TextButton(
                  onPressed: () async {
                    await viewModel.logout();
                    setState(() {});
                  },
                  style: TextButton.styleFrom(
                      side: const BorderSide(color: Colors.amber)),
                  child: const Text('로그아웃'),
                )
              ],
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
