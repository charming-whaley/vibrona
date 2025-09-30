import SwiftUI
import SwiftData

@main
struct audio_playerApp: App {
    let container: ModelContainer
    
    init() {
        if let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            print("All DBs are stored in\n:\(url.path)")
        }
        
        let schema = Schema([LibraryItem.self, Song.self])
        let configuration = ModelConfiguration("LibraryItems", schema: schema)
        do {
            self.container = try ModelContainer(for: schema, configurations: configuration)
            
            let context = ModelContext(container)
            let fetchDescriptor = FetchDescriptor<LibraryItem>(predicate: #Predicate { $0.isSystemItem == true })
            
            if let systemItems = try? context.fetch(fetchDescriptor), systemItems.isEmpty {
                let defaultItems: [LibraryItem] = [
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
                
                let defaultSongs: [Song] = [
                    Song(
                        title: "Welcome to New York",
                        artist: "Taylor Swift",
                        filePath: "some/file/path",
                        playCount: 150
                    ),
                    Song(
                        title: "Starboy",
                        artist: "The Weeknd",
                        filePath: "some/file/path",
                        playCount: 2
                    ),
                    Song(
                        title: "Dreams",
                        artist: "Lost Sky",
                        filePath: "some/file/path",
                        playCount: 71
                    ),
                    Song(
                        title: "My Universe",
                        artist: "BTS",
                        filePath: "some/file/path",
                        playCount: 12
                    ),
                    Song(
                        title: "Centuries",
                        artist: "Fall Out Boys",
                        filePath: "some/file/path",
                        playCount: 36
                    ),
                    Song(
                        title: "Save your tears",
                        artist: "The Weeknd",
                        filePath: "some/file/path",
                        playCount: 21
                    ),
                    Song(
                        title: "Numb",
                        artist: "Linkin Park",
                        filePath: "some/file/path",
                        playCount: 0
                    ),
                    Song(
                        title: "Highway to Hell",
                        artist: "AC/DC",
                        filePath: "some/file/path",
                        playCount: 5
                    )
                ]
                
                for defaultItem in defaultItems {
                    context.insert(defaultItem)
                }
                
                for defaultSong in defaultSongs {
                    context.insert(defaultSong)
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
