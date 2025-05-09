import SwiftUI
import SwiftData

struct MoviesListView: View {
    @Environment(\.modelContext) private var context
    
    var body: some View {
        MoviesListContent(modelContext: context)
    }
}

struct MoviesListContent: View {
    @ObservedObject private var viewModel: MoviesListViewModel
    @State private var showAlert = false

    init(modelContext: ModelContext) {
        _viewModel = ObservedObject(wrappedValue: MoviesListViewModel(context: modelContext))
    }
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State private var selectedFilter: String = ""
    
    let filters = ["Action", "Adventure", "Animation", "Comedy", "Crime", "Documentary", "Drama", "Family", "Fantasy", "History", "Horror", "Music", "Mystery", "Romance", "Science Fiction", "TV Movie", "Thriller", "War", "Western"]

    
    var body: some View {
        ZStack {
            VStack {
                SegmentedControlView(filters: filters, selectedFilter: $viewModel.selectedFilter)
                    .padding(.bottom, 10)
                    .frame(height: 40)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.movies.indices, id: \.self) { index in
                            let item = viewModel.movies[index]
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
                            .onAppear {
                                if index == viewModel.movies.count - 1 {
                                    viewModel.loadData()
                                }
                            }
                        }
                    }
                    
                }
                .onAppear {
                    viewModel.viewDidAppear()
                }
            }
           
            
            if viewModel.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            }
        }
        .background(Color(UIColor.black))
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? "Unknown error"),
                dismissButton: .default(Text("OK")) {
                    viewModel.errorMessage = nil
                }
            )
        }
        .onChange(of: viewModel.errorMessage) { error in
            showAlert = error != nil
        }
    }
}

