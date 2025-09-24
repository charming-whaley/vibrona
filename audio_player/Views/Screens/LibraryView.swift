import SwiftUI
import SwiftData

struct LibraryView: View {
    @Query private var libraryItems: [LibraryItem]
    @State private var addsNewSection: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            LibraryHeaderView(addsNewSection: $addsNewSection)
        }
    }
}

#Preview {
    let preview = PreviewContainer(LibraryItem.self)
    preview.insert(LibraryItem.sampleLibraryItems)
    
    return LibraryView()
        .modelContainer(preview.container)
}
