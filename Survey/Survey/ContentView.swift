import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SurveyViewModel()

    var body: some View {
        VStack {
            if viewModel.inquiries.isEmpty {
                Text("Loading... Please wait.")
                    .onAppear {
                        viewModel.loadInquiries()
                    }
            } else if let firstInquiry = viewModel.inquiries.first {
                SurveyView(question: firstInquiry.question)
            } else {
                Text("No inquiries available.")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
