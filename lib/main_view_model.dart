import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:kakao_signup/firebase_auth_remote_data_source.dart';
import 'package:kakao_signup/social_login.dart';

class MainViewModel {
  final _firebaseAuthDataSource = FirebaseAuthRemoteDataSource();
  final SocialLogin _socialLogin;
  bool isLogined = false;
  kakao.User? user;

  MainViewModel(this._socialLogin);

  Future login ()async{
    isLogined = await _socialLogin.login();
    if(isLogined){
      user = await kakao.UserApi.instance.me();

      final token = await _firebaseAuthDataSource.createCustomToken({
        'uid' : user!.id.toString(),
        'displayName' : user!.kakaoAccount!.profile!.nickname,
        'email': user!.kakaoAccount!.email,
        'photoURL' : user!.kakaoAccount!.profile!.profileImageUrl,
        'sex': user!.kakaoAccount!.gender.toString(),
        'birth' : user!.kakaoAccount!.birthday,
      });

      await FirebaseAuth.instance.signInWithCustomToken(token);
    }
  }

  Future logout ()async{
    await _socialLogin.logout();
    // await FirebaseAuth.instance.currentUser?.delete();
    isLogined = false;
    user = null;
    await FirebaseAuth.instance.signOut();
  }
}