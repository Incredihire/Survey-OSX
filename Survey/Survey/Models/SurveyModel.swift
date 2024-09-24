import Foundation
import Combine

class SurveyViewModel: ObservableObject {
    @Published var inquiries: [Inquiry] = []
    private var cancellables = Set<AnyCancellable>()
    private let mockServer = MockServer()

    init() {
        loadInquiries()
    }

    func loadInquiries() {
        attemptLoadInquiries()
    }

    private func attemptLoadInquiries() {
        mockServer.loadInquiries()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    Logger.shared.log(error: error)
                    self?.retryLoadInquiries()
                }
            }, receiveValue: { [weak self] inquiries in
                self?.inquiries = inquiries
            })
            .store(in: &cancellables)
    }

    private func retryLoadInquiries() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.attemptLoadInquiries()
        }
    }
}
