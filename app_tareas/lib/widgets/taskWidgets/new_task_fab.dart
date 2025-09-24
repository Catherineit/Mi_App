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

class _NewTaskFabState extends State<NewTaskFab> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      icon: Icon(widget.icon),
      label: Text(widget.labelText),
      onPressed: () async {
        final currentContext = context;
        final created = await showModalBottomSheet(
          context: currentContext,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (ctx) => Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: 16 + MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: NewTaskSheet(
              onSubmit: (title, note, due) {
                widget.onSubmit(title, note, due);
                Navigator.pop(ctx, true);
              },
            ),
          ),
        );
        if ((created ?? false) && widget.onCreated != null) {
          if (mounted) widget.onCreated!();
        }
      },
    );
  }
}
