import 'package:flutter/material.dart';

class SearchField extends StatelessWidget { // Widget para el campo de búsqueda
  const SearchField(
    {super.key,
    required this.onChanged}
    );

    final ValueChanged<String> onChanged; // Función para manejar cambios en el texto

  @override
  Widget build(BuildContext context) { // Construcción del widget
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8), // Margen vertical alrededor del campo de búsqueda
      child: TextField( // Campo de texto para la búsqueda
        onChanged: onChanged, 
        textInputAction: TextInputAction.search, // Acción de búsqueda en el teclado
        decoration: InputDecoration( // Decoración del campo de texto
          hintText: "Buscar tareas...", // Texto de sugerencia
          hintStyle: TextStyle( // Estilo del texto de sugerencia
            color: Colors.grey.shade500, // Color gris para el texto de sugerencia
            fontSize: 16, // Tamaño de fuente estándar
          ),
          prefixIcon: Icon( // Ícono al inicio del campo de texto
            Icons.search,
            color: Theme.of(context).colorScheme.primary, // Color del ícono
            size: 24, // Tamaño del ícono
          ),
          filled: true, // Relleno del campo de texto
          fillColor: Colors.white, // Color de fondo blanco
          border: OutlineInputBorder( // Borde del campo de texto
            borderRadius: BorderRadius.circular(16), // Bordes redondeados
            borderSide: BorderSide( // Estilo del borde
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3), // Color del borde con opacidad
              width: 1, // Ancho del borde
            ),
          ),
          enabledBorder: OutlineInputBorder( // Borde cuando el campo está habilitado
            borderRadius: BorderRadius.circular(16), // Bordes redondeados
            borderSide: BorderSide( // Estilo del borde
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3), // Color del borde con opacidad
              width: 1, // Ancho del borde
            ),
          ),
          focusedBorder: OutlineInputBorder( // Borde cuando el campo está enfocado
            borderRadius: BorderRadius.circular(16), // Bordes redondeados
            borderSide: BorderSide( // Estilo del borde
              color: Theme.of(context).colorScheme.primary, // Color del borde cuando está enfocado
              width: 2, // Ancho del borde
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), // Espaciado interno del campo de texto
        ),
      ),
    );
  }
}