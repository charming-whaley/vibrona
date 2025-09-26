import SwiftUI
import SwiftData

struct LibraryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var libraryItems: [LibraryItem]
    @State private var addsNewSection: Bool = false
    @State private var sortOrder: SortOrder = .title
    
    init() {
        let sortDescriptors: [SortDescriptor<LibraryItem>] = switch sortOrder {
        case .title:
            [SortDescriptor(\LibraryItem.title)]
        case .dateAdded:
            [SortDescriptor(\LibraryItem.dateAdded)]
        }
        
        _libraryItems = Query(sort: sortDescriptors)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    LibraryHeaderView(
                        addsNewSection: $addsNewSection,
                        sortOrder: $sortOrder
                    )
                    
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
                    .presentationDetents([.height(200)])
            }
        }
    }
}

#Preview {
    let preview = PreviewContainer(LibraryItem.self)
    preview.insert(LibraryItem.sampleLibraryItems)
    
    return LibraryView()
        .modelContainer(preview.container)
}
