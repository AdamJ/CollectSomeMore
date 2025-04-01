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
            .frame(height: Constants.SpacerHeader)
            .background(.accent.opacity(0.2))
            .cornerRadius(40)
            .padding(.horizontal, Constants.SpacerXLarge)
        }
    }
}

extension ContentView{
    func CustomTabItem(imageName: String, title: String, isActive: Bool) -> some View{
        HStack(spacing: Constants.SpacerSmall){
            Spacer()
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isActive ? .gray09 : .gray05)
                .frame(width: 20, height: 20)
            if isActive{
                Text(title)
                    .font(.system(size: Constants.SpacerMedium))
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
