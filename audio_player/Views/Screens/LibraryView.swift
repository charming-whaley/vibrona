import SwiftUI
import SwiftData

struct LibraryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \LibraryItem.title) private var libraryItems: [LibraryItem]
    @State private var addsNewSection: Bool = false
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                LibraryHeaderView(addsNewSection: $addsNewSection)
                
                ForEach(libraryItems) { libraryItem in
                    NavigationLink {
                        // Link to the Section
                    } label: {
                        LibraryItemView(of: libraryItem)
                    }
                    .contextMenu {
                        Button {
                            
                        } label: {
                            Label("Rename...", systemImage: "rectangle.and.pencil.and.ellipsis")
                        }
                        
                        Button(role: .destructive) {
                            modelContext.delete(libraryItem)
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                    }
                    
                    if let lastItemId = libraryItems.last, libraryItem.id != lastItemId.id {
                        Divider()
                            .padding(.horizontal)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .scrollIndicators(.hidden)
        .sheet(isPresented: $addsNewSection) {
            NewLibrarySectionView()
                .interactiveDismissDisabled()
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    let preview = PreviewContainer(LibraryItem.self)
    preview.insert(LibraryItem.sampleLibraryItems)
    
    return LibraryView()
        .modelContainer(preview.container)
}
