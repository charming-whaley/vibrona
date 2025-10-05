import SwiftUI
import SwiftData

struct SearchView: View {
    @State private var searchQuery: String = ""
    @State private var currentCategory: SearchCategoryType = .songs
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                GlobalSearchFieldView(searchQuery: $searchQuery)
                SearchTabSelectionView()
                SearchResultListView(currentCategory: $currentCategory, searchQuery: searchQuery)
            }
            .padding(.top, 8)
        }
    }
    
    @ViewBuilder private func SearchTabSelectionView() -> some View {
        Picker("", selection: $currentCategory) {
            ForEach(SearchCategoryType.allCases) { searchCategoryType in
                Text(searchCategoryType.description)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
}

#Preview {
    SearchView()
        .preferredColorScheme(.dark)
}
