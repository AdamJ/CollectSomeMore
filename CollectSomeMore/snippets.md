//
//  Comics.swift
//  CollectSomeMore
//
//  Created by Adam Jolicoeur on 7/2/24.
//

import SwiftUI
import SwiftData

// MARK: - Comic Data Model
@Model
class ComicCollection {
    var id: UUID = UUID()
    var title: String = ""
    var series: String = ""
    var issueNumber: String = ""
    var publisher: String = ""
    var writer: String = ""
    var artist: String = ""
    var genre: String = ""
    var publicationDate: Date = Date()
    var description: String = ""
    var coverImage: Data?
    var condition: String = "Near Mint"
    var location: String = ""
    var purchasePrice: Double = 0.0
    var currentValue: Double = 0.0
    var notes: String = ""
    
    init(title: String = "", series: String = "", issueNumber: String = "", publisher: String = "", writer: String = "", artist: String = "", genre: String = "", publicationDate: Date = Date(), description: String = "", condition: String = "Near Mint", location: String = "", purchasePrice: Double = 0.0, currentValue: Double = 0.0, notes: String = "") {
        self.title = title
        self.series = series
        self.issueNumber = issueNumber
        self.publisher = publisher
        self.writer = writer
        self.artist = artist
        self.genre = genre
        self.publicationDate = publicationDate
        self.description = description
        self.condition = condition
        self.location = location
        self.purchasePrice = purchasePrice
        self.currentValue = currentValue
        self.notes = notes
    }
}

// MARK: - Comic View Components
struct ComicView: View {
    var comic: ComicCollection

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(comic.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                if !comic.issueNumber.isEmpty {
                    Text("#\(comic.issueNumber)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            if !comic.series.isEmpty {
                Text("Series: \(comic.series)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                if !comic.publisher.isEmpty {
                    Label(comic.publisher, systemImage: "building.2")
                        .labelStyle(.titleAndIcon)
                        .font(.subheadline)
                }
                Spacer()
                if !comic.genre.isEmpty {
                    Text(comic.genre)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.accentColor.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            
            if !comic.writer.isEmpty || !comic.artist.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    if !comic.writer.isEmpty {
                        Text("Writer: \(comic.writer)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    if !comic.artist.isEmpty {
                        Text("Artist: \(comic.artist)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }

            if !comic.description.isEmpty {
                Text(comic.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Comics List View
struct ComicsList: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var comics: [ComicCollection]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(comics) { comic in
                    NavigationLink(destination: ComicDetailView(comic: comic)) {
                        ComicView(comic: comic)
                    }
                }
                .onDelete(perform: deleteComics)
            }
            .navigationTitle("Comics")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Comic") {
                        addComic()
                    }
                }
            }
        }
    }
    
    private func addComic() {
        let newComic = ComicCollection()
        modelContext.insert(newComic)
    }
    
    private func deleteComics(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(comics[index])
            }
        }
    }
}

// MARK: - Comic Detail View
struct ComicDetailView: View {
    @Bindable var comic: ComicCollection
    
    var body: some View {
        Form {
            Section("Basic Information") {
                TextField("Title", text: $comic.title)
                TextField("Series", text: $comic.series)
                TextField("Issue Number", text: $comic.issueNumber)
                TextField("Publisher", text: $comic.publisher)
            }
            
            Section("Creators") {
                TextField("Writer", text: $comic.writer)
                TextField("Artist", text: $comic.artist)
            }
            
            Section("Details") {
                TextField("Genre", text: $comic.genre)
                DatePicker("Publication Date", selection: $comic.publicationDate, displayedComponents: .date)
                TextField("Condition", text: $comic.condition)
                TextField("Location", text: $comic.location)
            }
            
            Section("Financial") {
                TextField("Purchase Price", value: $comic.purchasePrice, format: .currency(code: "USD"))
                TextField("Current Value", value: $comic.currentValue, format: .currency(code: "USD"))
            }
            
            Section("Description") {
                TextField("Description", text: $comic.description, axis: .vertical)
                    .lineLimit(3...6)
            }
            
            Section("Notes") {
                TextField("Notes", text: $comic.notes, axis: .vertical)
                    .lineLimit(2...4)
            }
        }
        .navigationTitle("Comic Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ComicCollection.self, configurations: config)
    
    let sampleComic = ComicCollection(
        title: "The Amazing Spider-Man",
        series: "Amazing Spider-Man",
        issueNumber: "1",
        publisher: "Marvel Comics",
        writer: "Stan Lee",
        artist: "Steve Ditko",
        genre: "Superhero",
        description: "The origin story of Spider-Man, where Peter Parker gains his spider powers.",
        condition: "Very Fine",
        location: "Comic Box #1",
        purchasePrice: 25.00,
        currentValue: 150.00
    )
    
    return ComicDetailView(comic: sampleComic)
        .modelContainer(container)
}
