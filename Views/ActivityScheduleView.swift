import SwiftUI

// MARK: - Activity Model

struct Activity: Identifiable, Hashable {
    let id: String
    let timeSlot: String
    let title: String
    let room: String
    let registrationCode: String
    
    // In a real app this would be a unique SLES URL per activity.
    // For this prototype we point all activities to the SLES portal.
    var slesURL: URL {
        URL(string: "https://sles.hkbu.edu.hk/")!
    }
    
    var registrationDisplayText: String {
        "Registration \(registrationCode)"
    }
}

// MARK: - Activity Schedule (List)

struct ActivityScheduleView: View {
    
    @EnvironmentObject private var appState: AppState
    
    private let activities: [Activity] = [
        Activity(id: "act-1", timeSlot: "9:00 AM", title: "CV Clinic: One‑on‑One Review", room: "Room A101", registrationCode: "2001"),
        Activity(id: "act-2", timeSlot: "10:30 AM", title: "Interview Skills Masterclass", room: "Room A202", registrationCode: "2002"),
        Activity(id: "act-3", timeSlot: "12:00 PM", title: "Networking Lunch with Alumni", room: "Career Café", registrationCode: "2003"),
        Activity(id: "act-4", timeSlot: "2:00 PM", title: "Tech Industry Spotlight Panel", room: "Auditorium 1", registrationCode: "2004"),
        Activity(id: "act-5", timeSlot: "3:30 PM", title: "Banking & Finance Insider Talk", room: "Auditorium 2", registrationCode: "2005"),
        Activity(id: "act-6", timeSlot: "4:30 PM", title: "Start‑ups & Entrepreneurship Forum", room: "Innovation Lab", registrationCode: "2006"),
        Activity(id: "act-7", timeSlot: "5:30 PM", title: "Closing Keynote: Designing Your Career", room: "Main Hall", registrationCode: "2007")
    ]
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Full Schedule")) {
                    ForEach(activities) { activity in
                        NavigationLink(destination: ActivityDetailView(activity: activity)) {
                            ActivityRowView(activity: activity)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Activity Schedule")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    StampHeaderView(compact: true)
                        .environmentObject(appState)
                }
            }
        }
    }
}

// MARK: - Row View

private struct ActivityRowView: View {
    
    let activity: Activity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(activity.timeSlot)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Text(activity.room)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(activity.title)
                .font(.body)
            
            // SLES registration link
            Link(destination: activity.slesURL) {
                Text("SLES Registration \(activity.registrationCode)")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .underline()
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Activity Detail & QR Scan

struct ActivityDetailView: View {
    
    let activity: Activity
    
    @EnvironmentObject private var appState: AppState
    @State private var showScannerSheet: Bool = false
    @State private var showStampStatusAlert: Bool = false
    @State private var didCollectNewStamp: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            // Progress bar at the top-right
            HStack {
                Spacer()
                StampHeaderView(compact: true)
                    .environmentObject(appState)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(activity.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                HStack {
                    Image(systemName: "clock")
                    Text(activity.timeSlot)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                    Text(activity.room)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Registration")
                    .font(.headline)
                
                Text("Each activity has a corresponding SLES registration page.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Link(destination: activity.slesURL) {
                    Text("Open SLES registration page")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .underline()
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Collect your stamp")
                    .font(.headline)
                
                Text("Tap the button below to open the QR scanner. On the real device this would scan a QR code at the activity booth. For this prototype, opening the scanner is enough to award your orange stamp once per activity.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                Button(action: handleScanButtonTapped) {
                    HStack {
                        Image(systemName: "qrcode.viewfinder")
                        Text("Scan the QR code to collect stamps")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(12)
                }
            }
            
            Spacer()
        }
        .padding(20)
        .navigationTitle("Activity Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showScannerSheet) {
            QRScannerMockView()
        }
        .alert(isPresented: $showStampStatusAlert) {
            if didCollectNewStamp {
                return Alert(
                    title: Text("Stamp Collected"),
                    message: Text("You’ve collected an orange stamp for this activity."),
                    dismissButton: .default(Text("OK"))
                )
            } else {
                return Alert(
                    title: Text("Already Collected"),
                    message: Text("You’ve already collected a stamp for this activity. Each activity only awards one orange stamp."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func handleScanButtonTapped() {
        let didAdd = appState.collectOrangeStamp(for: activity.id)
        didCollectNewStamp = didAdd
        showStampStatusAlert = true
        showScannerSheet = true
    }
}

// MARK: - Mock QR Scanner UI (shared between Activities & Exhibitors)

struct QRScannerMockView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.opacity(0.9)
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Text("QR Scanner (Prototype)")
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.green, lineWidth: 3)
                            .frame(width: 260, height: 260)
                        
                        Image(systemName: "qrcode.viewfinder")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.green)
                    }
                    
                    Text("Point your camera at the activity QR code.\nIn this simulator, scanning is simulated.")
                        .multilineTextAlignment(.center)
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Button(action: { dismiss() }) {
                        Text("Close")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 40)
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Stamp Progress Bar

struct StampProgressBarView: View {
    
    @EnvironmentObject private var appState: AppState
    
    private var blueCount: Int { appState.blueStampCount }
    private var greenCount: Int { appState.greenStampCount }
    private var orangeCount: Int { appState.orangeStampCount }
    
    private var maxCount: CGFloat {
        CGFloat(max(1, max(blueCount, max(greenCount, orangeCount))))
    }
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text("Stamps")
                .font(.caption)
                .fontWeight(.semibold)
            
            HStack(alignment: .bottom, spacing: 3) {
                bar(color: .blue, count: blueCount)
                bar(color: .green, count: greenCount)
                bar(color: .orange, count: orangeCount)
            }
        }
    }
    
    private func bar(color: Color, count: Int) -> some View {
        let height = CGFloat(count == 0 ? 2 : (8 + Int(10 * CGFloat(count) / maxCount)))
        
        return VStack(spacing: 2) {
            Rectangle()
                .fill(color.opacity(count == 0 ? 0.2 : 0.9))
                .frame(width: 10, height: height)
                .cornerRadius(3)
            
            Text("\(count)")
                .font(.caption2)
        }
    }
}


