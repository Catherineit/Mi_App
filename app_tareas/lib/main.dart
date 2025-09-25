import 'package:app_tareas/login_screen.dart'; // Importa un archivo donde está definida la pantalla de inicio de sesión
import 'package:flutter/material.dart'; // Importa las herramientas necesarias de Flutter para construir la interfaz

void main() {
  runApp(const MainApp()); // Función principal: ejecuta la aplicación usando el widget MainApp
}

class MainApp extends StatelessWidget { // Define una clase MainApp que no puede cambiar (es inmutable)
  const MainApp({super.key}); // Constructor de la clase, que permite usar claves únicas para el widget

  @override
  Widget build(BuildContext context) {
    // Define cómo se ve el widget
    return MaterialApp(
      title: "Login y tarea", // Título de la aplicación
      theme: _buildTheme(), // Aplicar tema personalizado
      home: const LoginScreen(), // La primera pantalla que se muestra es LoginScreen
    );
  }

  // Tema personalizado con colores morados modernos
  ThemeData _buildTheme() {
    const purplePrimary = Color(0xFF7B2CBF); // Morado principal
    const purpleSecondary = Color(0xFF9D4EDD); // Morado secundario
    const purpleLight = Color(0xFFE0AAFF); // Morado claro
    const purpleAccent = Color(0xFFC77DFF); // Morado accent

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: purplePrimary,
        primary: purplePrimary,
        secondary: purpleSecondary,
        tertiary: purpleAccent,
        surface: Colors.white,
        background: const Color(0xFFF8F7FF), // Fondo ligeramente morado
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: const Color(0xFF2D1B69),
      ),
      
      // AppBar personalizado
      appBarTheme: const AppBarTheme(
        backgroundColor: purplePrimary,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Color(0x40000000),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      // Cards con sombras y bordes redondeados
      cardTheme: CardThemeData(
        elevation: 6,
        shadowColor: purplePrimary.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
      ),

      // Botones elevados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: purplePrimary,
          foregroundColor: Colors.white,
          elevation: 6,
          shadowColor: purplePrimary.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // FloatingActionButton
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: purpleSecondary,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Campos de entrada
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: purpleLight, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: purpleLight, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: purplePrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        prefixIconColor: purpleSecondary,
        suffixIconColor: purpleSecondary,
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: purpleLight.withOpacity(0.3),
        selectedColor: purplePrimary,
        disabledColor: Colors.grey.shade300,
        labelStyle: const TextStyle(color: Color(0xFF2D1B69)),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
