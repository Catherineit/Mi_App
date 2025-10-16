import 'package:app_tareas/login_fields.dart'; // Importa un archivo donde están los campos del formulario de login
import 'package:flutter/material.dart'; // Importa el paquete de Flutter para construir la interfaz

class LoginScreen extends StatelessWidget { // Crea una pantalla de login que no cambia (StatelessWidget)
  const LoginScreen({super.key}); // Constructor que permite pasar una clave única al widget

  @override
  Widget build(BuildContext context) {
    // Construye la estructura visual de la pantalla
    return Scaffold(
      body: Container(
        // Gradiente de fondo moderno con colores morados
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF7B2CBF), // Morado principal
              Color(0xFF9D4EDD), // Morado secundario
              Color(0xFFC77DFF), // Morado accent
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea( // Asegura que el contenido no se meta debajo de cosas como la barra de estado
          child: Center( // Centra el contenido en la pantalla
            child: SingleChildScrollView( // Permite hacer scroll si el contenido es más grande que la pantalla
              padding: const EdgeInsets.all(24), // Agrega espacio alrededor del contenido
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420), // Limita el ancho del contenido
                child: Card(
                  // Tarjeta con sombra y bordes redondeados para el formulario
                  elevation: 12,
                  shadowColor: Colors.black.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: LoginFields(), // Muestra los campos de texto y botones definidos en otro archivo
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
