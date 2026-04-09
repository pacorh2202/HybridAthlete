import Foundation

enum AuthError: LocalizedError {
    case invalidEmail
    case passwordTooShort
    case passwordsDoNotMatch
    case userAlreadyExists
    case invalidCredentials
    case networkError
    case unknownError(String)

    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "El correo electrónico no es válido"
        case .passwordTooShort:
            return "La contraseña debe tener al menos 8 caracteres"
        case .passwordsDoNotMatch:
            return "Las contraseñas no coinciden"
        case .userAlreadyExists:
            return "El usuario ya existe"
        case .invalidCredentials:
            return "Correo o contraseña incorrectos"
        case .networkError:
            return "Error de conexión. Intenta nuevamente"
        case .unknownError(let message):
            return message
        }
    }
}
