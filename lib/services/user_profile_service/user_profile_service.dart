import 'package:flutter/cupertino.dart';

import '../../repository/user_profile_repo/user_profile_repo.dart';


class UserProfileService extends ChangeNotifier{
  final UserProfileRepository repository;

  UserProfileService({required this.repository});

  Future getUserProfileService() async{
    return await repository.getUserProfileRepo();
  }
}