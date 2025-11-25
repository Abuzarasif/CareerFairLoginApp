import Foundation

// MARK: - App Navigation

enum AppScreen {
    case login
    case onboarding
    case home
}

// MARK: - Stamp Types

enum StampType {
    case blue      // Exhibitor-related stamps (to be used on Exhibitor Directory page)
    case green     // Exhibitor-related stamps (to be used on Exhibitor Directory page)
    case orange    // Activity-related stamps (Activity Schedule)
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
    @Published var hasCompletedEvaluation: Bool = false
    
    // Set of unique IDs representing activities for which the user has
    // already collected an orange stamp.
    @Published private(set) var orangeActivityStampIDs: Set<String> = []
    
    // Placeholder sets for future exhibitor-based stamps.
    @Published private(set) var blueExhibitorStampIDs: Set<String> = []
    @Published private(set) var greenExhibitorStampIDs: Set<String> = []
    
    // Computed counts used by the progress bar UI.
    var orangeStampCount: Int { orangeActivityStampIDs.count }
    var blueStampCount: Int { blueExhibitorStampIDs.count }
    var greenStampCount: Int { greenExhibitorStampIDs.count }
    var totalStampCount: Int { orangeStampCount + blueStampCount + greenStampCount }
    
    // MARK: - Stamp Collection Helpers
    
    /// Adds an orange stamp for the given activity if it hasn't been collected yet.
    /// - Returns: `true` if a new stamp was added, `false` if it was already collected.
    @discardableResult
    func collectOrangeStamp(for activityID: String) -> Bool {
        let beforeCount = orangeActivityStampIDs.count
        orangeActivityStampIDs.insert(activityID)
        return orangeActivityStampIDs.count > beforeCount
    }
    
    /// Adds a blue or green stamp for a given exhibitor. Enforces uniqueness per exhibitor ID.
    /// - Returns: `true` if a new stamp was added, `false` if it was already collected.
    @discardableResult
    func collectExhibitorStamp(for exhibitorID: String, type: StampType) -> Bool {
        switch type {
        case .blue:
            let before = blueExhibitorStampIDs.count
            blueExhibitorStampIDs.insert(exhibitorID)
            return blueExhibitorStampIDs.count > before
        case .green:
            let before = greenExhibitorStampIDs.count
            greenExhibitorStampIDs.insert(exhibitorID)
            return greenExhibitorStampIDs.count > before
        case .orange:
            // Orange stamps are activity-based; use `collectOrangeStamp` instead.
            return false
        }
    }
}


