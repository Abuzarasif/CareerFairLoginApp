import SwiftUI

// MARK: - Fair Day Helper

enum FloorPlanDay: String, CaseIterable, Identifiable {
    case day1
    case day2
    case day3
    
    var id: String { rawValue }
    
    var label: String {
        switch self {
        case .day1: return "18 Feb (Day 1)"
        case .day2: return "19 Feb (Day 2)"
        case .day3: return "20 Feb (Day 3)"
        }
    }
    
    /// File name (without extension) of the floor plan PDF for this day.
    var pdfName: String {
        switch self {
        case .day1: return "18 FloorPlan Fin R2"
        case .day2: return "19 FloorPlan Fin R2"
        case .day3: return "20 FloorPlan Fin R3"
        }
    }
}

// MARK: - Interactive Floor Plan

struct InteractiveFloorPlanView: View {
    
    @State private var selectedDay: FloorPlanDay = .day1
    
    /// Exhibitors loaded from the Excel file via `ExhibitorData.swift`.
    private var exhibitors: [Exhibitor] { allExhibitors }
    
    private var exhibitorsForSelectedDay: [Exhibitor] {
        exhibitors.filter { $0.dateAttendance == selectedDay.label }
            .sorted { $0.name < $1.name }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    HStack {
                        Spacer()
                        StampHeaderView(compact: true)
                    }
                    
                    infoCard
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    Picker("Day", selection: $selectedDay) {
                        ForEach(FloorPlanDay.allCases) { day in
                            Text(day.label).tag(day)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    PDFViewer(
                        title: "Floor Plan – \(selectedDay.label)",
                        documentName: selectedDay.pdfName
                    )
                    .frame(height: 360)
                    .padding(.horizontal)
                    
                    exhibitorsSection
                        .padding(.horizontal)
                        .padding(.bottom, 16)
                }
            }
            .navigationTitle("Interactive Floor Plan")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Subviews
    
    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Zones & Booth Types")
                .font(.headline)
            
            Text("• **Li Promenade** – Recruitment booths (approx. 30 booths in total across the fair days).")
                .font(.subheadline)
            
            Text("• **AAB 3/F Podium** – Branding / awareness booths (approx. 20 booths in total).")
                .font(.subheadline)
            
            Text("Tap a company name in the list below to open a (dummy) BUHub company page link.")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private var exhibitorsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Companies on this day")
                .font(.headline)
            
            if exhibitorsForSelectedDay.isEmpty {
                Text("No exhibitors found for \(selectedDay.label).")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                ForEach(exhibitorsForSelectedDay) { exhibitor in
                    Link(destination: exhibitor.buhubURL) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(exhibitor.name)
                                    .font(.subheadline)
                                Text(exhibitor.industrySector)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                    Divider()
                }
            }
        }
    }
}


