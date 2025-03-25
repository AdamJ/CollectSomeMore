#  Code Snippets

```swiftui
    TabView {
        TabSection("Video") {
            Tab("Movies", systemImage: "popcorn") {
                MovieList(movie: MovieData.shared.movie)
            }
            
            Tab("TV Shows", systemImage: "tv") {
                Text("List of tv shows")
            }
        }
        
        TabSection("Audio") {
            Tab("Podcasts", systemImage: "mic") {
                Text("Favorite podcasts")
            }
            
            Tab("Music", systemImage: "music.note.list") {
                Text("Favorite music things")
            }
        }
        Tab("Search", systemImage: "magnifyingglass") {
            SearchView()
        }
        .tabViewStyle(.sidebarAdaptable)
    }
```
``` 
                    Button("Add a movie", action: addCollection)
                        .foregroundStyle(.gray01)
                        .buttonStyle(.borderedProminent)
```
