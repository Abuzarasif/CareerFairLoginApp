import SwiftUI

struct RedeemFlowView: View {
    
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    @State private var q1Answer: String = ""
    @State private var q2Answer: String = ""
    
    @State private var showScanner: Bool = false
    @State private var rewardMessage: String = ""
    @State private var showRewardAlert: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                
                Text("Redeem your reward")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your stamp summary")
                        .font(.headline)
                    Text("Total stamps: **\(appState.totalStampCount)**")
                    Text("Blue (Recruitment): **\(appState.blueStampCount)**   Green (Branding): **\(appState.greenStampCount)**   Orange (Skill‑Up): **\(appState.orangeStampCount)**")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if !appState.hasCompletedEvaluation {
                    evaluationSection
                } else {
                    Text("You have already completed the evaluation. You can claim your reward directly.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Button(action: handleClaimTapped) {
                    Text(appState.hasCompletedEvaluation ? "Claim Reward" : "Submit Evaluation & Claim")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.top, 8)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Redeem")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .sheet(isPresented: $showScanner) {
                // Reuse the same QR scanner mock used for activities/exhibitors.
                QRScannerMockView()
                    .onAppear {
                        // Automatically close after a short delay to simulate scanning.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            showScanner = false
                        }
                    }
            }
            .alert(isPresented: $showRewardAlert) {
                Alert(
                    title: Text("Reward"),
                    message: Text(rewardMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    // MARK: - Evaluation
    
    private var evaluationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick evaluation (one‑time)")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("1. How useful do you find the Career Fair app so far?")
                Picker("", selection: $q1Answer) {
                    Text("Very useful").tag("Very useful")
                    Text("Somewhat useful").tag("Somewhat useful")
                    Text("Not useful").tag("Not useful")
                }
                .pickerStyle(.segmented)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("2. How confident do you feel about your career planning after using the app?")
                Picker("", selection: $q2Answer) {
                    Text("More confident").tag("More confident")
                    Text("About the same").tag("About the same")
                    Text("Less confident").tag("Less confident")
                }
                .pickerStyle(.segmented)
            }
            
            Text("Your answers are for demonstration only in this prototype and are not stored.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Logic
    
    private func handleClaimTapped() {
        // Redeem button should never be shown if total stamps < 10, but guard just in case.
        guard appState.totalStampCount >= 10 else {
            return
        }
        
        if !appState.hasCompletedEvaluation {
            // In this prototype we don't validate answers strictly; simply mark as completed.
            appState.hasCompletedEvaluation = true
        }
        
        rewardMessage = computeRewardMessage()
        showRewardAlert = true
        showScanner = true
    }
    
    /// Computes the reward tier and corresponding message based on stamp counts.
    private func computeRewardMessage() -> String {
        let total = appState.totalStampCount
        let blue = appState.blueStampCount
        let green = appState.greenStampCount
        let orange = appState.orangeStampCount
        
        // Tier 3 requires at least one of each stamp type.
        let hasEachType = blue > 0 && green > 0 && orange > 0
        
        if total >= 25 && hasEachType {
            return "Congrats u received a sports bag and have been nominated for Grand Prize Lucky Draw."
        } else if total >= 20 {
            return "Congrats u got a Flask."
        } else {
            return "Congrats u got a complimentary drink. Enjoy it."
        }
    }
}


