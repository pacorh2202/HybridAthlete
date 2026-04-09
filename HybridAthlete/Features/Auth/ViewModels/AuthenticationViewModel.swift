import SwiftUI

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let supabaseService = SupabaseService.shared

    // MARK: - Authentication Methods

    func signUp(email: String, password: String, passwordConfirm: String) async {
        isLoading = true
        errorMessage = nil

        do {
            // Validaciones
            guard !email.isEmpty, email.contains("@") else {
                throw AuthError.invalidEmail
            }

            guard password.count >= 8 else {
                throw AuthError.passwordTooShort
            }

            guard password == passwordConfirm else {
                throw AuthError.passwordsDoNotMatch
            }

            // Registrar usuario
            let user = try await supabaseService.signUp(email: email, password: password)
            self.currentUser = user
            self.isAuthenticated = true

            isLoading = false
        } catch let error as AuthError {
            errorMessage = error.localizedDescription
            isLoading = false
        } catch {
            errorMessage = "Error desconocido: \(error.localizedDescription)"
            isLoading = false
        }
    }

    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil

        do {
            guard !email.isEmpty else {
                throw AuthError.invalidEmail
            }

            guard !password.isEmpty else {
                throw AuthError.invalidCredentials
            }

            let user = try await supabaseService.signIn(email: email, password: password)
            self.currentUser = user
            self.isAuthenticated = true

            isLoading = false
        } catch let error as AuthError {
            errorMessage = error.localizedDescription
            isLoading = false
        } catch {
            errorMessage = "Error desconocido: \(error.localizedDescription)"
            isLoading = false
        }
    }

    func signOut() async {
        isLoading = true
        errorMessage = nil

        do {
            try await supabaseService.signOut()
            self.currentUser = nil
            self.isAuthenticated = false
            isLoading = false
        } catch let error as AuthError {
            errorMessage = error.localizedDescription
            isLoading = false
        } catch {
            errorMessage = "Error al cerrar sesión"
            isLoading = false
        }
    }

    func clearError() {
        errorMessage = nil
    }
}
