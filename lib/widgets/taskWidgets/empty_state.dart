import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {  
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) { // Inicio del método build
    return Center( 
      child: Padding( 
        padding: const EdgeInsets.all(48), // Espaciado alrededor del contenido
        child: Column( // Columna para organizar los elementos verticalmente
          mainAxisSize: MainAxisSize.min, // Ocupa solo el espacio necesario
          children: [
            Container(
              padding: const EdgeInsets.all(24), // Espacio dentro del contenedor del icono
              decoration: BoxDecoration( 
                shape: BoxShape.circle, 
                gradient: LinearGradient( 
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.1), // Color degradado
                    Theme.of(context).colorScheme.secondary.withOpacity(0.1), // Color degradado
                  ],
                ),
              ),
              child: Icon(  // Icono representativo de tareas
                Icons.checklist_rtl,  // Icono representativo de tareas
                size: 80, // Tamaño del icono
                color: Theme.of(context).colorScheme.primary, // Color del icono
              ),
            ),
            const SizedBox(height: 24), // Espacio entre el icono y el texto
            Text(
              "¡Tu lista está vacía!", // Mensaje principal
              style: TextStyle( // Estilo del texto
                fontSize: 24, // Tamaño de fuente grande
                fontWeight: FontWeight.bold, // Peso de fuente negrita
                color: Theme.of(context).colorScheme.primary, // Color del texto
              ),
            ),
            const SizedBox(height: 12), // Espacio entre el título y el subtítulo
            Text(
              "Crea tu primera tarea presionando el botón +", // Mensaje secundario
              textAlign: TextAlign.center, // Centra el texto
              style: TextStyle( // Estilo del texto secundario
                fontSize: 16, // Tamaño de fuente mediano
                color: Colors.grey.shade600, // Color del texto secundario
                height: 1.4, // Altura de línea para mejor legibilidad
              ),
            ),
            const SizedBox(height: 24), // Espacio antes del consejo
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Espaciado dentro del contenedor del consejo
              decoration: BoxDecoration( // Decoración del contenedor del consejo
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1), // Color de fondo suave
                borderRadius: BorderRadius.circular(20), // Bordes redondeados
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,// Ocupa solo el espacio necesario
                children: [
                  Icon(
                    Icons.lightbulb_outline, // Icono de consejo
                    size: 16, // Tamaño del icono
                    color: Theme.of(context).colorScheme.primary, // Color del icono
                  ),
                  const SizedBox(width: 8),// Espacio entre el icono y el texto
                  Text(
                    "¡Organiza tu día de manera eficiente!", // Texto del consejo
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary, // Color del icono
                      fontWeight: FontWeight.w500, // Peso de fuente semi-negrita
                      fontSize: 12, // Tamaño del texto
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
