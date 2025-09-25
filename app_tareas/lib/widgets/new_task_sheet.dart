// Importa el paquete de Flutter con widgets Material

import 'package:app_tareas/utils/date_utils.dart';
import 'package:flutter/material.dart';

// Widget de formulario para crear una nueva tarea
class NewTaskSheet extends StatefulWidget {
  const NewTaskSheet({
    super.key, // Key opcional para identificar el widget
    required this.onSubmit, // Callback final que recibe (title, note, due)
    this.initialTitle = '', // Título inicial (útil para editar)
    this.initialNote, // Nota inicial (útil para editar)
    this.initialDue, // Fecha inicial (útil para editar)
    this.submitLabel =
        'Crear', // Texto del botón principal (p. ej. "Crear"/"Guardar")
    this.titleText =
        'Nueva tarea', // Título del formulario mostrado en la cabecera
  });

  final void Function(String title, String? note, DateTime? due)
  onSubmit; // Firma del callback de envío
  final String initialTitle; // Valor inicial del campo título
  final String? initialNote; // Valor inicial del campo nota
  final DateTime? initialDue; // Valor inicial del campo fecha
  final String submitLabel; // Texto del botón de acción
  final String titleText;

  @override
  State<NewTaskSheet> createState() => _NewTaskSheetState();
}

// Estado del formulario de nueva tarea
class _NewTaskSheetState extends State<NewTaskSheet> {
  // Llave global para validar el formulario
  final _formKey = GlobalKey<FormState>();
  // Controlador para el campo de título
  late final TextEditingController _titleCtrl;
  // Controlador para el campo de notas
  late final TextEditingController _noteCtrl;
  final _titleFocus = FocusNode();
  final _noteFocus = FocusNode();

  DateTime? _due;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initialTitle); 
    _noteCtrl = TextEditingController(text: widget.initialNote ?? "");
    _due = widget.initialDue;
  }

  Future<void> _pickDueDate() async { 
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _due ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      helpText: "Selecciona una fecha de vencimiento",
      cancelText: "Cancelar",
      confirmText: "Aceptar",
    );
    if (picked != null) {
      setState(() {
        _due = DateTime(picked.year, picked.month, picked.day, 23, 59);
      });
    }
  }

  @override
  void dispose() {
    // Libera la memoria de los controladores cuando se destruye el widget
    _titleCtrl.dispose();
    _noteCtrl.dispose();
    _noteFocus.dispose();
    _titleFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final title = _titleCtrl.text.trim();
    final note = _noteCtrl.text.trim();
    widget.onSubmit(title, note.isEmpty ? null : note, _due);
  }

  @override
  Widget build(BuildContext context) {
    // Widget que representa el formulario
    return Form(
      key: _formKey, // asocia la clave al formulario
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // se ajusta al contenido
        children: [
          // Título del formulario
          Text(
            widget.titleText,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12), // espacio vertical
          // Campo para ingresar el título de la tarea
          TextFormField(
            controller: _titleCtrl, // conecta al controlador de título
            autofocus: true, // abre el teclado automáticamente
            focusNode: _titleFocus,
            textInputAction: TextInputAction.next, // botón "siguiente"
            decoration: const InputDecoration(
              labelText: 'Título de la tarea', // etiqueta visible
              hintText: 'Ej: Preparar guía de ejercicios', // texto de ayuda
              prefixIcon: Icon(Icons.title), // ícono a la izquierda
              border: OutlineInputBorder(), // borde cuadrado
              filled: true, // fondo con color
            ),
            // Valida que el título no esté vacío
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Ingrese un título' : null,
          ),
          const SizedBox(height: 12),

          // Campo para ingresar notas opcionales
          TextFormField(
            controller: _noteCtrl, // conecta al controlador de notas
            focusNode: _noteFocus,
            maxLines: 3, // permite varias líneas
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            decoration: const InputDecoration(
              labelText: 'Notas (no obligatorio)', // etiqueta visible
              prefixIcon: Icon(Icons.note_outlined), // ícono de nota
              border: OutlineInputBorder(),
              filled: true,
            ),
          ),
          const SizedBox(height: 16),

          InkWell(
            onTap: _pickDueDate, 
            borderRadius: const BorderRadius.all(Radius.circular(12)), 
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: "Fecha de vencimiento (Opcional)",
                border: OutlineInputBorder(),
                filled: true,
              ),
              child: Row(
                children: [
                  const Icon(Icons.event),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _due == null ? "Sin Fecha" : formatShortDate(_due!),
                    ),
                  ),
                  if (_due != null)
                    TextButton.icon(
                      onPressed: () => setState(() => _due = null),
                      icon: const Icon(Icons.close),
                      label: const Text("Quitar"),
                    ),
                  TextButton.icon(
                    onPressed: _pickDueDate,
                    icon: const Icon(Icons.edit_calendar),
                    label: Text(_due == null ? "Elegir" : "Cambiar"),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Botón para crear la tarea
          SizedBox(
            height: 48,
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Colors.red, // color de fondo
                  onPrimary: Colors.white, // color del texto/ícono
                ),
              ),
              child: FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check),
                label: Text(widget.submitLabel),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
