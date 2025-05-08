import SwiftUI

struct MovieImage: View {
    var path: String = ""

    var body: some View {
        GeometryReader { geometry in
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(path)")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            } placeholder: {
                Color.gray.frame(width: geometry.size.width, height: geometry.size.height)
            }
            .cornerRadius(10)
        }
    }
}

struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        MovieImage(path: "")
    }
}
