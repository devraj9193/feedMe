
import '../../services/api_service.dart';

class LoginRegistrationRepo{
  ApiClient apiClient;

  LoginRegistrationRepo({required this.apiClient}) : assert(apiClient != null);

  Future loginRegistrationRepo(String email, String password) async{
    return await apiClient.supabaseLogin(email, password);
  }

}