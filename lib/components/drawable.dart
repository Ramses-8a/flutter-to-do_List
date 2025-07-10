import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:to_do_list/controller/user_controller.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1E1E1E),
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Text(
                  "Lista de que hacer",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text(
              "Cerrar sesión",
              style: TextStyle(color: Colors.white, fontSize: 20.0),
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

              userController.UserEmail.value = null;

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
