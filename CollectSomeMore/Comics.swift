//
//  ComicsData.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 7/2/24.
//

import SwiftUI

// Step 1: Define a comics Model
struct Comic: Identifiable {
    let id = UUID()
    let title: String
    let genre: String
    let description: String
}

// Step 2: Extend the ComicsViewModel
class ComicViewModel: ObservableObject {
    @Published var comic: [Comic] = [
        Comic(title: "Inception", genre: "Science Fiction", description: "A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a CEO."),
        Comic(title: "The Shawshank Redemption", genre: "Drama", description: "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency."),
        Comic(title: "The Dark Knight", genre: "Action", description: "When the menace known as the Joker emerges from his mysterious past, he wreaks havoc and chaos on the people of Gotham."),
    ]
    
    // Method to add a new comic
    func addComic(title: String, genre: String, description: String) {
        let newComic = Comic(title: title, genre: genre, description: description)
        comic.append(newComic)
    }
}

// Step 3: Build the ComicView
struct ComicView: View {
    var comic: Comic

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
//            Text(comic.title)
//                .font(.headline)
//                .foregroundColor(.primary)
            Label("Genre: \(comic.genre)", systemImage: "popcorn")
                .labelStyle(.titleAndIcon)
                .font(.subheadline)
//            Text("Genre: \(comic.genre)")
//                .font(.subheadline)
//                .foregroundColor(.secondary)

            Text(comic.description)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}

// Step 4: Create the ComicsFormView
struct ComicFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ComicViewModel
    @State private var title: String = ""
    @State private var genre: String = ""
    @State private var description: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Comic Details")) {
                    TextField("Title", text: $title)
                    TextField("Genre", text: $genre)
                    TextField("Description", text: $description)
                }
                
                Button(action: {
                    viewModel.addComic(title: title, genre: genre, description: description)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add comics")
                }
                .disabled(title.isEmpty || genre.isEmpty || description.isEmpty)
            }
            .navigationTitle("Add New comics")
        }
    }
}

// Step 5: Update the Main View
struct ComicListView: View {
    @StateObject private var viewModel = ComicViewModel()
    @State private var showingForm = false

    var body: some View {
        NavigationView {
            List(viewModel.comic) { comic in
                NavigationLink {
                    ComicView(comic: comic)
                } label: {
                    Text(comic.title)
                }
                ComicView(comic: comic)
                    .padding(.vertical, 5)
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
                        ComicFormView(viewModel: viewModel)
                    }
                }
            }
        }
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ComicListView()
    }
}
