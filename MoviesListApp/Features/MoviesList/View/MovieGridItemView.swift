import SwiftUI
import SwiftData

struct MovieGridItemView: View {
    let item: MovieItem
    @Binding var selectedMovieId: Int?

    var body: some View {
        Button {
            selectedMovieId = item.id
        } label: {
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

                VStack(alignment: .leading, spacing: 8) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundColor(.white)

                    Text(item.releaseDate)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .padding(.leading, 8)
            }
            .frame(maxWidth: .infinity)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
