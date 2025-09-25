import 'package:app_tareas/models/task.dart';
import 'package:app_tareas/widgets/taskWidgets/task_card.dart';
import 'package:flutter/material.dart';

class TaskListView extends StatelessWidget {  // Lista de tareas con capacidad de deslizar para eliminar
  const TaskListView({
    super.key,
    required this.items,  // Lista de tareas a mostrar
    required this.onToggle, // Callback al marcar/desmarcar una tarea
    required this.onDelete, // Callback al eliminar una tarea
    required this.dateFormatter, // Función para formatear la fecha
    required this.swipeColor, // Color del fondo al deslizar
    this.empty, // Widget opcional para mostrar cuando la lista está vacía
    this.itemKeyOf, // Función para obtener una clave única para cada tarea
  });

  final List<Task> items; // Lista de tareas a mostrar
  final void Function(Task task, bool done) onToggle; // Callback al marcar/desmarcar una tarea
  final void Function(Task task) onDelete; // Callback al eliminar una tarea
  final String Function(DateTime) dateFormatter; // Función para formatear la fecha
  final Color swipeColor; // Color del fondo al deslizar

  final Widget? empty; // Widget opcional para mostrar cuando la lista está vacía

  final Object? Function(Task task)? itemKeyOf; // Función para obtener una clave única para cada tarea

  @override
  Widget build(BuildContext context) { // Construcción del widget
    if (items.isEmpty) return empty ?? const SizedBox.shrink(); // Si la lista está vacía, muestra el widget vacío o un SizedBox vacío

    return ListView.separated( // Lista separada de tareas
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 96), // Espaciado alrededor de la lista
      separatorBuilder: (_, _) => const SizedBox(height: 4), // Separador entre las tarjetas de tarea
      itemCount: items.length, // Número de tareas en la lista
      itemBuilder: (_, i) {  
        final task = items[i];  
        return TaskCard(
          task: task,
          itemKey: itemKeyOf?.call(task), 
          dateText: task.due != null ? dateFormatter(task.due!) : null, 
          onToggle: (v) => onToggle(task, v), 
          onDismissed: () => onDelete(task), 
          swipeColor: swipeColor, 
        );
      },
    );
  }
}
