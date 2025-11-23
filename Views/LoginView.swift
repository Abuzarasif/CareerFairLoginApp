import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject private var appState: AppState
    
    // MARK: - Hard-coded credentials
    private let validEmail = "21200130@life.hkbu.edu.hk"
    private let validPassword = "Shadman12345"
    
    // MARK: - UI State (pre-filled with hard-coded values)
    @State private var email: String = "21200130@life.hkbu.edu.hk"
    @State private var password: String = "Shadman12345"
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 32) {
                    
                    // Top mail icon container
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.secondarySystemBackground))
                            .frame(width: 90, height: 90)
                        
                        Image(systemName: "envelope.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 30)
                            .foregroundColor(.black)
                    }
                    .padding(.top, 40)
                    
                    // Email & Password fields
                    VStack(spacing: 16) {
                        
                        // Email field
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Email")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(12)
                        }
                        
                        // Password field
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Password")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            SecureField("Password", text: $password)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    // Small "Forgot Password?" label under fields
                    HStack {
                        Spacer()
                        Text("Forgot Password?")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                    
                    // Bottom main button (validates credentials)
                    Button(action: validateCredentials) {
                        Text("Forgot Password?")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Back button (left)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Handle back action if needed
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                }
                
                // Menu button (right)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Handle menu action if needed
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.black)
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    // MARK: - Logic
    
    private func validateCredentials() {
        if email == validEmail && password == validPassword {
            // On successful login, navigate to onboarding if the profile
            // has not been completed yet, otherwise go straight to home.
            appState.currentScreen = .onboarding
        } else {
            alertTitle = "Error"
            alertMessage = "Invalid email or password."
            showAlert = true
        }
    }
}

// MARK: - Preview

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


