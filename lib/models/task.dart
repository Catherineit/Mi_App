// Clase que representa una tarea
class Task {
  // Constructor de la clase Task
  Task({
    required this.title, // el título es obligatorio
    this.done = false,   // por defecto la tarea no está completada
    this.note,           // nota opcional
    this.due,            // fecha opcional de vencimiento
  });

  String title;      // título de la tarea
  bool done;         // estado: true si está completada
  String? note;      // texto con una nota opcional (puede ser null)
  DateTime? due;     // fecha límite opcional (puede ser null)
}
