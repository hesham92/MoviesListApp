import SwiftUI

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Error: \(message)")
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
            Button("Retry", action: retryAction)
                .padding()
                .background(Color.movieAccent)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding()
    }
}
