import SwiftUI
import SwiftData
import Kingfisher

struct MovieGridItemView: View {
    let item: MovieItemViewPresentation
    @Environment(Router.self) var router

    var body: some View {
        Button(action: {
            router.navigateToMovieItemDetails(movieItemId: item.id)
        }) {
            VStack(alignment: .leading, spacing: 8) {
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 140)
                        .cornerRadius(8)
                    
                    MovieImageView(path: item.posterPath)
                        .frame(height: 140)
                        .clipped()
                        .cornerRadius(8)
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
            .contentShape(Rectangle()) // Ensures the whole area is tappable
        }
        .buttonStyle(PlainButtonStyle()) // Prevents blue tint and preserves custom styles
    }
}

