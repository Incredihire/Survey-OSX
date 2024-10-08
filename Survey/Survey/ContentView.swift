import SwiftUI
struct ContentView: View {
    @StateObject private var viewModel = SurveyViewModel()
    var body: some View {
        VStack {
            if let inquiry = viewModel.inquiries.first {
                SurveyView(question: inquiry.question)
            } else {
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .onAppear {
            viewModel.loadInquiries()
        }
    }
}
