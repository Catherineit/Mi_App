import 'package:app_tareas/widgets/new_task_sheet.dart';
import 'package:flutter/material.dart';

class NewTaskFab extends StatefulWidget {
  const NewTaskFab({
    super.key, // Key opcional para identificar el widget en el árbol
    required this.onSubmit, // Callback requerido: recibe (title, note, due)
    this.onCreated, // Callback opcional tras crear (p. ej., mostrar SnackBar)
    this.labelText = 'Nueva', // Texto por defecto del FAB
    this.icon = Icons.add, // Ícono por defecto del FAB
  });

  final void Function(String title, String? note, DateTime? due)
  onSubmit; // Define parámetros a propagar
  final VoidCallback?
  onCreated; // Callback opcional ejecutado si el sheet retorna éxito
  final String labelText; // Texto visible en el FAB
  final IconData icon; // Ícono visible en el FAB

  @override
  State<NewTaskFab> createState() => _NewTaskFabState();
}

class _NewTaskFabState extends State<NewTaskFab> { // Estado del FAB para nueva tarea
  @override
  Widget build(BuildContext context) { // Construcción del widget
    return FloatingActionButton.extended( // FAB extendido con ícono y texto
      icon: Icon(widget.icon), // Ícono del FAB 
      label: Text(widget.labelText), // Texto del FAB
      onPressed: () async {  // Acción al presionar el FAB
        final currentContext = context; // Contexto actual para el modal
        final created = await showModalBottomSheet( // Muestra el modal para nueva tarea
          context: currentContext, // Contexto para el modal
          isScrollControlled: true, // Permite que el modal ocupe más espacio
          shape: const RoundedRectangleBorder( // Bordes redondeados en la parte superior
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)), // Radio de los bordes
          ),
          builder: (ctx) => Padding( // Padding para evitar solapamiento con el teclado
            padding: EdgeInsets.only( // Espaciado dinámico
              left: 16, // Espacio a la izquierda
              right: 16, // Espacio a la derecha
              top: 12, // Espacio arriba
              bottom: 16 + MediaQuery.of(ctx).viewInsets.bottom, // Espacio abajo considerando el teclado
            ),
            child: NewTaskSheet( // Widget para crear una nueva tarea
              onSubmit: (title, note, due) { // Callback al enviar la tarea
                widget.onSubmit(title, note, due); // Llama al callback del widget padre
                Navigator.pop(ctx, true); // Cierra el modal y retorna éxito
              }, 
            ),
          ),
        );
        if ((created ?? false) && widget.onCreated != null) { // Si se creó y hay callback
          if (mounted) widget.onCreated!(); // Llama al callback de creación
        }
      },
    );
  }
}
