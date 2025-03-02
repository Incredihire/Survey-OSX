import Foundation
import AppKit
import Combine

class SurveyViewModel: ObservableObject {
    @Published var inquiry: Inquiry? = nil
    private var cancellables = Set<AnyCancellable>()
    private let surveyServer = SurveyServer()

    func loadInquiry() {
        self.attemptLoadInquiry()
    }

    private func attemptLoadInquiry() {
        surveyServer.loadInquiry()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    Logger.shared.log(error: error)
                    self?.retryLoadInquiry()
                }
            }, receiveValue: { [weak self] inquiry in
                self?.inquiry = inquiry
            })
            .store(in: &cancellables)
    }

    private func retryLoadInquiry() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.attemptLoadInquiry()
        }
    }
}
