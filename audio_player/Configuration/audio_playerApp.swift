import SwiftUI
import SwiftData

@main
struct audio_playerApp: App {
    let container: ModelContainer
    
    init() {
        let schema = Schema([LibraryItem.self])
        let configuration = ModelConfiguration("LibraryItems", schema: schema)
        do {
            self.container = try ModelContainer(for: schema, configurations: configuration)
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
