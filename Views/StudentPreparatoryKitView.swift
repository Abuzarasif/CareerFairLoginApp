import SwiftUI

struct StudentPreparatoryKitView: View {
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Spacer()
                    StampHeaderView(compact: true)
                }
                
                Text("Student Preparatory Kit")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text("This page shows the student preparatory kit directly inside the app so students can read it without leaving the experience. The current PDF is a placeholder – replace it with the official kit PDF in the Xcode project resources when available.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                PDFViewer(
                    title: nil,
                    // Use a dummy PDF; this can be replaced with the real kit later.
                    documentName: "StudentPreparatoryKit"
                )
                .frame(maxHeight: .infinity)
            }
            .padding()
            .navigationTitle("Prep Kit")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


