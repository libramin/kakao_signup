import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:kakao_signup/kakao_login.dart';
import 'package:kakao_signup/main_view_model.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  kakao.KakaoSdk.init(
    nativeAppKey: '24b44d44dd618c36734c484693ff74e7',
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return TextButton(
                onPressed: () async {
                  await viewModel.login();
                  setState(() {});
                },
                style: TextButton.styleFrom(
                    side: const BorderSide(color: Colors.amber)),
                child: const Text('로그인'),
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  viewModel.isLogined.toString(),
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Image.network(
                    viewModel.user?.kakaoAccount?.profile?.profileImageUrl ??
                        'https://picsum.photos/200'),
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
            );
          }
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
