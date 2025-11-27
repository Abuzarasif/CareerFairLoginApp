import SwiftUI

struct OnboardingView: View {
    
    @EnvironmentObject private var appState: AppState
    
    // MARK: - Validation State
    @State private var showFacultyError = false
    @State private var showPurposeError = false
    @State private var showEmploymentPreferenceError = false
    @State private var showCareerInterestError = false
    @State private var showConsentError = false
    
    @State private var showNoIdeaAlert = false
    
    // MARK: - Faculty Options (Field 1)
    private let facultyOptions: [String] = [
        "Faculty of Arts and Social Sciences",
        "School of Business",
        "School of Chinese Medicine",
        "School of Communication",
        "School of Creative Arts",
        "Faculty of Science",
        "Transdisciplinary / Individualised Pathway Programmes",
        "School of Continuing Education"
    ]
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Onboarding Prompt
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Complete Your Profile")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome to the Career Fair 2026 app!")
                            Text("Personalize your experience by answering a few questions.")
                            Text("Your choices will determine the features and reward levels you can access.")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    .padding(.top, 16)
                    
                    // Field 1: Faculty / School (conditional)
                    if appState.profile.requiresFaculty {
                        facultyField
                    }
                    
                    // Field 2: Purpose of Visit (single selection)
                    purposeOfVisitField
                    
                    // Field 3: Employment Preference (conditional)
                    if shouldShowEmploymentPreference {
                        employmentPreferenceField
                    }
                    
                    // Field 4: Career Interest (multi-select)
                    careerInterestField
                    
                    // Field 5: Consent checkbox
                    consentField
                    
                    // Submit button
                    Button(action: validateAndSubmit) {
                        Text("Complete Profile and Submit")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(12)
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .navigationTitle("Profile & Onboarding")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showNoIdeaAlert) {
                Alert(
                    title: Text("Notice"),
                    message: Text("If you don’t indicate your career interest, the personalized itinerary feature will be disabled and your e-stamp reward will be limited to Level 1. You can update your choices later to unlock all features."),
                    dismissButton: .default(Text("ok"))
                )
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var shouldShowEmploymentPreference: Bool {
        if let purpose = appState.profile.purposeOfVisit {
            return purpose.requiresEmploymentPreference
        }
        return false
    }
    
    // MARK: - Field Builders
    
    private var facultyField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Please select your Faculty / School")
                .font(.subheadline)
            
            Menu {
                ForEach(facultyOptions, id: \.self) { option in
                    Button(option) {
                        appState.profile.faculty = option
                        showFacultyError = false
                    }
                }
            } label: {
                HStack {
                    Text(appState.profile.faculty.isEmpty ? "Select your faculty / school" : appState.profile.faculty)
                        .foregroundColor(appState.profile.faculty.isEmpty ? .secondary : .primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            }
            
            if showFacultyError && appState.profile.faculty.isEmpty {
                Text("This field is required")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
    
    private var purposeOfVisitField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("What is your primary purpose for visiting the Career Fair 2026?")
                .font(.subheadline)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(PurposeOfVisit.allCases) { purpose in
                    selectionRow(
                        title: purpose.rawValue,
                        isSelected: appState.profile.purposeOfVisit == purpose
                    ) {
                        appState.profile.purposeOfVisit = purpose
                        showPurposeError = false
                        
                        // If employment preference is not required for this choice,
                        // clear any existing selection.
                        if !purpose.requiresEmploymentPreference {
                            appState.profile.employmentPreference = nil
                        }
                    }
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            
            if showPurposeError && appState.profile.purposeOfVisit == nil {
                Text("This field is required")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
    
    private var employmentPreferenceField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("What type of employment are you looking for?")
                .font(.subheadline)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(EmploymentPreference.allCases) { preference in
                    selectionRow(
                        title: preference.rawValue,
                        isSelected: appState.profile.employmentPreference == preference
                    ) {
                        appState.profile.employmentPreference = preference
                        showEmploymentPreferenceError = false
                    }
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            
            if showEmploymentPreferenceError && appState.profile.employmentPreference == nil {
                Text("This field is required")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
    
    private var careerInterestField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Which industries are you interested in?")
                .font(.subheadline)
            
            Text("Use Column C (\"Zone\") from the HKBU Career Fair Exhibitor List as the basis for this list. Values are deduplicated into a unique array and displayed here.")
                .font(.caption)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(CareerInterestOptions.allOptions, id: \.self) { option in
                    multiSelectRow(
                        title: option,
                        isSelected: isCareerInterestSelected(option)
                    ) {
                        handleCareerInterestTap(option)
                    }
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            
            if showCareerInterestError && appState.profile.careerInterests.isEmpty {
                Text("This field is required")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
    
    private var consentField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Privacy & Data Sharing")
                .font(.subheadline)
            
            Button(action: {
                appState.profile.consentGiven.toggle()
                showConsentError = false
            }) {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: appState.profile.consentGiven ? "checkmark.square.fill" : "square")
                        .foregroundColor(appState.profile.consentGiven ? .black : .secondary)
                    Text("I hereby understand and agree that the personal information and preferences I have submitted through this form will be collected and transferred to BUhub, the University's internal career portal. This data will be used to update my student profile for the purpose of matching me with relevant employers and career opportunities.")
                        .font(.footnote)
                        .foregroundColor(.primary)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            }
            
            if showConsentError && !appState.profile.consentGiven {
                Text("This field is required")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
    
    // MARK: - Helpers
    
    private func selectionRow(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(isSelected ? .black : .secondary)
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
            }
        }
    }
    
    private func multiSelectRow(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .foregroundColor(isSelected ? .black : .secondary)
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
            }
        }
    }
    
    private func isCareerInterestSelected(_ option: String) -> Bool {
        if option == CareerInterestOptions.selectAllOption {
            // "Select all" is considered selected if all base zones are selected.
            return Set(CareerInterestOptions.baseZones)
                .isSubset(of: appState.profile.careerInterests)
        }
        return appState.profile.careerInterests.contains(option)
    }
    
    private func handleCareerInterestTap(_ option: String) {
        var interests = appState.profile.careerInterests
        
        switch option {
        case CareerInterestOptions.selectAllOption:
            // Select all base zones, clear "No idea yet"
            interests = Set(CareerInterestOptions.baseZones)
            interests.remove(CareerInterestOptions.noIdeaOption)
            
        case CareerInterestOptions.noIdeaOption:
            // Show warning, then set only "No idea yet"
            showNoIdeaAlert = true
            interests = [CareerInterestOptions.noIdeaOption]
            
        default:
            if interests.contains(option) {
                interests.remove(option)
            } else {
                interests.insert(option)
            }
            // When a real option is selected, remove "No idea yet"
            interests.remove(CareerInterestOptions.noIdeaOption)
        }
        
        appState.profile.careerInterests = interests
        showCareerInterestError = false
    }
    
    private func validateAndSubmit() {
        // Reset all error flags
        showFacultyError = false
        showPurposeError = false
        showEmploymentPreferenceError = false
        showCareerInterestError = false
        showConsentError = false
        
        var hasError = false
        
        // Field 1: Faculty (if visible)
        if appState.profile.requiresFaculty && appState.profile.faculty.isEmpty {
            showFacultyError = true
            hasError = true
        }
        
        // Field 2: Purpose of visit
        if appState.profile.purposeOfVisit == nil {
            showPurposeError = true
            hasError = true
        }
        
        // Field 3: Employment preference (conditional)
        if shouldShowEmploymentPreference && appState.profile.employmentPreference == nil {
            showEmploymentPreferenceError = true
            hasError = true
        }
        
        // Field 4: Career interest (at least one option)
        if appState.profile.careerInterests.isEmpty {
            showCareerInterestError = true
            hasError = true
        }
        
        // Field 5: Consent
        if !appState.profile.consentGiven {
            showConsentError = true
            hasError = true
        }
        
        guard !hasError else {
            return
        }
        
        // Successful submission
        appState.currentScreen = .home
    }
}


