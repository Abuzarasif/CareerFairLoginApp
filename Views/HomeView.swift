import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var appState: AppState
    @State private var showWelcomeAlert: Bool = true
    
    private var hasNoCareerInterest: Bool {
        appState.profile.careerInterests.contains(CareerInterestOptions.noIdeaOption)
            || appState.profile.careerInterests.isEmpty
    }
    
    private var selectedCareerInterestsDescription: String {
        let realSelections = appState.profile.careerInterests
            .subtracting([CareerInterestOptions.noIdeaOption])
        
        if realSelections.isEmpty {
            return "No specific interests selected."
        } else {
            return realSelections.sorted().joined(separator: ", ")
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Career Fair 2026")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Reward level logic (simplified)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Reward Level")
                        .font(.headline)
                    Text(hasNoCareerInterest ? "Level 1 (limited, based on no selected career interest)." :
                            "Level 2+ (enhanced, based on your selected career interests).")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                // Personalized Itinerary Logic
                VStack(alignment: .leading, spacing: 8) {
                    Text("Personalized Itinerary")
                        .font(.headline)
                    
                    if hasNoCareerInterest {
                        Text("Choose your career interest(s) to unlock your personalized itinerary!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else {
                        Text("Your personalized itinerary is enabled for the following interests:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(selectedCareerInterestsDescription)
                            .font(.subheadline)
                    }
                }
                
                // In a full implementation, the exhibitor directory would be filtered
                // using Column C (“Zone”) from `HKBU Career Fair Exhibitor List.xlsx`
                // matched with the user's selected career interests (Field 4).
                VStack(alignment: .leading, spacing: 4) {
                    Text("Exhibitor Directory (Concept)")
                        .font(.headline)
                    Text("If you select one or more career interests, the exhibitor list will be filtered to zones that match your selections. If you select \"No idea yet\" or choose to show all, all exhibitors will be displayed.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    appState.currentScreen = .onboarding
                }) {
                    Text("Edit Profile")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(12)
                }
            }
            .padding(20)
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showWelcomeAlert) {
                Alert(
                    title: Text("Profile complete. Welcome onboard!"),
                    message: Text("You can edit your profile at any time from the home screen."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}


