import SwiftUI

struct RootView: View {
    @State private var expandPlayerView: Bool = false
    
    var body: some View {
        TabView {
            Tab("Library", systemImage: "square.grid.2x2.fill") {
                LibraryView()
            }
            
            Tab("Settings", systemImage: "gearshape.fill") {
                SettingsView()
            }
            
            Tab(role: .search) {
                
            }
        }
        .fullScreenCover(isPresented: $expandPlayerView) {
            PlayerView()
        }
        .tabViewBottomAccessory {
            MiniPlayerView()
                .onTapGesture {
                    expandPlayerView = true
                }
        }
    }
}

#Preview {
    RootView()
}
