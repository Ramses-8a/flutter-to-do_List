import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:to_do_list/controller/user_controller.dart';
import 'package:to_do_list/formulario_tareas.dart';
import 'package:to_do_list/index.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();

    return Drawer(
      backgroundColor: const Color(0xFF1E1E1E),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Obx(
            () => UserAccountsDrawerHeader(
              accountName: Text(
                'Bienvenido',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              accountEmail: Text(
                userController.userEmail.value,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  userController.userEmail.value.isNotEmpty
                      ? userController.userEmail.value[0].toUpperCase()
                      : 'U',
                  style: TextStyle(fontSize: 40.0, color: Color(0xFF1E1E1E)),
                ),
              ),
              decoration: BoxDecoration(color: Color(0xFF2D2D2D)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.list_alt, color: Colors.white),
            title: const Text(
              "Lista de Tareas",
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            onTap: () {
              Navigator.pop(context);
              Get.off(() => const index());
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_task, color: Colors.white),
            title: const Text(
              "Crear Tarea",
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            onTap: () {
              Navigator.pop(context);
              Get.to(() => const FormularioTareas());
            },
          ),
          const Divider(color: Colors.white30),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              "Cerrar sesión",
              style: TextStyle(color: Colors.redAccent, fontSize: 16.0),
            ),
            onTap: () {
              Navigator.pop(context);
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
    );
  }
}

Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(
          0xFF2D2D2D,
        ), // Dark background for the dialog
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ), // Rounded corners
        title: Text(
          'Confirmar cierre se sesión',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ), // White and bold title
        ),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                '¿Estas seguro que quieres cerrar sesión?',
                style: TextStyle(
                  color: Colors.white70,
                ), // Slightly lighter text for content
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Cerrar sesión',
              style: TextStyle(color: Colors.white), // White text for buttons
            ),
            onPressed: () async {
              Navigator.of(context).pop();

              final UserController userController = Get.find<UserController>();

              await Supabase.instance.client.auth.signOut();

              userController.userEmail.value = '';

              Get.offAllNamed('/');
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white), // White text for buttons
            ),
          ),
        ],
      );
    },
  );
}
