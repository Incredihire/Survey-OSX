import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SurveyViewModel()

    var body: some View {
        VStack {
            if viewModel.inquiries.isEmpty {
                EmptyView()
            } else {
                ForEach(viewModel.inquiries) { inquiry in
                    SurveyView(question: inquiry.question)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .onAppear {
            viewModel.loadInquiries()
        }
    }
}
