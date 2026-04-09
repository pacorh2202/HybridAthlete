import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var showSignUp = false

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.primaryDark,
                    Color.primaryBlue,
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                // Logo / Title
                VStack(spacing: 8) {
                    Text("HYBRID")
                        .font(.system(size: 48, weight: .bold, design: .default))
                        .foregroundColor(.white)
                    Text("ATHLETE")
                        .font(.system(size: 48, weight: .bold, design: .default))
                        .foregroundColor(.accentRed)
                    Divider()
                        .frame(height: 2)
                        .background(Color.accentRed)
                }
                .padding(.bottom, 30)

                // Tagline
                Text("Transforma tu físico con IA y ciencia")
                    .font(.subheadline)
                    .foregroundColor(.lightGray)
                    .multilineTextAlignment(.center)

                Spacer()

                // Auth Form
                if showSignUp {
                    SignUpFormView(showSignUp: $showSignUp)
                        .environmentObject(authViewModel)
                } else {
                    SignInFormView(showSignUp: $showSignUp)
                        .environmentObject(authViewModel)
                }

                Spacer()
            }
            .padding()
        }
    }
}

struct SignInFormView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Binding var showSignUp: Bool
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("Inicia Sesión")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            // Email Input
            TextField("", text: $email, prompt: Text("Correo electrónico").foregroundColor(.midGray))
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.lightGray)
                .cornerRadius(8)

            // Password Input
            SecureField("", text: $password, prompt: Text("Contraseña").foregroundColor(.midGray))
                .textContentType(.password)
                .padding()
                .background(Color.lightGray)
                .cornerRadius(8)

            // Error Message
            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.errorRed)
                    .padding(.horizontal)
            }

            // Sign In Button
            Button(action: {
                Task {
                    await authViewModel.signIn(email: email, password: password)
                }
            }) {
                if authViewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Inicia Sesión")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accentRed)
            .foregroundColor(.white)
            .cornerRadius(8)
            .disabled(authViewModel.isLoading || email.isEmpty || password.isEmpty)

            // Sign Up Link
            VStack(spacing: 8) {
                Text("¿No tienes cuenta?")
                    .font(.footnote)
                    .foregroundColor(.lightGray)

                Button(action: { showSignUp = true }) {
                    Text("Crear cuenta")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.accentRed)
                }
            }
        }
        .padding()
        .background(Color.primaryDark.opacity(0.8))
        .cornerRadius(12)
        .padding()
    }
}

struct SignUpFormView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Binding var showSignUp: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var passwordConfirm = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("Crear Cuenta")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            // Email Input
            TextField("", text: $email, prompt: Text("Correo electrónico").foregroundColor(.midGray))
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.lightGray)
                .cornerRadius(8)

            // Password Input
            SecureField("", text: $password, prompt: Text("Contraseña (8+ caracteres)").foregroundColor(.midGray))
                .textContentType(.newPassword)
                .padding()
                .background(Color.lightGray)
                .cornerRadius(8)

            // Password Confirm
            SecureField("", text: $passwordConfirm, prompt: Text("Confirma contraseña").foregroundColor(.midGray))
                .textContentType(.newPassword)
                .padding()
                .background(Color.lightGray)
                .cornerRadius(8)

            // Error Message
            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.errorRed)
                    .padding(.horizontal)
            }

            // Sign Up Button
            Button(action: {
                Task {
                    await authViewModel.signUp(email: email, password: password, passwordConfirm: passwordConfirm)
                }
            }) {
                if authViewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Crear Cuenta")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accentRed)
            .foregroundColor(.white)
            .cornerRadius(8)
            .disabled(authViewModel.isLoading || email.isEmpty || password.isEmpty || passwordConfirm.isEmpty)

            // Sign In Link
            VStack(spacing: 8) {
                Text("¿Ya tienes cuenta?")
                    .font(.footnote)
                    .foregroundColor(.lightGray)

                Button(action: { showSignUp = false }) {
                    Text("Inicia sesión aquí")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.accentRed)
                }
            }
        }
        .padding()
        .background(Color.primaryDark.opacity(0.8))
        .cornerRadius(12)
        .padding()
    }
}

#Preview {
    AuthView()
        .environmentObject(AuthenticationViewModel())
}
