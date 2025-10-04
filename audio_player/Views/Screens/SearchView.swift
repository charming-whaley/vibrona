import SwiftUI
import SwiftData

struct SearchView: View {
    @State private var searchQuery: String = ""
    @State private var currentCategory: SearchCategoryType = .songs
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                GlobalSearchFieldView(searchQuery: $searchQuery)
                    .padding(.horizontal)
                
                Picker("", selection: $currentCategory) {
                    ForEach(SearchCategoryType.allCases) { searchCategoryType in
                        Text(searchCategoryType.description)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                SearchResultListView(currentCategory: $currentCategory)
            }
            .padding(.top, 8)
        }
    }
}

#Preview {
    SearchView()
        .preferredColorScheme(.dark)
}
