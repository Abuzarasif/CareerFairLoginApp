import SwiftUI

// MARK: - Exhibitor Models

enum ExhibitorPurpose: String, CaseIterable, Identifiable {
    case recruitment = "Recruitment"
    case branding = "Branding"
    
    var id: String { rawValue }
    
    var stampType: StampType {
        switch self {
        case .recruitment: return .blue
        case .branding: return .green
        }
    }
    
    var tagColor: Color {
        switch self {
        case .recruitment: return .blue
        case .branding: return .green
        }
    }
}

struct Exhibitor: Identifiable, Hashable {
    let id: String
    let name: String
    let industrySector: String
    let dateAttendance: String
    let purpose: ExhibitorPurpose
    let buhubURL: URL
    let boothNumber: Int?
    
    // Simple initials for leading avatar
    var initials: String {
        let parts = name.split(separator: " ")
        let letters = parts.prefix(2).compactMap { $0.first }
        return String(letters)
    }
}

// MARK: - Exhibitor Directory

struct ExhibitorDirectoryView: View {
    
    @EnvironmentObject private var appState: AppState
    
    // Full set of exhibitors loaded from the official Excel file via
    // `scripts/export_exhibitors.py` into `Models/ExhibitorData.swift`.
    private let exhibitors: [Exhibitor] = allExhibitors
    
    @State private var searchText: String = ""
    @State private var selectedDate: String = "All"
    @State private var selectedIndustry: String = "All"
    @State private var selectedPurposeFilter: ExhibitorPurpose? = nil
    
    private var allDates: [String] {
        let unique = Set(exhibitors.map { $0.dateAttendance })
        return ["All"] + unique.sorted()
    }
    
    private var allIndustries: [String] {
        let unique = Set(exhibitors.map { $0.industrySector })
        return ["All"] + unique.sorted()
    }
    
    private var filteredExhibitors: [Exhibitor] {
        exhibitors.filter { exhibitor in
            let matchesSearch = searchText.isEmpty ||
                exhibitor.name.localizedCaseInsensitiveContains(searchText) ||
                exhibitor.industrySector.localizedCaseInsensitiveContains(searchText)
            
            let matchesDate = selectedDate == "All" || exhibitor.dateAttendance == selectedDate
            let matchesIndustry = selectedIndustry == "All" || exhibitor.industrySector == selectedIndustry
            let matchesPurpose: Bool = {
                guard let purpose = selectedPurposeFilter else { return true }
                return exhibitor.purpose == purpose
            }()
            
            return matchesSearch && matchesDate && matchesIndustry && matchesPurpose
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search exhibitors", text: $searchText)
                        .textFieldStyle(.plain)
                }
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Filters row
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        Menu {
                            Picker("Date Attendance", selection: $selectedDate) {
                                ForEach(allDates, id: \.self) { date in
                                    Text(date).tag(date)
                                }
                            }
                        } label: {
                            filterChip(title: selectedDate == "All" ? "Date Attendance" : selectedDate)
                        }
                        
                        Menu {
                            Picker("Industry Sector", selection: $selectedIndustry) {
                                ForEach(allIndustries, id: \.self) { sector in
                                    Text(sector).tag(sector)
                                }
                            }
                        } label: {
                            filterChip(title: selectedIndustry == "All" ? "Industry Sector" : selectedIndustry)
                        }
                        
                        Menu {
                            Button("All") { selectedPurposeFilter = nil }
                            Divider()
                            ForEach(ExhibitorPurpose.allCases) { purpose in
                                Button(purpose.rawValue) { selectedPurposeFilter = purpose }
                            }
                        } label: {
                            filterChip(title: selectedPurposeFilter?.rawValue ?? "Purpose")
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 4)
                }
                
                // Directory list
                List {
                    Section(header: Text("Exhibitor Directory")) {
                        ForEach(filteredExhibitors) { exhibitor in
                            NavigationLink(destination: ExhibitorDetailView(exhibitor: exhibitor)) {
                                ExhibitorRowView(exhibitor: exhibitor)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Exhibitor Directory")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    StampHeaderView(compact: true)
                        .environmentObject(appState)
                }
            }
        }
    }
    
    private func filterChip(title: String) -> some View {
        Text(title)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
    }
}

// MARK: - Row View

private struct ExhibitorRowView: View {
    
    let exhibitor: Exhibitor
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(.secondarySystemBackground))
                    .frame(width: 40, height: 40)
                Text(exhibitor.initials)
                    .font(.caption)
                    .fontWeight(.bold)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(exhibitor.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text("Link to company page on BUHub")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Exhibitor Detail & QR Scan

struct ExhibitorDetailView: View {
    
    let exhibitor: Exhibitor
    
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
                Text(exhibitor.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(exhibitor.industrySector)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    Text(exhibitor.dateAttendance)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    
                    Text(exhibitor.purpose.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(exhibitor.purpose.tagColor.opacity(0.15))
                        .foregroundColor(exhibitor.purpose.tagColor)
                        .cornerRadius(8)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Company information")
                    .font(.headline)
                
                Text("Job postings and detailed company information from the fair documents would be summarised here. For this prototype, we show a placeholder description.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                Link(destination: exhibitor.buhubURL) {
                    Text("Open company page on BUHub")
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
                
                Text("Tap the button below to open the QR scanner and collect your stamp for visiting this exhibitor. Recruitment booths award **blue** stamps, branding booths award **green** stamps. Each exhibitor only awards one stamp.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                Button(action: handleScanButtonTapped) {
                    HStack {
                        Image(systemName: "qrcode.viewfinder")
                        Text("Scan QR code to collect stamp")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(exhibitor.purpose == .recruitment ? Color.blue : Color.green)
                    .cornerRadius(12)
                }
            }
            
            Spacer()
        }
        .padding(20)
        .navigationTitle("Exhibitor Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showScannerSheet) {
            QRScannerMockView()
        }
        .alert(isPresented: $showStampStatusAlert) {
            if didCollectNewStamp {
                return Alert(
                    title: Text("Stamp Collected"),
                    message: Text("You’ve collected a \(exhibitor.purpose == .recruitment ? "blue" : "green") stamp for this exhibitor."),
                    dismissButton: .default(Text("OK"))
                )
            } else {
                return Alert(
                    title: Text("Already Collected"),
                    message: Text("You’ve already collected a stamp for this exhibitor. Each exhibitor only awards one stamp."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func handleScanButtonTapped() {
        let didAdd = appState.collectExhibitorStamp(for: exhibitor.id, type: exhibitor.purpose.stampType)
        didCollectNewStamp = didAdd
        showStampStatusAlert = true
        showScannerSheet = true
    }
}


