import SwiftUI

struct RootView: View {
    @State private var audioViewModel: AudioViewModel = .init()
    @State private var expandPlayerView: Bool = false
    
    var body: some View {
        TabView {
            Tab("Library", systemImage: "square.grid.2x2.fill") {
                LibraryView()
                    .environment(audioViewModel)
            }
            
            Tab("Settings", systemImage: "gearshape.fill") {
                SettingsView()
                    .environment(audioViewModel)
            }
            
            Tab("Search", systemImage: "magnifyingglass", role: .search) {
                SearchView()
                    .environment(audioViewModel)
            }
        }
        .fullScreenCover(isPresented: $expandPlayerView) {
            PlayerView()
                .environment(audioViewModel)
        }
        .tabViewBottomAccessory {
            MiniPlayerView()
                .environment(audioViewModel)
                .onTapGesture {
                    expandPlayerView = true
                }
        }
    }
}

#Preview {
    RootView()
}
