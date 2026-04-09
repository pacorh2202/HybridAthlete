import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var showSettings = false

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.lightGray, Color.white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("¡Hola, \(authViewModel.currentUser?.name ?? authViewModel.currentUser?.email ?? "Atleta")!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryDark)
                        Text(Date(), style: .date)
                            .font(.caption)
                            .foregroundColor(.darkGray)
                    }

                    Spacer()

                    Button(action: { showSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                            .foregroundColor(.primaryDark)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)

                // Main Cards
                ScrollView {
                    VStack(spacing: 16) {
                        // Progress Ring
                        VStack(spacing: 12) {
                            Text("Tu Progreso Hoy")
                                .font(.headline)
                                .foregroundColor(.primaryDark)

                            HStack(spacing: 20) {
                                // Workouts
                                ProgressCard(
                                    title: "Entrenamientos",
                                    value: "0/1",
                                    icon: "dumbbell.fill",
                                    color: .accentRed
                                )

                                // Nutrition
                                ProgressCard(
                                    title: "Macros",
                                    value: "0%",
                                    icon: "fork.knife",
                                    color: .successGreen
                                )

                                // Steps
                                ProgressCard(
                                    title: "Pasos",
                                    value: "0",
                                    icon: "figure.walk",
                                    color: .lightBlue
                                )
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)

                        // Today's Workout
                        VStack(spacing: 12) {
                            HStack {
                                Text("Entrenamiento de Hoy")
                                    .font(.headline)
                                    .foregroundColor(.primaryDark)
                                Spacer()
                                Text("Fase 1")
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.accentRed)
                                    .foregroundColor(.white)
                                    .cornerRadius(6)
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text("No tienes rutina asignada aún")
                                    .font(.body)
                                    .foregroundColor(.darkGray)

                                Button(action: {}) {
                                    Text("Crear rutina de entrenamiento")
                                        .font(.footnote)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.accentRed)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)

                        // Nutrition Plan
                        VStack(spacing: 12) {
                            HStack {
                                Text("Plan de Nutrición")
                                    .font(.headline)
                                    .foregroundColor(.primaryDark)
                                Spacer()
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text("No tienes plan de nutrición aún")
                                    .font(.body)
                                    .foregroundColor(.darkGray)

                                Button(action: {}) {
                                    Text("Generar plan personalizado")
                                        .font(.footnote)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.accentRed)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)

                        // Body Analysis
                        VStack(spacing: 12) {
                            HStack {
                                Text("Análisis Corporal")
                                    .font(.headline)
                                    .foregroundColor(.primaryDark)
                                Spacer()
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Sube tus fotos corporales para analizar tu composición")
                                    .font(.body)
                                    .foregroundColor(.darkGray)

                                Button(action: {}) {
                                    Text("Subir fotos corporales")
                                        .font(.footnote)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.accentRed)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                    .padding()
                }

                Spacer()

                // Sign Out Button
                Button(action: {
                    Task {
                        await authViewModel.signOut()
                    }
                }) {
                    Text("Cerrar Sesión")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.errorRed)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
            .padding()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(authViewModel)
        }
    }
}

struct ProgressCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)

            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primaryDark)

            Text(title)
                .font(.caption)
                .foregroundColor(.darkGray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(8)
    }
}

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Perfil")) {
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(authViewModel.currentUser?.email ?? "")
                            .foregroundColor(.gray)
                    }
                }

                Section {
                    Button(role: .destructive, action: {
                        Task {
                            await authViewModel.signOut()
                            dismiss()
                        }
                    }) {
                        Text("Cerrar Sesión")
                    }
                }
            }
            .navigationTitle("Configuración")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Listo") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(AuthenticationViewModel())
}
