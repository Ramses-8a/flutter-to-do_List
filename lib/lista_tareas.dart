import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:to_do_list/constants.dart';
import 'package:to_do_list/controller/task_controller.dart';
import 'package:to_do_list/formulario_editar_tareas.dart';
import 'package:get/get.dart';

class ListaTareas extends StatefulWidget {
  const ListaTareas({Key? key}) : super(key: key);

  @override
  State<ListaTareas> createState() => _ListaTareasState();
}

class _ListaTareasState extends State<ListaTareas> {
  final TaskController _taskController = Get.find<TaskController>();

  @override
  void initState() {
    super.initState();
    _taskController.refreshTasks();
  }

  Future<void> _updateTaskStatus(int taskId, bool newStatus) async {
    final success = await _taskController.updateTaskStatus(taskId, newStatus);
    if (success) {
      // Actualizar el observable inmediatamente para mejor UX
      final taskIndex = _taskController.tareas.indexWhere(
        (task) => task['id'] == taskId,
      );
      if (taskIndex != -1) {
        _taskController.tareas[taskIndex]['estatus'] = newStatus;
        _taskController.tareas.refresh(); // Notificar cambios
      }
    } else {
      // Mostrar error si falla la actualización
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al actualizar el estado de la tarea'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _eliminarTarea(int taskId) async {
    final success = await _taskController.deleteTask(taskId);
    if (success) {
      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tarea eliminada correctamente'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      // Recargar la lista
      _taskController.refreshTasks();
    } else {
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al eliminar la tarea'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_taskController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!_taskController.isLoading.value && _taskController.tareas.isEmpty) {
        return const Center(
          child: Text(
            'No hay tareas para mostrar',
            style: TextStyle(color: AppColors.white),
          ),
        );
      }

      return Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                bottom: 90, // Límite desde abajo
              ),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _taskController.tareas.length,
                itemBuilder: (context, index) {
                  final tarea = _taskController.tareas[index];
                  return Card(
                    color: AppColors.cardBackground,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 12.0),
                            child: Transform.scale(
                              scale: 1.2,
                              child: Checkbox(
                                value: tarea['estatus'] ?? false,
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    _updateTaskStatus(tarea['id'], value);
                                  }
                                },
                                activeColor: Colors.green,
                                checkColor: Colors.white,
                                side: const BorderSide(
                                  color: AppColors.white70,
                                ),
                                shape: const CircleBorder(),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tarea['titulo'] ?? 'Sin título',
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  tarea['contenido'] ?? 'Sin contenido',
                                  style: const TextStyle(
                                    color: AppColors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await Get.to(
                                () => FormularioEditarTareas(tarea: tarea),
                              );
                              // La lista se actualiza automáticamente con los observables
                            },
                            icon: const Icon(Icons.edit, color: Colors.green),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: const Color(0xFF2D2D2D),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    title: const Text(
                                      'Confirmar eliminación',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: const Text(
                                      '¿Estás seguro de que quieres eliminar esta tarea?',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          _eliminarTarea(tarea['id']);
                                        },
                                        child: const Text(
                                          'Eliminar',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed:
                                            () => Navigator.of(context).pop(),
                                        child: const Text(
                                          'Cancelar',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    }); // Cierre del Obx()
  }
}
