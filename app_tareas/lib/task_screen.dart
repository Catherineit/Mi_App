import 'package:app_tareas/controllers/task_contoller.dart';
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
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
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
                          onToggle: (t, v) => _ctrl.toggle(t, v),
                          onDelete: (t) {
                            _ctrl.remove(t);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Tarea Eliminada")),
                            );
                          },
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
