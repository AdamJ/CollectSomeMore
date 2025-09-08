//
//  MovieExport.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 2/1/25.
//

import SwiftUI

// Sample data structure
struct Record: Identifiable {
    let id = UUID()
    let movieTitle: String
    let rating: String
    let genre: String
    let releaseDate: Date
    let purchaseDate: Date
    let location: String
    let enteredDate: Date
    
    func toCSV() -> String {
        return "\(movieTitle),\(rating),\(genre),\(releaseDate),\(purchaseDate),\(location),\(enteredDate),\n"
    }
}

struct ExportView: View {
    @State private var showingExportSheet = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    // Sample data
    let records: [Record] = [
        Record(movieTitle: "Movie", rating: "Unrated", genre: "Other", releaseDate: .now, purchaseDate: .now, location: "Other", enteredDate: .now)
    ]
    
    var body: some View {
        Button(action: exportToCSV) {
            HStack {
                Image(systemName: "square.and.arrow.up")
                Text("Export to CSV")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .sheet(isPresented: $showingExportSheet) {
            ShareSheet(activityItems: [createCSVFile() ?? ""])
        }
        .alert("Export Error", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func exportToCSV() {
        if createCSVFile() != nil {
            showingExportSheet = true
        }
    }
    
    private func createCSVFile() -> URL? {
        let headers = "Title,Rating,Genre,Release Date,Purchase Date,Location\n"
        let rows = records.map { $0.toCSV() }.joined(separator: "\n")
        let csvContent = headers + rows
        
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            alertMessage = "Could not access documents directory"
            showingAlert = true
            return nil
        }
        
        let fileName = "export_\(Date().timeIntervalSince1970).csv"
        let fileURL = documentsPath.appendingPathComponent(fileName)
        
        do {
            try csvContent.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            alertMessage = "Error exporting file: \(error.localizedDescription)"
            showingAlert = true
            return nil
        }
    }
}

// UIKit wrapper for sharing functionality
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
