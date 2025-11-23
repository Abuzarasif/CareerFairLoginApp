import Foundation

// MARK: - App Navigation

enum AppScreen {
    case login
    case onboarding
    case home
}

// MARK: - User Profile Model

struct UserProfile {
    // Field 1: Faculty / School
    // If SSO provides faculty data, this can be pre-filled and `requiresFaculty` set to false.
    var requiresFaculty: Bool = true
    var faculty: String = ""
    
    // Field 2: Purpose of Visit
    var purposeOfVisit: PurposeOfVisit?
    
    // Field 3: Employment Preference (conditional)
    var employmentPreference: EmploymentPreference?
    
    // Field 4: Career Interest (multi-select)
    var careerInterests: Set<String> = []
    
    // Field 5: Consent checkbox
    var consentGiven: Bool = false
}

enum PurposeOfVisit: String, CaseIterable, Identifiable {
    case activelySeekingJobs = "Actively seeking jobs."
    case casuallyBrowsing = "Casually browsing opportunities."
    case exploringIndustries = "Exploring industries and career paths."
    case networking = "Networking with employers."
    case noIdeaYet = "No idea yet"
    
    var id: String { rawValue }
    
    var requiresEmploymentPreference: Bool {
        switch self {
        case .activelySeekingJobs, .casuallyBrowsing:
            return true
        default:
            return false
        }
    }
}

enum EmploymentPreference: String, CaseIterable, Identifiable {
    case graduateRoles = "Graduate roles / Full-time jobs"
    case internships = "Internships"
    case partTime = "Part-time opportunities"
    case projectsFreelance = "Projects / freelance opportunities"
    case noIdeaYet = "No idea yet"
    
    var id: String { rawValue }
}

// MARK: - Career Interest Options

struct CareerInterestOptions {
    // In a production app, this array should be populated from:
    // - Column C (“Zone”) in `HKBU Career Fair Exhibitor List.xlsx`, and/or
    // - BUhub – Company Industry excel list.
    // The zones should be deduplicated into a unique array.
    //
    // For this implementation, we mock a few sample zones and keep the logic
    // to demonstrate how the UI and filtering would work.
    static let baseZones: [String] = [
        "Banking & Finance",
        "Technology & IT",
        "Media & Communication",
        "Consulting & Professional Services",
        "Public Sector & NGOs",
        "Retail & Consumer",
        "Logistics & Transportation"
    ]
    
    static let noIdeaOption = "No idea yet"
    static let selectAllOption = "Select all"
    
    static var allOptions: [String] {
        [selectAllOption] + baseZones + [noIdeaOption]
    }
}

// MARK: - App State

final class AppState: ObservableObject {
    @Published var currentScreen: AppScreen = .login
    @Published var profile: UserProfile = UserProfile()
}


