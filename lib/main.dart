import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:to_do_list/Login.dart';
import 'package:to_do_list/controller/user_controller.dart';
import 'package:to_do_list/controller/auth_service.dart';
import 'package:to_do_list/controller/task_controller.dart';
import 'package:to_do_list/formulario_tareas.dart';
import 'package:to_do_list/index.dart';
import 'package:to_do_list/formulario_registro.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  Get.put(UserController());
  Get.put(AuthService());
  Get.put(TaskController());
  runApp(MyApp());
}

// It's handy to then extract the Supabase client in a variable for later uses
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Rutas del drawer',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/registro', page: () => const RegistroUsuario()),
        GetPage(name: '/', page: () => const Login()),
        GetPage(name: '/index', page: () => const index()),
        GetPage(name: '/crear_tareas', page: () => const FormularioTareas()),
      ],
    );
  }
}
