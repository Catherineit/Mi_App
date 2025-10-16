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
  // Repositorio para manejar persistencia
  final TaskRepository _repository;
  // Lista interna de tareas
  List<Task> _tasks = [];
  // Mapa para relacionar tareas con sus IDs de Firebase
  final Map<Task, String> _taskIds = {};

  // Constructor que acepta un repositorio opcional
  TaskController({TaskRepository? repository})
      : _repository = repository ?? TaskRepository() {
    // Cargar tareas de forma asíncrona
    _loadTasks();
  }

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
  // Carga inicial de tareas
  Future<void> _loadTasks() async {
    await _reloadFromRepository();
  }

  // Método público para cargar tareas
  Future<void> loadTasks() => _reloadFromRepository();

  // Recarga las tareas desde el repositorio
  Future<void> _reloadFromRepository() async {
    try {
      final rows = await _repository.findAll(filter: _filter, query: _query);
      _tasks.clear();
      _tasks.addAll(rows.map((r) => r.task));

      _taskIds.clear();
      _taskIds.addEntries(rows.map((r) => MapEntry(r.task, r.id)));
      
      _sortTasksByDate(_tasks);
      notifyListeners(); // avisa a la UI que hubo un cambio
    } catch (e) {
      // En caso de error con Firebase, usar datos locales por defecto
      _tasks = [
        Task(title: 'Revisar Notas de Examen', note: 'Verificar las calificaciones en el sistema'),
        Task(title: 'Estudiar Flutter', note: 'Repasar widgets y navegación'),
        Task(title: 'Completar Proyecto', note: 'Finalizar la aplicación de tareas'),
      ];
      _sortTasksByDate(_tasks);
      notifyListeners();
    }
  }

  // ----- Mutaciones (acciones que cambian datos) -----

  // Cambia el texto de búsqueda
  void setQuery(String value) {
    _query = value;
    notifyListeners(); // avisa a la interfaz de usuario (UI) que hubo un cambio, para que se vuelva a redibujar.
  }

  // Cambia el filtro de tareas
  Future<void> setFilter(TaskFilter f) async {
    _filter = f;
    await _reloadFromRepository();
  }

  // Marca o desmarca una tarea como completada y sincroniza con Firebase
  Future<void> toggleDone(Task task, bool done) async {
    final id = _taskIds[task];
    if (id == null) {
      // Si no tenemos el ID, recargar desde Firebase
      await _reloadFromRepository();
      return;
    }
    
    // Actualizar en Firebase
    await _repository.setDone(id, done);
    
    // Actualizar localmente
    task.done = done;
    
    // Reordenar y notificar
    _sortTasksByDate(_tasks);
    notifyListeners();
  }

  // Agrega una nueva tarea al inicio de la lista
  Future<void> add(String title, {String? note, DateTime? due}) async {
    final task = Task(title: title, note: note, due: due);
    try {
      await _repository.create(task);
      await _reloadFromRepository();
    } catch (e) {
      // Si falla la persistencia, agregar localmente
      _tasks.insert(0, task);
      _sortTasksByDate(_tasks);
      notifyListeners();
    }
  }

  // Elimina una tarea de la lista y de Firebase
  Future<void> remove(Task task) async {
    final id = _taskIds[task]; // Obtener el ID de la tarea
    if (id == null) { // Si no se encuentra el ID, recargar desde el repositorio
      await _reloadFromRepository();
      return;
    }
    
    // Eliminar de Firebase
    await _repository.delete(id);
    
    // Recargar datos actualizados
    await _reloadFromRepository();
  }

  // Actualiza una tarea existente en Firebase
  Future<void> updateTask(Task task, {String? newTitle, String? newNote, DateTime? newDue}) async {
    final id = _taskIds[task];
    if (id == null) {
      await _reloadFromRepository();
      return;
    }

    // Actualizar el objeto Task localmente
    if (newTitle != null) task.title = newTitle;
    if (newNote != null) task.note = newNote;
    task.due = newDue; // Permite null para eliminar fecha

    // Actualizar en Firebase
    await _repository.update(id, task);
    
    // Reordenar y notificar
    _sortTasksByDate(_tasks);
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
