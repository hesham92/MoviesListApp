import SwiftUI
import Kingfisher

struct MovieImageView: View {
    var path: String = ""
    var mainImagePath = "https://image.tmdb.org/t/p/w500"
    
    var body: some View {
        KFImage(URL(string: "\(mainImagePath)\(path)"))
            .cacheOriginalImage()
            .resizable()
            .scaledToFill()
            .clipped()
            .cornerRadius(8)
    }
}
