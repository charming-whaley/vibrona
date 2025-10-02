import SwiftUI

struct NoPlaylistsView: View {
    var body: some View {
        ContentUnavailableView("No Playlists...", systemImage: "music.note.list")
    }
}
