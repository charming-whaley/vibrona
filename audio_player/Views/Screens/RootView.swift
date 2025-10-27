import SwiftUI
import AVKit

struct RootView: View {
    @State private var audioViewModel: AudioViewModel = .init()
    @State private var expandPlayerView: Bool = false
    @State private var player: AVAudioPlayer?
    
    var body: some View {
        TabView {
            Tab("Library", systemImage: "square.grid.2x2.fill") {
                LibraryView()
                    .environment(audioViewModel)
            }
            
            Tab("Settings", systemImage: "gearshape.fill") {
                SettingsView()
            }
            
            Tab("Search", systemImage: "magnifyingglass", role: .search) {
                SearchView()
            }
        }
        .fullScreenCover(isPresented: $expandPlayerView) {
            PlayerView()
        }
        .tabViewBottomAccessory {
            MiniPlayerView(audioViewModel: audioViewModel)
                .onTapGesture {
                    expandPlayerView = true
                }
        }
        .environment(audioViewModel)
    }
}

#Preview {
    RootView()
}
