import 'package:app_tareas/models/task.dart';
import 'package:flutter/material.dart';

class FilterChipsRow extends StatelessWidget { // Fila de chips de filtro
  const FilterChipsRow({ // Constructor de la fila de chips de filtro
    super.key,
    required this.value, // Filtro seleccionado actualmente
    required this.onChanged, // Función para manejar cambios en el filtro
    this.color, // Color personalizado para los chips
  });

  final TaskFilter value; // Filtro seleccionado actualmente
  final ValueChanged<TaskFilter> onChanged; // Función para manejar cambios en el filtro
  final Color? color; // Color personalizado para los chips

  @override
  Widget build(BuildContext context) { // Construcción del widget
    final active = color ?? Theme.of(context).colorScheme.primary;  // Color activo para los chips

    ChoiceChip chip(String label, TaskFilter f) => ChoiceChip(  // Definición de un chip de opción
      label: Text(
        label,
        style: TextStyle(
          color: value == f ? Colors.white : active,  // Color del texto según selección
          fontWeight: value == f ? FontWeight.bold : FontWeight.w500,// Peso del texto según selección
          fontSize: 14, //  Tamaño de fuente estándar
        ),
      ),
      selected: value == f, // Si el chip está seleccionado
      selectedColor: active, // Color cuando está seleccionado
      backgroundColor: Colors.white, // Color de fondo cuando no está seleccionado
      elevation: value == f ? 4 : 1, // Elevación según selección
      shadowColor: active.withOpacity(0.3), // Sombra más sutil
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),// Bordes redondeados
        side: BorderSide( // Borde del chip
          color: value == f ? active : active.withOpacity(0.3), // Borde más sutil
          width: value == f ? 2 : 1, // Ancho del borde según selección
        ),
      ),
      onSelected: (_) => onChanged(f), // Llama a la función onChanged cuando se selecciona el chip
    );
    return Container( // Contenedor para la fila de chips
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12), // Espaciado alrededor de los chips
      child: Wrap( // Usa Wrap para que los chips se ajusten automáticamente
        spacing: 12, // Espacio horizontal entre chips
        runSpacing: 8, // Espacio vertical entre filas de chips
        children: [
          chip("Todas", TaskFilter.all), // Chip para todas las tareas
          chip("Pendientes", TaskFilter.pending), // Chip para tareas pendientes
          chip("Completas", TaskFilter.done) // Chip para tareas completadas
        ],
      ),
    );
  }
}
