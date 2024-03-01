import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../main.dart';
import '../models/error_model.dart';
import '../utils/app_config.dart';

class ApiClient {
  ApiClient({
    required this.httpClient,
  });

  final http.Client httpClient;

  final _prefs = AppConfig().preferences;

  supabaseLogin(String email, String password) async {
    dynamic result;

    try {
      final response =
          await supabase.auth.signUp(email: email, password: password);

      print("response : ${response.user?.email}");
      await _prefs?.setString(AppConfig.userEmail, "${response.user?.email}");

      print('supabaseLogin user: ${response.user}');
      print('supabaseLogin session: ${response.session}');
      print('supabaseLogin Response : ${response..runtimeType}');

      if (response.runtimeType == AuthResponse) {
        result = AuthResponse();
      } else {
        // result = ErrorModel.fromJson(response.user);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  // Future<bool> login(String email, String password) async {
  //   print("user : $email");
  //   print("password : $password");
  //   bool isLogin;
  //   try {
  //     final result =
  //     await supabase.auth.signUp(email: email, password: password);
  //     // QBLoginResult result = await QB.auth.login("abc", AppConfig.QB_DEFAULT_PASSWORD);
  //
  //     print("result : ${result.runtimeType}");
  //
  //     // QBUser? qbUser = result.qbUser;
  //     // _localUserId = qbUser?.id ?? -1;
  //     // connect(qbUser!.id!);
  //     //test
  //     // connect(136562497);
  //     // on login success store username, password, userid to local
  //     // _pref!.setInt(AppConfig.QB_CURRENT_USERID, _localUserId!);
  //
  //     Session? _session = result.session;
  //     session = _session;
  //     // QBSession? session = await QB.auth.startSessionWithToken(_qbSession!.token!);
  //
  //     isLogin = true;
  //     _pref!.setBool(AppConfig.isSupabaseLogin, true);
  //     _pref!.setInt(AppConfig.getSupabaseSession,
  //         DateTime.parse(_session!.accessToken).millisecondsSinceEpoch);
  //     print("login success..");
  //   } on PlatformException catch (e) {
  //     if (e.code == "Unauthorized" || e.code.contains('401')) {
  //       _errorMsg = "Need User";
  //     } else {
  //       // _errorMsg = makeErrorMessage(e);
  //     }
  //     isLogin = false;
  //     print('login catch error: ${e.message}');
  //   }
  //   return isLogin;
  // }

  Future getUserProfileApi() async {
    dynamic result;

    print("profile data : ${_prefs?.getString(AppConfig.userEmail)}");

    try {
      final response = await supabase
          .from('users')
          .select('*')
          .eq('email', "${_prefs?.getString(AppConfig.userEmail)}");

      print("profile data : $response");
      print("profile type : ${response.runtimeType}");

      if (response.runtimeType == List<Map<String, dynamic>>) {
        result = List<Map<String, dynamic>>;
      } else {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }
}
