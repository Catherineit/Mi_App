// Importa utilidades de Flutter (como ChangeNotifier)
import 'package:flutter/foundation.dart';
// Importa el modelo de datos de tareas
import '../models/task.dart';

// Controlador que maneja la lista de tareas y la lógica
class TaskController extends ChangeNotifier {
  // Lista privada de tareas iniciales (3 de ejemplo)
  final List<Task> _tasks = [
    Task(
      title: 'Revisar Notas de Examen',
      note: 'Verificar las calificaciones en el sistema',
      due: DateTime.now().add(const Duration(days: 1)), // fecha límite mañana
    ),
    Task(title: 'Subir trabajos Pendientes', done: true), // tarea ya completada
    Task(title: 'Crear Material de Estudio'),
  ];

  // Texto para búsqueda
  String _query = '';
  // Filtro actual (todas, pendientes o completadas)
  TaskFilter _filter = TaskFilter.all;

  // ----- Lecturas (getters) -----

  // Devuelve la lista de tareas, pero como lista de solo lectura
  List<Task> get tasks => List.unmodifiable(_tasks);

  // Devuelve el texto de búsqueda actual
  String get query => _query;

  // Devuelve el filtro actual
  TaskFilter get filter => _filter;

  // Devuelve la lista de tareas filtradas por búsqueda y filtro
  List<Task> get filtered {
    final q = _query.trim().toLowerCase(); // texto de búsqueda en minúsculas
    return _tasks.where((t) {
      // Filtra por estado
      final byFilter = switch (_filter) {
        TaskFilter.all => true,    // todas
        TaskFilter.pending => !t.done, // solo no completadas
        TaskFilter.done => t.done,     // solo completadas
      };
      // Filtra por coincidencia con el texto
      final byQuery = q.isEmpty ||
          t.title.toLowerCase().contains(q) ||
          (t.note?.toLowerCase().contains(q) ?? false);

      // La tarea pasa si cumple ambos filtros
      return byFilter && byQuery;
    }).toList();
  }

  // ----- Mutaciones (acciones que cambian datos) -----

  // Cambia el texto de búsqueda
  void setQuery(String value) {
    _query = value;
    notifyListeners(); // avisa a la interfaz de usuario (UI) que hubo un cambio, para que se vuelva a redibujar.
  }

  // Cambia el filtro de tareas
  void setFilter(TaskFilter f) {
    _filter = f;
    notifyListeners();
  }

  // Marca o desmarca una tarea como completada
  void toggle(Task t, bool v) {
    t.done = v;
    notifyListeners();
  }

  // Agrega una nueva tarea al inicio de la lista
  void add(String title, {String? note, DateTime? due}) {
    _tasks.insert(0, Task(title: title, note: note, due: due));
    notifyListeners();
  }

  // Elimina una tarea de la lista
  void remove(Task t) {
    _tasks.remove(t);
    notifyListeners();
  }

  // Restaura una tarea en una posición específica (para funcionalidad de Undo)
  void restoreTask(Task task, int index) {
    // Asegurar que el índice esté dentro del rango válido
    final clampedIndex = index.clamp(0, _tasks.length);
    _tasks.insert(clampedIndex, task);
    notifyListeners();
  }
}
