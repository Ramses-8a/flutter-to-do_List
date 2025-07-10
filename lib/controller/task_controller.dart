import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {
  final supabase = Supabase.instance.client;
  
  // Observable para las tareas
  var tareas = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  /// Obtiene todas las tareas del usuario actual
  Future<List<Map<String, dynamic>>> fetchTareas() async {
    try {
      isLoading.value = true;
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        tareas.value = [];
        isLoading.value = false;
        return [];
      }

      final tasksResponse = await supabase
          .from('tareas')
          .select('*')
          .eq('fk_user', userId);

      final tasksList = List<Map<String, dynamic>>.from(tasksResponse);
      tareas.value = tasksList;
      isLoading.value = false;
      return tasksList;
    } catch (e) {
      print('Error fetching tasks: $e');
      tareas.value = [];
      isLoading.value = false;
      return [];
    }
  }

  /// Método para refrescar las tareas y notificar a los widgets que las observan
  Future<void> refreshTasks() async {
    // Este método puede ser llamado desde cualquier parte de la aplicación
    // para forzar una actualización de las tareas
    await fetchTareas();
  }
  
  @override
  void onInit() {
    super.onInit();
    // Cargar tareas al inicializar el controlador
    fetchTareas();
  }

  /// Actualiza el estatus de una tarea específica
  Future<bool> updateTaskStatus(int taskId, bool newStatus) async {
    try {
      await supabase
          .from('tareas')
          .update({'estatus': newStatus})
          .eq('id', taskId);

      return true;
    } catch (e) {
      print('Error updating task status: $e');
      return false;
    }
  }

  /// Elimina una tarea específica
  Future<bool> deleteTask(int taskId) async {
    try {
      await supabase.from('tareas').delete().eq('id', taskId);

      return true;
    } catch (e) {
      print('Error deleting task: $e');
      return false;
    }
  }

  /// Actualiza una tarea específica
  Future<bool> updateTask(int taskId, String titulo, String contenido) async {
    try {
      // Validar que los campos no estén vacíos
      if (titulo.trim().isEmpty || contenido.trim().isEmpty) {
        return false;
      }

      await supabase
          .from('tareas')
          .update({'titulo': titulo.trim(), 'contenido': contenido.trim()})
          .eq('id', taskId);

      return true;
    } catch (e) {
      print('Error updating task: $e');
      return false;
    }
  }

  /// Crea una nueva tarea
  Future<bool> createTask(String titulo, String contenido) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        return false;
      }

      await supabase.from('tareas').insert({
        'titulo': titulo,
        'contenido': contenido,
        'estatus': false,
        'fk_user': userId,
      });

      return true;
    } catch (e) {
      print('Error creating task: $e');
      return false;
    }
  }
}
