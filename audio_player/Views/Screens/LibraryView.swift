import SwiftUI
import SwiftData

struct LibraryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var libraryItems: [LibraryItem]
    
    @State private var currentLibraryItem: LibraryItem?
    @State private var sortOrder: LibrarySortOrder = .title
    @State private var newSectionName: String = "New Name"
    @State private var renameSection: Bool = false
    @State private var deleteSection: Bool = false
    @State private var addsNewSection: Bool = false
    
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
                LibraryContentView()
            }
            .scrollIndicators(.hidden)
            .alert("Delete Category?", isPresented: $deleteSection) {
                Button("Cancel", action: resetSectionDeleteAction)
                Button("Delete", action: deleteSectionItem)
            } message: {
                Text("Do you actually want to delete this category? This action does not affect included content")
            }
            .alert("Rename Category", isPresented: $renameSection) {
                TextField("Give new name...", text: $newSectionName)
                
                HStack {
                    Button("Cancel", action: resetSectionRenameAction)
                    Button("Rename", action: renameSectionItem)
                }
            }
            .sheet(isPresented: $addsNewSection) {
                NewLibrarySectionView()
                    .presentationDetents([.height(260)])
            }
        }
    }
    
    @ViewBuilder private func LibraryContentView() -> some View {
        LazyVStack(alignment: .leading, spacing: 0) {
            LibraryHeaderView(addsNewSection: $addsNewSection, sortOrder: $sortOrder)
            
            ForEach(libraryItems) { libraryItem in
                if libraryItem.isSystemItem {
                    LibraryNavigationItemView(libraryItem)
                }
            }
            
            Text("Your categories")
                .font(.callout)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
                .padding(.top, 12)
                .padding(.bottom, 4)
            
            ForEach(libraryItems) { libraryItem in
                if !libraryItem.isSystemItem {
                    LibraryNavigationItemView(libraryItem)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
    
    @ViewBuilder private func LibraryNavigationItemView(_ libraryItem: LibraryItem) -> some View {
        NavigationLink {
            switch libraryItem.libraryItemType {
            case .songs:
                if libraryItem.isSystemItem {
                    GlobalSongsListView()
                } else {
                    SongsListView(libraryItem: libraryItem)
                }
            case .playlist:
                if libraryItem.isSystemItem {
                    GlobalPlaylistsListView()
                } else {
                    PlaylistsListView(libraryItem: libraryItem)
                }
            }
        } label: {
            LibraryItemView(of: libraryItem)
        }
        .contextMenu {
            if !libraryItem.isSystemItem {
                Button {
                    setSectionRenameAction(libraryItem)
                } label: {
                    Label("Rename...", systemImage: "rectangle.and.pencil.and.ellipsis")
                }
                
                Button(role: .destructive) {
                    setSectionDeleteAction(libraryItem)
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
    
    private func deleteSectionItem() {
        if let libraryItem = currentLibraryItem {
            modelContext.delete(libraryItem)
        }
        
        resetSectionDeleteAction()
    }
    
    private func setSectionDeleteAction(_ libraryItem: LibraryItem) {
        currentLibraryItem = libraryItem
        deleteSection = true
    }
    
    private func resetSectionDeleteAction() {
        currentLibraryItem = nil
        deleteSection = false
    }
    
    private func renameSectionItem() {
        if let libraryItem = currentLibraryItem {
            libraryItem.title = newSectionName
            
            do {
                try modelContext.save()
            } catch {
                print("[Fatal error]: couldn't save the context:\n\n\(error)")
            }
        }
        
        resetSectionRenameAction()
    }
    
    private func setSectionRenameAction(_ libraryItem: LibraryItem) {
        currentLibraryItem = libraryItem
        renameSection = true
    }
    
    private func resetSectionRenameAction() {
        currentLibraryItem = nil
        renameSection = false
    }
}

#Preview {
    let preview = PreviewContainer(LibraryItem.self)
    preview.insert(LibraryItem.sampleLibraryItems)
    
    return LibraryView()
        .preferredColorScheme(.dark)
        .modelContainer(preview.container)
}
