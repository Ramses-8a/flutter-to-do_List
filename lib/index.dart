import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_list/components/drawable.dart';
import 'package:to_do_list/lista_tareas.dart';
import 'package:to_do_list/constants.dart';

class index extends StatelessWidget {
  const index({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de tareas'),
        backgroundColor: AppColors.primaryBackground,
        foregroundColor: AppColors.white,
      ),
      drawer: CustomDrawer(),
      backgroundColor: AppColors.primaryBackground,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Expanded(child: ListaTareas()),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: SizedBox(
          height: 60.0, // Ajusta la altura del botón
          width:
              double
                  .infinity, // Hace que el botón ocupe todo el ancho disponible
          child: FloatingActionButton.extended(
            onPressed: () {
              Get.toNamed('/crear_tareas');
            },
            label: const Text('Añadir Tarea'),
            icon: const Icon(Icons.add),
            backgroundColor: AppColors.buttonBackground,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
