//
//  ComicsData.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 7/2/24.
//

import SwiftUI
import SwiftData

@Model
class ComicCollection: Identifiable {
    @Attribute var id = UUID()
    var comicTitle: String?
    var series: String?
    var issueNumber: String?
    var publisher: String?
    var writer: String?
    var artist: String?
    var genre: String?
    var rating: String?
    var releaseDate: Date?
    var purchaseDate: Date?
    var location: String?
    var condition: String?
    var notes: String = ""
    var enteredDate: Date?
    var isRead: Bool = false

    init(id: UUID = UUID(), comicTitle: String? = nil, series: String? = nil, issueNumber: String? = nil, publisher: String? = nil, writer: String? = nil, artist: String? = nil, genre: String? = nil, rating: String? = nil, releaseDate: Date? = nil, purchaseDate: Date? = nil, location: String? = nil, condition: String? = nil, notes: String? = nil, enteredDate: Date? = nil, isRead: Bool = false) {
        self.id = id
        self.comicTitle = comicTitle
        self.series = series
        self.issueNumber = issueNumber
        self.publisher = publisher
        self.writer = writer
        self.artist = artist
        self.genre = genre
        self.rating = rating
        self.releaseDate = releaseDate
        self.purchaseDate = purchaseDate
        self.location = location
        self.condition = condition
        self.notes = notes ?? ""
        self.enteredDate = enteredDate ?? Date()
        self.isRead = isRead
    }

    @MainActor static var sampleComicCollectionData: [ComicCollection] {
        [
            ComicCollection(
                comicTitle: "The Amazing Spider-Man",
                series: "The Amazing Spider-Man",
                issueNumber: "#1",
                publisher: "Marvel Comics",
                writer: "Stan Lee",
                artist: "Steve Ditko",
                genre: "Superhero",
                rating: "T",
                releaseDate: Calendar.current.date(byAdding: .year, value: -60, to: Date()),
                purchaseDate: Calendar.current.date(byAdding: .month, value: -1, to: Date()),
                location: "Physical",
                condition: "Very Fine",
                notes: "Classic first appearance issue.",
                isRead: true
            ),
            ComicCollection(
                comicTitle: "Batman: The Killing Joke",
                series: "Batman",
                issueNumber: "One-Shot",
                publisher: "DC Comics",
                writer: "Alan Moore",
                artist: "Brian Bolland",
                genre: "Superhero",
                rating: "M",
                releaseDate: Calendar.current.date(byAdding: .year, value: -35, to: Date()),
                purchaseDate: Calendar.current.date(byAdding: .month, value: -2, to: Date()),
                location: "Digital",
                condition: "N/A",
                notes: "Critically acclaimed graphic novel.",
                isRead: false
            ),
            ComicCollection(
                comicTitle: "Saga",
                series: "Saga",
                issueNumber: "#1",
                publisher: "Image Comics",
                writer: "Brian K. Vaughan",
                artist: "Fiona Staples",
                genre: "Science Fiction",
                rating: "M",
                releaseDate: Calendar.current.date(byAdding: .year, value: -12, to: Date()),
                purchaseDate: .now,
                location: "Physical",
                condition: "Near Mint",
                notes: "Excellent space opera series.",
                isRead: true
            )
        ]
    }
}

// Comic View for displaying individual comics
struct ComicView: View {
    var comic: ComicCollection

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let title = comic.comicTitle {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            if let genre = comic.genre {
                Label("Genre: \(genre)", systemImage: "book")
                    .labelStyle(.titleAndIcon)
                    .font(.subheadline)
            }

            if let publisher = comic.publisher {
                Text("Publisher: \(publisher)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            if !comic.notes.isEmpty {
                Text(comic.notes)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}

// Comics Form View for adding new comics
struct ComicFormView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @State private var comicTitle: String = ""
    @State private var series: String = ""
    @State private var issueNumber: String = ""
    @State private var publisher: String = ""
    @State private var genre: String = ""
    @State private var notes: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Comic Details")) {
                    TextField("Title", text: $comicTitle)
                    TextField("Series", text: $series)
                    TextField("Issue Number", text: $issueNumber)
                    TextField("Publisher", text: $publisher)
                    TextField("Genre", text: $genre)
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Button(action: {
                    let newComic = ComicCollection(
                        comicTitle: comicTitle.isEmpty ? nil : comicTitle,
                        series: series.isEmpty ? nil : series,
                        issueNumber: issueNumber.isEmpty ? nil : issueNumber,
                        publisher: publisher.isEmpty ? nil : publisher,
                        genre: genre.isEmpty ? nil : genre,
                        notes: notes
                    )
                    modelContext.insert(newComic)
                    dismiss()
                }) {
                    Text("Add Comic")
                }
                .disabled(comicTitle.isEmpty)
            }
            .navigationTitle("Add New Comic")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// Main Comics List View
struct ComicsList: View {
    @Environment(\.modelContext) var modelContext
    @Query private var comics: [ComicCollection]
    @State private var showingForm = false

    var body: some View {
        NavigationView {
            List(comics) { comic in
                NavigationLink {
                    ComicView(comic: comic)
                } label: {
                    VStack(alignment: .leading) {
                        Text(comic.comicTitle ?? "Untitled")
                            .font(.headline)
                        if let series = comic.series, let issue = comic.issueNumber {
                            Text("\(series) \(issue)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Comics")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingForm.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $showingForm) {
                        ComicFormView()
                    }
                }
            }
        }
    }
}

// Preview
struct ComicsList_Previews: PreviewProvider {
    static var previews: some View {
        ComicsList()
            .modelContainer(for: ComicCollection.self, inMemory: true)
    }
}
