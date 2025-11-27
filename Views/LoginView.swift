import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject private var appState: AppState
    
    // MARK: - Hard-coded credentials
    private let validEmail = "21200130@life.hkbu.edu.hk"
    private let validPassword = "Shadman12345"
    
    // MARK: - UI State (pre-filled with hard-coded values)
    @State private var email: String = "21200130@life.hkbu.edu.hk"
    @State private var password: String = "Shadman12345"
    @State private var showPassword: Bool = false
    
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        
                        Spacer().frame(height: 40)
                        
                        // Top mail icon container
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color(.secondarySystemBackground))
                                .frame(width: 96, height: 96)
                            
                            Image(systemName: "envelope.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 30)
                                .foregroundColor(.black)
                        }
                        
                        // Email & Password fields
                        VStack(spacing: 20) {
                            
                            // Email field
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Email")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                TextField("your.email@life.hkbu.edu.hk", text: $email)
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(12)
                            }
                            
                            // Password field with eye toggle
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Password")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    if showPassword {
                                        TextField("Password", text: $password)
                                    } else {
                                        SecureField("Password", text: $password)
                                    }
                                    
                                    Button(action: { showPassword.toggle() }) {
                                        Image(systemName: showPassword ? "eye.slash" : "eye")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(12)
                            }
                        }
                        
                        // Small "Forgot Password?" button under fields
                        HStack {
                            Spacer()
                            Button(action: {
                                alertTitle = "Forgot Password"
                                alertMessage = "Password reset is not implemented in this demo app."
                                showAlert = true
                            }) {
                                Text("Forgot Password?")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer(minLength: 24)
                        
                        // Primary Log In button
                        Button(action: validateCredentials) {
                            Text("Log In")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .cornerRadius(12)
                        }
                        .padding(.top, 8)
                        
                        Spacer().frame(height: 40)
                    }
                    .padding(.horizontal, 32)
                }
            }
            .navigationBarHidden(true)
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


