import SwiftUI

struct MovieDetailsHeaderView: View {
    let viewModel: MovieDetailsHeaderViewPresentation
    
    var body: some View {
        MovieImage(path: viewModel.posterPath)

        HStack(alignment: .top) {
            MovieImage(path: viewModel.posterPath)
                .frame(width: 50, height: 100)
                .padding(.horizontal, 8)
            
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.formattedTitle)
                    .font(.movieTitle)
                
                Text(viewModel.formattedGenres)
            }
        }
        .padding(.top, 10)
    }
}
