//
//  ComicDetailView.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 9/8/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI
import SwiftData

struct ComicDetailView: View {
    @Bindable var comicCollection: ComicCollection
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let isNew: Bool
    
    init(comicCollection: ComicCollection, isNew: Bool = false) {
        self.comicCollection = comicCollection
        self.isNew = isNew
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Comic Information") {
                    TextField("Comic Title", text: Binding(
                        get: { comicCollection.comicTitle ?? "" },
                        set: { comicCollection.comicTitle = $0.isEmpty ? nil : $0 }
                    ))
                    
                    TextField("Series", text: Binding(
                        get: { comicCollection.series ?? "" },
                        set: { comicCollection.series = $0.isEmpty ? nil : $0 }
                    ))
                    
                    TextField("Issue Number", text: Binding(
                        get: { comicCollection.issueNumber ?? "" },
                        set: { comicCollection.issueNumber = $0.isEmpty ? nil : $0 }
                    ))
                    
                    Picker("Publisher", selection: Binding(
                        get: { comicCollection.publisher ?? "Other" },
                        set: { comicCollection.publisher = $0 }
                    )) {
                        ForEach(ComicPublishers.publishers, id: \.self) { publisher in
                            Text(publisher).tag(publisher)
                        }
                    }
                    
                    TextField("Writer", text: Binding(
                        get: { comicCollection.writer ?? "" },
                        set: { comicCollection.writer = $0.isEmpty ? nil : $0 }
                    ))
                    
                    TextField("Artist", text: Binding(
                        get: { comicCollection.artist ?? "" },
                        set: { comicCollection.artist = $0.isEmpty ? nil : $0 }
                    ))
                }
                
                Section("Details") {
                    Picker("Genre", selection: Binding(
                        get: { comicCollection.genre ?? "Other" },
                        set: { comicCollection.genre = $0 }
                    )) {
                        ForEach(ComicGenres.genres, id: \.self) { genre in
                            Text(genre).tag(genre)
                        }
                    }
                    
                    Picker("Rating", selection: Binding(
                        get: { comicCollection.rating ?? "Unrated" },
                        set: { comicCollection.rating = $0 }
                    )) {
                        ForEach(ComicRating.rating, id: \.self) { rating in
                            Text(rating).tag(rating)
                        }
                    }
                    
                    Picker("Location", selection: Binding(
                        get: { comicCollection.location ?? "Physical" },
                        set: { comicCollection.location = $0 }
                    )) {
                        ForEach(ComicLocation.location, id: \.self) { location in
                            Text(location).tag(location)
                        }
                    }
                    
                    if comicCollection.location == "Physical" {
                        Picker("Condition", selection: Binding(
                            get: { comicCollection.condition ?? "N/A" },
                            set: { comicCollection.condition = $0 }
                        )) {
                            ForEach(ComicCondition.condition, id: \.self) { condition in
                                Text(condition).tag(condition)
                            }
                        }
                    }
                }
                
                Section("Dates") {
                    DatePicker("Release Date", selection: Binding(
                        get: { comicCollection.releaseDate ?? Date() },
                        set: { comicCollection.releaseDate = $0 }
                    ), displayedComponents: .date)
                    
                    DatePicker("Purchase Date", selection: Binding(
                        get: { comicCollection.purchaseDate ?? Date() },
                        set: { comicCollection.purchaseDate = $0 }
                    ), displayedComponents: .date)
                }
                
                Section("Notes") {
                    TextField("Notes", text: $comicCollection.notes, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Status") {
                    Toggle("Read", isOn: $comicCollection.isRead)
                }
            }
            .navigationTitle(isNew ? "Add Comic" : comicCollection.comicTitle ?? "Comic Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        if isNew {
                            modelContext.delete(comicCollection)
                        }
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if isNew {
                            comicCollection.enteredDate = Date()
                            modelContext.insert(comicCollection)
                        }
                        do {
                            try modelContext.save()
                            dismiss()
                        } catch {
                            print("Error saving comic: \(error)")
                        }
                    }
                    .disabled(comicCollection.comicTitle?.isEmpty != false)
                }
            }
        }
    }
}