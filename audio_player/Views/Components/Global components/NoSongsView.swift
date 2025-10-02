import SwiftUI

struct NoSongsView: View {
    var body: some View {
        ContentUnavailableView("No Songs...", systemImage: "music.note.list")
    }
}
