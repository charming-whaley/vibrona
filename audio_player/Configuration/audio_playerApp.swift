import SwiftUI
import SwiftData

@main
struct audio_playerApp: App {
    let container: ModelContainer
    
    init() {
        if let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            print("All DBs are stored in\n:\(url.path)")
        }
        
        let schema = Schema([LibraryItem.self])
        let configuration = ModelConfiguration("LibraryItems", schema: schema)
        do {
            self.container = try ModelContainer(for: schema, configurations: configuration)
            
            let context = ModelContext(container)
            let fetchDescriptor = FetchDescriptor<LibraryItem>(predicate: #Predicate { $0.isSystemItem == true })
            
            if let systemItems = try? context.fetch(fetchDescriptor), systemItems.isEmpty {
                let defaultItems: [LibraryItem] = [
                    .init(
                        title: "Liked",
                        systemImage: "heart.fill",
                        libraryItemType: .songs,
                        isSystemItem: true
                    ),
                    .init(
                        title: "Songs",
                        systemImage: "music.note",
                        libraryItemType: .songs,
                        isSystemItem: true
                    ),
                    .init(
                        title: "Playlists",
                        systemImage: "music.note.square.stack.fill",
                        libraryItemType: .playlist,
                        isSystemItem: true
                    )
                ]
                
                for defaultItem in defaultItems {
                    context.insert(defaultItem)
                }
                
                try? context.save()
            }
        } catch {
            fatalError("[Fatal error]: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(container)
    }
}
