import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_list/controller/task_controller.dart';

class FormularioEditarTareas extends StatefulWidget {
  final Map<String, dynamic> tarea;

  const FormularioEditarTareas({Key? key, required this.tarea})
    : super(key: key);

  @override
  State<FormularioEditarTareas> createState() => _FormularioEditarTareasState();
}

class _FormularioEditarTareasState extends State<FormularioEditarTareas> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _contenidoController = TextEditingController();
  final TaskController _taskController = Get.find<TaskController>();
  final RxBool _isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    // Cargar los datos de la tarea en los controladores
    _tituloController.text = widget.tarea['titulo'] ?? '';
    _contenidoController.text = widget.tarea['contenido'] ?? '';
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _contenidoController.dispose();
    super.dispose();
  }

  void _actualizarTarea() async {
    // Validar que los campos no estén vacíos
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_formKey.currentState!.validate()) {
      _isLoading.value = true;

      try {
        final success = await _taskController.updateTask(
          widget.tarea['id'],
          _tituloController.text,
          _contenidoController.text,
        );

        if (success) {
          // Refrescar la lista de tareas
          await _taskController.refreshTasks();

          // Mostrar mensaje de éxito
          Get.snackbar(
            'Éxito',
            'Tarea actualizada correctamente',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
            margin: const EdgeInsets.all(10),
            borderRadius: 10,
          );

          // Cerrar el formulario después de mostrar el mensaje
          await Future.delayed(const Duration(seconds: 1));
          Get.back();
        } else {
          Get.snackbar(
            'Error',
            'No se pudo actualizar la tarea',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
  
            margin: const EdgeInsets.all(10),
            borderRadius: 10,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Error al actualizar la tarea: ${e.toString()}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(10),
          borderRadius: 10,
        );
      } finally {
        _isLoading.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Editar Tarea'),
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(
            () => Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.white),
                  onPressed: _isLoading.value ? null : _actualizarTarea,
                ),
                if (_isLoading.value)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF121212),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF2C2C2C),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  errorStyle: const TextStyle(
                    color: Colors.red,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El título no puede estar vacío';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _contenidoController,
                decoration: InputDecoration(
                  labelText: 'Contenido',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF2C2C2C),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  errorStyle: const TextStyle(
                    color: Colors.red,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El contenido no puede estar vacío';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: _isLoading.value ? null : _actualizarTarea,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C2C2C),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:
                        _isLoading.value
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              'ACTUALIZAR',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
