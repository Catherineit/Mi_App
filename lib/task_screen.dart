import 'package:app_tareas/controllers/task_contoller.dart';
import 'package:app_tareas/models/task.dart';
import 'package:app_tareas/utils/date_utils.dart';
import 'package:app_tareas/widgets/taskWidgets/empty_state.dart';
import 'package:app_tareas/widgets/taskWidgets/filter_chips_row.dart';
import 'package:app_tareas/widgets/taskWidgets/filter_menu_button.dart';
import 'package:app_tareas/widgets/taskWidgets/new_task_fab.dart';
import 'package:app_tareas/widgets/taskWidgets/search_field.dart';
import 'package:app_tareas/widgets/taskWidgets/task_list_view.dart';
import 'package:flutter/material.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late final TaskController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TaskController();
    // Carga las tareas después de que el primer frame se haya renderizado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ctrl.loadTasks();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // Método para mostrar confirmación de eliminación
  void _showDeleteConfirmation(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text('Eliminar Tarea'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Estás seguro de que quieres eliminar esta tarea?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.task_alt,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        task.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _deleteTaskWithUndo(context, task);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.delete, size: 18),
              label: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  // Método para eliminar tarea con opción de deshacer
  void _deleteTaskWithUndo(BuildContext context, Task task) {
    // Guardar el índice original de la tarea para restaurarla en la misma posición
    final originalIndex = _ctrl.tasks.indexOf(task);
    
    // Eliminar la tarea
    _ctrl.remove(task);

    // Mostrar SnackBar con opción de deshacer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        content: Row(
          children: [
            Icon(
              Icons.delete_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tarea eliminada',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    task.title.length > 30 
                        ? '${task.title.substring(0, 30)}...' 
                        : task.title,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'DESHACER',
          textColor: Colors.white,
          backgroundColor: Colors.white.withOpacity(0.2),
          onPressed: () {
            // Restaurar la tarea en su posición original
            _ctrl.restoreTask(task, originalIndex);
            
            // Mostrar confirmación de restauración
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Row(
                  children: [
                    const Icon(
                      Icons.restore,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Tarea restaurada',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final items = _ctrl.filtered;
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            title: const Text("Mis Tareas"),
            centerTitle: true,
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 8), 
                child: FilterMenuButton(value: _ctrl.filter, onChanged: _ctrl.setFilter),
              ),
            ],
          ),
          floatingActionButton: NewTaskFab(
            onSubmit: (title, note, due) =>
                _ctrl.add(title, note: note, due: due),
            onCreated: () => ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Tarea Creada"))),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.background,
                  Colors.white,
                ],
                stops: const [0.0, 0.3],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: SearchField(onChanged: _ctrl.setQuery),
                  ),
                  FilterChipsRow(
                    value: _ctrl.filter,
                    onChanged: _ctrl.setFilter,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Theme.of(context).colorScheme.primary.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                Expanded(
                  child: items.isEmpty
                      ? const EmptyState()
                      : TaskListView(
                          items: items,
                          onToggle: (t, v) => _ctrl.toggleDone(t, v),
                          onDelete: (t) => _showDeleteConfirmation(context, t),
                          dateFormatter: formatShortDate,
                          swipeColor: Theme.of(context).colorScheme.primary,
                        ),
                ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
