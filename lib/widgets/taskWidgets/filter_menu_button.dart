import 'package:flutter/material.dart';
import '../../repositories/task_repository.dart';

class FilterMenuButton extends StatelessWidget { // Widget para el botón de menú de filtro
  const FilterMenuButton({ // Constructor del botón de menú de filtro
    super.key,
    required this.value, // Filtro seleccionado actualmente
    required this.onChanged, // Función para manejar cambios en el filtro
  });

  final TaskFilter value; // Filtro seleccionado actualmente
  final ValueChanged<TaskFilter> onChanged; // Función para manejar cambios en el filtro

  @override
  Widget build(BuildContext context) { // Construcción del widget
    return PopupMenuButton<TaskFilter>( // Menú desplegable para seleccionar el filtro
      tooltip: "Filtro", // Texto de ayuda al pasar el cursor
      initialValue: value, // Valor inicial del menú
      onSelected: onChanged, // Llama a la función onChanged cuando se selecciona una opción
      itemBuilder: (_)=> const [
        PopupMenuItem(value: TaskFilter.all, child: Text("Todas")), // Opción para todas las tareas
        PopupMenuItem(value: TaskFilter.pending, child: Text("Pendientes")), // Opción para tareas pendientes
        PopupMenuItem(value: TaskFilter.done, child: Text("Completas")), // Opción para tareas completadas
      ],
      icon: const Icon(Icons.filter_list) // Ícono del botón del menú
    );
  }
}
