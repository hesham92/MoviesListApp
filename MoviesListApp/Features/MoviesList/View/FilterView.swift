import SwiftUI
import SwiftData

struct FilterView: View {
    let filters: [String]
    @Binding var selectedFilter: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(filters, id: \.self) { filter in
                    Button(action: {
                        selectedFilter = filter
                    }) {
                        Text(filter)
                            .font(.system(size: 14, weight: .medium))
                            .padding(.horizontal, 24)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(selectedFilter == filter ? Color.yellow : Color.black)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.yellow, lineWidth: 1)  // Optional border around unselected button
                                    )
                            )
                            .foregroundColor(selectedFilter == filter ? .black : .white)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
