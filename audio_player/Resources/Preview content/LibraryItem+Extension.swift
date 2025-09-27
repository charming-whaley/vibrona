extension LibraryItem {
    static var sampleLibraryItems: [LibraryItem] {
        return [
            LibraryItem(title: "Liked", systemImage: "heart.fill", libraryItemType: .songs, isSystemItem: true),
            LibraryItem(title: "Songs", systemImage: "music.note", libraryItemType: .songs, isSystemItem: false),
            LibraryItem(title: "Playlists", systemImage: "music.note.square.stack.fill", libraryItemType: .playlist, isSystemItem: true),
            LibraryItem(title: "Albums", systemImage: "rectangle.stack.fill", libraryItemType: .album, isSystemItem: true)
        ]
    }
}
