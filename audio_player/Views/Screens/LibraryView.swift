import SwiftUI
import SwiftData

struct LibraryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var libraryItems: [LibraryItem]
    @State private var addsNewSection: Bool = false
    @State private var sortOrder: SortOrder = .title
    
    @State private var renameSection: Bool = false
    @State private var newSectionName: String = "New Name"
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
                            if !libraryItem.isSystemItem {
                                Button {
                                    currentLibraryItem = libraryItem
                                    renameSection = true
                                } label: {
                                    Label("Rename...", systemImage: "rectangle.and.pencil.and.ellipsis")
                                }
        
                                Button(role: .destructive) {
                                    currentLibraryItem = libraryItem
                                    deleteSection = true
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
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
            .alert("Delete Category?", isPresented: $deleteSection) {
                Button("Cancel") {
                    currentLibraryItem = nil
                    deleteSection = false
                }
                
                Button("Delete") {
                    if let libraryItem = currentLibraryItem {
                        modelContext.delete(libraryItem)
                    }
                    
                    currentLibraryItem = nil
                    deleteSection = false
                }
            } message: {
                Text("Do you actually want to delete this category? This action does not affect included content")
            }
            .alert("Rename Category", isPresented: $renameSection) {
                TextField("Give new name...", text: $newSectionName)
                
                HStack {
                    Button("Cancel") {
                        currentLibraryItem = nil
                        renameSection = false
                    }
                    
                    Button("Rename") {
                        if let libraryItem = currentLibraryItem {
                            libraryItem.title = newSectionName
                            try? modelContext.save()
                        }
                        
                        currentLibraryItem = nil
                        renameSection = false
                    }
                }
            }
            .sheet(isPresented: $addsNewSection) {
                NewLibrarySectionView()
                    .presentationDetents([.height(280)])
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
