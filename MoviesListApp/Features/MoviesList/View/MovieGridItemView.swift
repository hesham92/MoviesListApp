import SwiftUI
import SwiftData

struct MovieGridItemView: View {
    let item: MovieItem
    @Binding var selectedMovieId: Int?
    @Environment(Router.self) var router

    var body: some View {
        Button(action: {
            selectedMovieId = item.id
            router.navigateToSetup(id: item.id)
        }) {
            VStack(alignment: .leading, spacing: 8) {
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 140)
                        .cornerRadius(8)

                    if let data = item.imageData,
                       let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 140)
                            .clipped()
                            .cornerRadius(8)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundColor(.white)

                    Text(item.releaseDate)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.horizontal, 4)
                .padding(.bottom, 4)
            }
            .padding(6)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(selectedMovieId == item.id ? Color.blue.opacity(0.2) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(selectedMovieId == item.id ? Color.blue : Color.clear, lineWidth: 2)
            )
            .contentShape(Rectangle()) // Ensures the whole area is tappable
        }
        .buttonStyle(PlainButtonStyle()) // Prevents blue tint and preserves custom styles
    }
}

