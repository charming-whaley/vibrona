import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            Tab("Library", systemImage: "square.grid.2x2.fill") {
                LibraryView()
            }
            
            Tab("Settings", systemImage: "gearshape.fill") {
                SettingsView()
            }
        }
    }
}

#Preview {
    RootView()
}
