import SwiftUI

struct MovieDetailsContentView: View {
    var viewModel: MovieDetailsContentViewPresentation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.overviewText)
                .padding(.vertical, 8)
            
            Text(viewModel.homepageText)
                .underline()
                .foregroundColor(.movieAccent)
                .padding(.vertical, 4)
            
            
            Text(viewModel.languagesText)
                .padding(.vertical, 4)
        }
        .font(.movieBody)
        
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.budgetText)
                Text(viewModel.statusText)
            }

            Spacer()

            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.runtimeText)
                Text(viewModel.revenueText)
            }
        }
        .font(.movieBody)
        .padding(.top, 8)
    }
}

