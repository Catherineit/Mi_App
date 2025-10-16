import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/auth_repository.dart';

class AuthController {
  // Aquí iría la lógica de autenticación
  AuthController(this._repository); // Recibe una instancia de AuthRepository
  
  final AuthRepository _repository;

  Future<String?> login(String email, String password) async {
    try {
      await _repository.signIn(email, password);
      return null; // Retorna null si el inicio de sesión fue exitoso
    } on FirebaseAuthException catch (e) {
      return _mapErrorCode(e.code); // Usa la función _mapErrorCode
    }
  }

  String _mapErrorCode(String code){
    switch(code){
        case "invalid-credential":
            return "Las credenciales proporcionadas no son válidas.";
        case "user-disabled":
            return "Usuario no habilitado.";
        default:
            return "No se puede iniciar sesión.($code)";
    }
  }
}