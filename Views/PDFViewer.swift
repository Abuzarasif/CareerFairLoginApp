import SwiftUI
import PDFKit

// MARK: - UIKit-backed PDF view

struct PDFKitView: UIViewRepresentable {
    
    let documentName: String
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        configureDocument(for: pdfView)
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        // Nothing to update dynamically for now.
    }
    
    private func configureDocument(for pdfView: PDFView) {
        guard let url = Bundle.main.url(forResource: documentName, withExtension: "pdf"),
              let document = PDFDocument(url: url) else {
            return
        }
        pdfView.document = document
    }
}

// MARK: - SwiftUI wrapper with graceful fallback

struct PDFViewer: View {
    
    let title: String?
    let documentName: String
    
    private var hasDocument: Bool {
        Bundle.main.url(forResource: documentName, withExtension: "pdf") != nil
    }
    
    var body: some View {
        VStack(spacing: 12) {
            if let title {
                Text(title)
                    .font(.headline)
            }
            
            if hasDocument {
                PDFKitView(documentName: documentName)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.separator), lineWidth: 0.5)
                    )
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "doc.richtext")
                        .font(.system(size: 32))
                        .foregroundColor(.secondary)
                    Text("PDF \"\(documentName).pdf\" is not bundled with the app.")
                        .multilineTextAlignment(.center)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("Add the file to the Xcode target resources to see it here.")
                        .multilineTextAlignment(.center)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            }
        }
    }
}


