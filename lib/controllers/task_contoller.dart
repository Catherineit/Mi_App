// Importa utilidades de Flutter (como ChangeNotifier)
import 'package:flutter/foundation.dart';
// Importa el modelo de datos de tareas
import '../models/task.dart';
// Importa el repositorio de tareas
import '../repositories/task_repository.dart';
// Importa Firebase
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

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

  // Devuelve la lista de tareas filtradas por búsqueda y filtro, ordenadas por fecha
  List<Task> get filtered {
    final q = _query.trim().toLowerCase(); // texto de búsqueda en minúsculas
    final filteredTasks = _tasks.where((t) {
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

    // Ordenar tareas por fecha de forma ascendente (comportamiento por defecto)
    _sortTasksByDate(filteredTasks);
    
    return filteredTasks;
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

  // ----- Métodos privados de ordenamiento -----

  // Ordena una lista de tareas por fecha de forma ascendente
  void _sortTasksByDate(List<Task> tasks) {
    tasks.sort((a, b) {
      // Primero, separar tareas completadas de las pendientes
      // Las tareas completadas van al final
      if (a.done != b.done) {
        return a.done ? 1 : -1; // Tareas completadas al final
      }

      // Luego ordenar por fecha dentro de cada grupo
      final dateA = a.due;
      final dateB = b.due;

      // Si ninguna tiene fecha, mantener orden actual
      if (dateA == null && dateB == null) {
        return 0;
      }

      // Las tareas sin fecha van al final de su grupo respectivo
      if (dateA == null) return 1;
      if (dateB == null) return -1;

      // Ordenar por fecha ascendente (fechas más próximas primero)
      return dateA.compareTo(dateB);
    });
  }

  // Método público para reordenar todas las tareas (útil para refrescar el orden)
  void sortAllTasks() {
    _sortTasksByDate(_tasks);
    notifyListeners();
  }

  // Inicializa Firebase (debe llamarse una vez al inicio de la aplicación)
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
