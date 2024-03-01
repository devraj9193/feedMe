import 'package:feed_me/services/supabase_service/supabase_service.dart';
import 'package:feed_me/splash_screen.dart';
import 'package:feed_me/utils/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  AppConfig().preferences = await SharedPreferences.getInstance();

  print("supabase url : ${AppConfig.supabaseUrl}");
  print("supabase api key : ${AppConfig.supabaseApiKey}");

  Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseApiKey,
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterSizer(builder: (context, orientation, screenType) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => SupabaseService(),
          ),
        ],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        ),
      );
    });
  }
}
