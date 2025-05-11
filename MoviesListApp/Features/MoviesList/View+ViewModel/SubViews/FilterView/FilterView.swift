import SwiftUI
import SwiftData

struct FilterView: View {
    @ObservedObject var viewModel: FilterViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewModel.filters, id: \.self) { filter in
                    Button(action: {
                        viewModel.toggleFilter(filter)
                    }) {
                        Text(filter.name)
                            .font(.system(size: 14, weight: .medium))
                            .padding(.horizontal, 24)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(viewModel.backgroundColor(for: filter))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.yellow, lineWidth: 1)
                                    )
                            )
                            .foregroundColor(viewModel.textColor(for: filter))
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

