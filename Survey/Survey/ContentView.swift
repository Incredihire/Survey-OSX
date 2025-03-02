import SwiftUI
struct ContentView: View {
    @StateObject private var viewModel = SurveyViewModel()
    var body: some View {
        VStack {
            if let inquiry = viewModel.inquiry {
                SurveyView(question: inquiry.text)
            } else {
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .onAppear {
            viewModel.loadInquiry()
        }
    }
}
