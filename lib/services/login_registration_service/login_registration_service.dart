import 'package:flutter/material.dart';

import '../../repository/login_registration_repo/login_registration_repo.dart';

class LoginRegistrationService extends ChangeNotifier{
  late final LoginRegistrationRepo repository;

  LoginRegistrationService({required this.repository}) : assert(repository != null);

  Future loginRegistrationService(String email, String password) async{
    return await repository.loginRegistrationRepo(email, password);
  }

}