import SwiftUI

class FilterViewModel: ObservableObject {
    @Binding var selectedFilter: Genre?
    let filters: [Genre]

    // Computed properties to manage color based on selected filter
    func backgroundColor(for filter: Genre) -> Color {
        return selectedFilter == filter ? Color.yellow : Color.black
    }

    func textColor(for filter: Genre) -> Color {
        return selectedFilter == filter ? Color.black : Color.white
    }

    init(filters: [Genre], selectedFilter: Binding<Genre?>) {
        self.filters = filters
        self._selectedFilter = selectedFilter
    }

    func toggleFilter(_ filter: Genre) {
        if selectedFilter == filter {
            selectedFilter = nil
        } else {
            selectedFilter = filter
        }
    }
}

