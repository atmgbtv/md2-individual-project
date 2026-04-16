import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FlutterSecureStorage _secureStorage;

  AuthRepositoryImpl(this._firebaseAuth, this._secureStorage);

  @override
  Stream<String?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) => user?.uid);
  }

  @override
  Future<void> signIn(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final token = await userCredential.user?.getIdToken();
    if (token != null) {
      await _secureStorage.write(key: 'auth_token', value: token);
    }
  }

  @override
  Future<void> signUp(String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final token = await userCredential.user?.getIdToken();
    if (token != null) {
      await _secureStorage.write(key: 'auth_token', value: token);
    }
  }

  @override
  Future<void> signOut() async {
    await _secureStorage.delete(key: 'auth_token');
    await _firebaseAuth.signOut();
  }

  @override
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }
}
