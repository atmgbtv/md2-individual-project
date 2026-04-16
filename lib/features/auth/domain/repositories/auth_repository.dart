abstract class AuthRepository {
  Stream<String?> get authStateChanges; // Returns user ID or null
  Future<void> signIn(String email, String password);
  Future<void> signUp(String email, String password);
  Future<void> signOut();
  Future<String?> getToken();
}
