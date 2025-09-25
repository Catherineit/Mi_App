import 'package:flutter/material.dart';

class SwipeBg extends StatelessWidget { // Widget para el fondo al deslizar una tarjeta
  const SwipeBg({super.key, required this.alineacion, required this.color}); // Constructor del widget
  final Alignment alineacion; // Alineación del contenido (izquierda o derecha)
  final Color color; // Color de fondo

  @override
  Widget build(BuildContext context) { // Construcción del widget
    return Container(  // Contenedor que representa el fondo al deslizar
      alignment: alineacion, // Alineación del contenido
      padding: const EdgeInsets.symmetric(horizontal: 16), // Espaciado horizontal
      color: color, // Color de fondo
      child: Row( 
        mainAxisSize: MainAxisSize.min, // Ocupa solo el espacio necesario
        children: const [ 
          Icon(Icons.delete_outlined, color: Colors.white), // Ícono de eliminar
          SizedBox(width: 8), // Espacio entre el ícono y el texto
          Text(
            "Eliminar", // Texto que indica la acción
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600), // Estilo del texto
          ),
        ],
      ),
    );
  }
}
