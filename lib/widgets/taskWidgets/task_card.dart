import 'package:app_tareas/models/task.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {  // Tarjeta individual para una tarea
  const TaskCard({  
    super.key,
    required this.task, // Tarea representada por la tarjeta
    required this.onToggle, // Callback al marcar/desmarcar la tarea
    required this.onDismissed, // Callback al eliminar la tarea
    required this.swipeColor, // Color del fondo al deslizar
    this.dateText,  // Texto opcional para la fecha
    this.itemKey, // Clave opcional para Dismissible
  });

  final Task task;
  final ValueChanged<bool> onToggle;  // Callback al marcar/desmarcar
  final VoidCallback onDismissed;  // Callback al eliminar la tarea
  final Color swipeColor;   // Color del fondo al deslizar
  final String? dateText; // Texto opcional para la fecha
  final Object? itemKey;  // Clave opcional para Dismissible

  @override
  Widget build(BuildContext context) {
    final k = itemKey ?? '${task.title}-${task.hashCode}'; // Clave única para Dismissible
    return Dismissible(
      key: ValueKey(k),
      // Solo permitir swipe hacia la izquierda para eliminar
      direction: DismissDirection.endToStart,
      background: Container(), // Sin fondo para swipe derecha
      secondaryBackground: Container( // Fondo para swipe izquierda (eliminar)
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.red.shade400,
              Colors.red.shade600,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delete_outline,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(height: 4),
            const Text(
              'Eliminar',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      // Configurar umbral para activar el dismiss
      dismissThresholds: const {
        DismissDirection.endToStart: 0.3,
      },
      onDismissed: (_) => onDismissed(), // Acción al completar el deslizamiento
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), // Espaciado entre tarjetas
        decoration: BoxDecoration( // Decoración de la tarjeta
          borderRadius: BorderRadius.circular(16),// Bordes redondeados
          gradient: LinearGradient( // Degradado de fondo
            begin: Alignment.topLeft, // Inicio del degradado
            end: Alignment.bottomRight, // Fin del degradado
            colors: task.done 
                ? [Colors.grey.shade100, Colors.grey.shade200] // Degradado para tareas completadas
                : [Colors.white, const Color(0xFFF8F7FF)],// Degradado para tareas pendientes
          ),
          boxShadow: [
            BoxShadow(// Sombra para dar profundidad
              color: task.done
                  ? Colors.grey.withOpacity(0.2) // Sombra más sutil para tareas completadas
                  : const Color(0xFF7B2CBF).withOpacity(0.15), // Sombra para tareas pendientes
              blurRadius: 8, // Radio de desenfoque de la sombra
              offset: const Offset(0, 4),// Desplazamiento de la sombra
            ),
          ],
          border: Border.all( // Borde de la tarjeta
            color: task.done
                ? Colors.grey.shade300 // Borde más sutil para tareas completadas
                : const Color(0xFF7B2CBF).withOpacity(0.2), // Borde para tareas pendientes
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent, // Hace que el material sea transparente para mostrar el fondo
          borderRadius: BorderRadius.circular(16), // Bordes redondeados consistentes
          child: CheckboxListTile(
            value: task.done,
            onChanged: (v) => onToggle(v ?? false), // Cambia el estado de la tarea al marcar/desmarcar
            checkboxShape: RoundedRectangleBorder( // Forma del checkbox
              borderRadius: BorderRadius.circular(6), // Bordes ligeramente redondeados
            ),
            activeColor: const Color(0xFF7B2CBF),// Color del checkbox cuando está activo
            checkColor: Colors.white, // Color del check dentro del checkbox
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.done ? TextDecoration.lineThrough : null, // Línea tachada si la tarea está completada
                fontSize: 16,  // Tamaño de fuente consistente
                fontWeight: task.done ? FontWeight.w400 : FontWeight.w600, // Peso de fuente según estado
                color: task.done ? Colors.grey.shade600 : const Color(0xFF2D1B69), // Color del texto según estado
              ),
            ),
            subtitle: Column( // Columna para nota y fecha
              crossAxisAlignment: CrossAxisAlignment.start, // Alineación al inicio
              children: [
                if (task.note != null && task.note!.isNotEmpty) // Mostrar nota si existe
                  Container(
                    margin: const EdgeInsets.only(top: 4), // Espacio arriba de la nota
                    child: Text(
                      task.note!,
                      style: TextStyle(
                        color: task.done ? Colors.grey.shade500 : Colors.grey.shade700, // Color de la nota según estado
                        fontSize: 14, // Tamaño de fuente de la nota
                      ),
                    ),
                  ),
                if (dateText != null)
                  Container(
                    margin: const EdgeInsets.only(top: 8), // Espacio arriba de la fecha
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Espaciado dentro del contenedor de la fecha
                    decoration: BoxDecoration( // Decoración del contenedor de la fecha
                      color: task.done
                          ? Colors.grey.shade300 // Color de fondo para tareas completadas
                          : const Color(0xFF7B2CBF).withOpacity(0.1), // Color de fondo para tareas pendientes
                      borderRadius: BorderRadius.circular(12), // Bordes redondeados del contenedor de la fecha
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Tamaño mínimo para el contenido
                      children: [
                        Icon(
                          Icons.event, // Icono de calendario
                          size: 16, // Tamaño del icono
                          color: task.done // Color del icono según estado
                              ? Colors.grey.shade600 // Color para tareas completadas
                              : const Color(0xFF7B2CBF), // Color para tareas pendientes
                        ),
                        const SizedBox(width: 6), // Espacio entre el icono y el texto
                        Text(
                          dateText!,
                          style: TextStyle(
                            color: task.done // Color del texto según estado
                                ? Colors.grey.shade600 // Color para tareas completadas
                                : const Color(0xFF7B2CBF), // Color para tareas pendientes
                            fontSize: 12,  // Tamaño de fuente de la fecha
                            fontWeight: FontWeight.w500, // Peso de fuente de la fecha
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            controlAffinity: ListTileControlAffinity.leading, // Coloca el checkbox al inicio
            secondary: Container(
              padding: const EdgeInsets.all(8), // Espaciado dentro del contenedor del icono
              decoration: BoxDecoration( // Decoración del contenedor del icono
                color: task.done 
                    ? Colors.grey.shade200 // Color de fondo para tareas completadas
                    : const Color(0xFF7B2CBF).withOpacity(0.1), // Color de fondo para tareas pendientes
                borderRadius: BorderRadius.circular(8), // Bordes redondeados del contenedor del icono
              ),
              child: Icon( 
                Icons.drag_handle,  // Icono de arrastrar
                color: task.done 
                    ? Colors.grey.shade500 // Color del icono para tareas completadas
                    : const Color(0xFF7B2CBF), // Color del icono para tareas pendientes
                size: 20, // Tamaño del icono
              ),
            ),
          ),
        ),
      ),
    );
  }
}
