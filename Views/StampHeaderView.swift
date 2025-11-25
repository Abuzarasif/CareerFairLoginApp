import SwiftUI

/// Combined stamp progress bar and redeem button, to be shown on the top of
/// all main pages.
struct StampHeaderView: View {
    
    @EnvironmentObject private var appState: AppState
    @State private var showRedeemSheet: Bool = false
    
    /// When `true`, uses smaller fonts suitable for navigation bar toolbars.
    let compact: Bool
    
    private var canRedeem: Bool {
        appState.totalStampCount >= 10
    }
    
    var body: some View {
        HStack(spacing: compact ? 6 : 10) {
            StampProgressBarView()
                .environmentObject(appState)
            
            Button(action: {
                guard canRedeem else { return }
                showRedeemSheet = true
            }) {
                Text("Redeem")
                    .font(compact ? .caption : .callout)
                    .fontWeight(.semibold)
            }
            .buttonStyle(.borderedProminent)
            .tint(.black)
            .disabled(!canRedeem)
        }
        .sheet(isPresented: $showRedeemSheet) {
            RedeemFlowView()
                .environmentObject(appState)
        }
    }
}


