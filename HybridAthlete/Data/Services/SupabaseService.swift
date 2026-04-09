import Foundation

/// Servicio centralizado para todas las operaciones de Supabase
/// Este servicio manejará:
/// - Configuración de Supabase
/// - Requests HTTP a las APIs de Supabase
/// - Almacenamiento de tokens
class SupabaseService {
    static let shared = SupabaseService()

    // MARK: - Configuration
    private let supabaseURL = "https://fiybgplahndbuahwyrjm.supabase.co"
    private let supabaseAnonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZpeWJncGxhaG5kYnVhaHd5cmptIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU3MjY4MzgsImV4cCI6MjA5MTMwMjgzOH0.HfUmZ1dvb-wy-YnXH-CqkCIYsISeJYWRoboGKpNceqM"

    private var accessToken: String?
    private var refreshToken: String?

    // MARK: - Init
    private init() {}

    // MARK: - Authentication Methods

    /// Registra un nuevo usuario con email y contraseña
    func signUp(email: String, password: String) async throws -> User {
        let body: [String: String] = [
            "email": email,
            "password": password,
        ]

        let result = try await post(
            endpoint: "/auth/v1/signup",
            body: body,
            authenticated: false
        )

        guard let userData = result["user"] as? [String: Any],
              let id = userData["id"] as? String else {
            throw AuthError.unknownError("Error al procesar respuesta del servidor")
        }

        if let session = result["session"] as? [String: Any],
           let token = session["access_token"] as? String {
            self.accessToken = token
            if let refreshToken = session["refresh_token"] as? String {
                self.refreshToken = refreshToken
            }
        }

        return User(id: id, email: email)
    }

    /// Inicia sesión con email y contraseña
    func signIn(email: String, password: String) async throws -> User {
        let body: [String: String] = [
            "email": email,
            "password": password,
        ]

        let result = try await post(
            endpoint: "/auth/v1/token?grant_type=password",
            body: body,
            authenticated: false
        )

        guard let accessToken = result["access_token"] as? String else {
            throw AuthError.invalidCredentials
        }

        self.accessToken = accessToken
        if let refreshToken = result["refresh_token"] as? String {
            self.refreshToken = refreshToken
        }

        // Obtener datos del usuario actual
        let user = try await getCurrentUser()
        return user
    }

    /// Obtiene el usuario actual autenticado
    func getCurrentUser() async throws -> User {
        let result = try await get(endpoint: "/auth/v1/user", authenticated: true)

        guard let id = result["id"] as? String,
              let email = result["email"] as? String else {
            throw AuthError.unknownError("Error al obtener usuario")
        }

        return User(id: id, email: email)
    }

    /// Cierra sesión
    func signOut() async throws {
        try await post(endpoint: "/auth/v1/logout", body: [:], authenticated: true)
        accessToken = nil
        refreshToken = nil
    }

    // MARK: - HTTP Methods

    private func get(endpoint: String, authenticated: Bool = true) async throws -> [String: Any] {
        guard let url = URL(string: supabaseURL + endpoint) else {
            throw AuthError.networkError
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if authenticated {
            guard let token = accessToken else {
                throw AuthError.invalidCredentials
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        request.setValue(supabaseAnonKey, forHTTPHeaderField: "apikey")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.networkError
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw AuthError.unknownError("HTTP \(httpResponse.statusCode)")
        }

        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw AuthError.unknownError("Error al parsear respuesta")
        }

        return json
    }

    private func post(endpoint: String, body: [String: Any], authenticated: Bool = true) async throws
        -> [String: Any] {
        guard let url = URL(string: supabaseURL + endpoint) else {
            throw AuthError.networkError
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if authenticated {
            guard let token = accessToken else {
                throw AuthError.invalidCredentials
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        request.setValue(supabaseAnonKey, forHTTPHeaderField: "apikey")

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.networkError
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw AuthError.unknownError("HTTP \(httpResponse.statusCode)")
        }

        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw AuthError.unknownError("Error al parsear respuesta")
        }

        return json
    }
}
