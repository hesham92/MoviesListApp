import SwiftUI

struct MovieImage: View {
    var path: String = ""

    var body: some View {
        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(path)")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .frame(maxWidth: .infinity, maxHeight: 140)
                            .scaledToFill()
                            .clipped()
                    default:
                        EmptyView() // No placeholder, just empty
                    }
                }
                .cornerRadius(10)
    }
}

struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        MovieImage(path: "")
    }
}
