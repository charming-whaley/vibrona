import SwiftUI
import SwiftData

struct LibraryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var libraryItems: [LibraryItem]
    @State private var addsNewSection: Bool = false
    @State private var sortOrder: SortOrder = .title
    
    @State private var deleteSection: Bool = false
    @State private var currentLibraryItem: LibraryItem?
    
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
                    LibraryHeaderView(addsNewSection: $addsNewSection, sortOrder: $sortOrder)
                    
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
                                currentLibraryItem = libraryItem
                                deleteSection = true
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                            .disabled(libraryItem.isSystemItem)
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
            .alert("Delete Category?", isPresented: $deleteSection, actions: {
                Button("Delete", role: .destructive) {
                    if let libraryItem = currentLibraryItem {
                        modelContext.delete(libraryItem)
                    }
                    currentLibraryItem = nil
                    deleteSection = false
                }
            }, message: {
                Text("Do you actually want to delete this category? This action does not affect included content")
            })
            .sheet(isPresented: $addsNewSection) {
                NewLibrarySectionView()
                    .presentationDetents([.height(300)])
            }
        }
    }
}

#Preview {
    let preview = PreviewContainer(LibraryItem.self)
    preview.insert(LibraryItem.sampleLibraryItems)
    
    return LibraryView()
        .preferredColorScheme(.dark)
        .modelContainer(preview.container)
}
