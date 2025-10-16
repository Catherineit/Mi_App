import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

enum TaskFilter { all, pending, done }

// Repositorio para manejar las tareas en Firestore
class TaskRepository { // Repositorio para manejar las tareas en Firestore
  // Constructor que acepta una instancia de Firestore y la ruta de la colección
    TaskRepository({FirebaseFirestore? db, String collectionPath = 'tasks'}) 
        : _db = db ?? FirebaseFirestore.instance, 
          _collectionPath = collectionPath;

    final FirebaseFirestore _db; // Instancia de Firestore
    final String _collectionPath;

    // Referencia a la colección de tareas en Firestore
    CollectionReference<Map<String, dynamic>> get _tasksCollection => 
        _db.collection(_collectionPath);

    // Crea una nueva tarea en Firestore y devuelve su ID
    Future<String> create(Task task) async {
        final titleTrim = task.title.trim();

        final doc = await _tasksCollection.add({
            'title': titleTrim,
            'note': task.note?.trim(),
            'title_lc': titleTrim.toLowerCase(),
            'done': task.done,
            if (task.note?.trim().isNotEmpty ?? false) "note": task.note!.trim(),
            if (task.due != null) "due": Timestamp.fromDate(task.due!),
            "createdAt": FieldValue.serverTimestamp(),
        });
        return doc.id;
    }

    // Obtiene todas las tareas
    Future<List<({String id, Task task})>> findAll({
        TaskFilter filter = TaskFilter.all, 
        String query = ''
    }) async {
        Query<Map<String, dynamic>> q = _tasksCollection;
        
        switch (filter) {
            case TaskFilter.pending:
                q = q.where("done", isEqualTo: false);
                break;
            case TaskFilter.done:
                q = q.where("done", isEqualTo: true);
                break;
            case TaskFilter.all:
                break;
        }

        final text = query.trim().toLowerCase();
        if (text.isNotEmpty) {
            q = q.orderBy("title_lc").startAt([text]).endAt([text + '\uf8ff']);
        } else {
            q = q.orderBy("createdAt", descending: true);
        }
        
        final snap = await q.get();
        return snap.docs.map((d) => (id: d.id, task: _fromDoc(d))).toList();
    }

    // Actualiza una tarea existente en Firestore
    Future<void> update(String id, Task task) async {
        final titleTrim = task.title.trim();
        
        await _tasksCollection.doc(id).update({
            'title': titleTrim,
            'title_lc': titleTrim.toLowerCase(),
            'done': task.done,
            if (task.note?.trim().isNotEmpty ?? false) 
                "note": task.note!.trim()
            else 
                "note": FieldValue.delete(),
            if (task.due != null) 
                "due": Timestamp.fromDate(task.due!)
            else 
                "due": FieldValue.delete(),
        });
    }

    // Elimina una tarea
    Future<void> delete(String id) async {
        await _tasksCollection.doc(id).delete();
    }

    // Convierte un documento de Firestore en un objeto Task
    Task _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
        final data = doc.data() ?? const <String, dynamic>{};
        return Task(
            title: (data['title'] as String?)?.trim() ?? '',
            done: (data['done'] as bool?) ?? false,
            note: (data['note'] as String?)?.trim(),
            due: (data['due'] is Timestamp ? (data['due'] as Timestamp).toDate() : null),
        );
    }

    // Marca una tarea como completada o no completada
    Future<void> setDone(String id, bool done) async {
        await _tasksCollection.doc(id).update({
            'done': done,
        });
    }
}

