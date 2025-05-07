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

``` navigation idea
enum TabbedItems: Int, CaseIterable{
    case home = 0
    case games
    case movies
    case search

    var title: String{
        switch self {
        case .home:
            return "Home"
        case .games:
            return "Games"
        case .movies:
            return "Movies"
        case .search:
            return "Search"
        }
    }

    var iconName: String{
        switch self {
        case .home:
            return "house"
        case .games:
            return "controller"
        case .movies:
            return "film"
        case .search:
            return "search"
        }
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State var selectedTab = 0
    
    var body: some View {
        
        ZStack(alignment: .bottom){
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)

                GameListView()
                    .tag(1)

                MovieList()
                    .tag(2)

                SearchView()
                    .tag(3)
            }
            ZStack{
                HStack{
                    ForEach((TabbedItems.allCases), id: \.self){ item in
                        Button{
                            selectedTab = item.rawValue
                        } label: {
                            CustomTabItem(imageName: item.iconName, title: item.title, isActive: (selectedTab == item.rawValue))
                        }
                    }
                }
                .padding(6)
            }
            .frame(height: Sizing.SpacerHeader)
            .background(.accent.opacity(0.2))
            .cornerRadius(40)
            .padding(.horizontal, Sizing.SpacerXLarge)
        }
    }
}

extension ContentView{
    func CustomTabItem(imageName: String, title: String, isActive: Bool) -> some View{
        HStack(spacing: Sizing.SpacerSmall){
            Spacer()
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isActive ? .gray09 : .gray05)
                .frame(width: 20, height: 20)
            if isActive{
                Text(title)
                    .font(.system(size: Sizing.SpacerMedium))
                    .foregroundColor(isActive ? .gray09 : .gray05)
            }
            Spacer()
        }
        .frame(width: isActive ? .infinity : 60, height: 60)
        .background(isActive ? .accent.opacity(0.4) : .clear)
        .cornerRadius(30)
    }
}
```

``` Sorting
@State private var sortOption: SortOption = .gameTitle

.sorted(by: { item1, item2 in
    switch sortOption {
    case .gameTitle:
        return item1.gameTitle ?? "Title" < item2.gameTitle ?? "Title"
    case .brand:
        return item1.brand ?? "" < item2.brand ?? ""
    case .locations:
        return item1.locations ?? "" < item2.locations ?? ""
    case .system:
        return item1.system ?? "" < item2.system ?? ""
    }
})
            
Group {
    Menu("\(sortOption)", systemImage: "chevron.up.chevron.down.square") {
        Picker("Sort By", selection: $sortOption) {
            Text("Title").tag(SortOption.gameTitle)
            Text("Brand").tag(SortOption.brand)
            Text("Console").tag(SortOption.system)
            Text("Location").tag(SortOption.locations)
        }
    }
    .bodyStyle()
    .disabled(collections.isEmpty)
}

.onAppear {
    filterSystem = "All"
    filterLocation = "All"
    filterBrand = "Any"
    // sortOption = .gameTitle // Set initial sort if you keep it
}
```
