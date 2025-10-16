import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
    // Aquí irían los métodos para manejar la autenticación
    AuthRepository({FirebaseAuth? auth}): _auth = auth ?? FirebaseAuth.instance;
    
    final FirebaseAuth _auth;

    Future<UserCredential> signIn(String email, String password) {
        return _auth.signInWithEmailAndPassword(email: email, password: password);
    }
}