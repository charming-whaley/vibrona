import SwiftUI

struct LibraryItemView: View {
    let libraryItem: LibraryItem
    
    init(of libraryItem: LibraryItem) {
        self.libraryItem = libraryItem
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: libraryItem.systemImage)
                .font(.title2)
                .foregroundStyle(.blue)
            
            Text(libraryItem.title)
                .font(.headline)
                .foregroundStyle(.black)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .contentShape(.rect)
    }
}

#Preview {
    LibraryItemView(of: LibraryItem.sampleLibraryItems[0])
}
