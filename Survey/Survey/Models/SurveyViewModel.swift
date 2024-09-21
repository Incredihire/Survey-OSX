import Foundation
import Combine

class SurveyViewModel: ObservableObject {
    @Published var inquiries: [Inquiry] = []
    private var cancellables = Set<AnyCancellable>()
    private let mockServer = MockServer()

    func loadInquiries() {
        mockServer.loadInquiries()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to load inquiries: \(error)")
                
                    DispatchQueue.main.asyncAfter(deadline: .now() + 600) {
                        self.loadInquiries()
                    }
                }
            }, receiveValue: { [weak self] inquiries in
                self?.inquiries = inquiries
            })
            .store(in: &cancellables)
    }
}
