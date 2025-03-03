import Foundation
import AppKit
import Combine

class SurveyViewModel: ObservableObject {
    @Published var inquiry: Inquiry?
    private var cancellables = Set<AnyCancellable>()
    private let surveyServer = SurveyServer()

    func loadInquiry() {
        self.attemptLoadInquiry()
    }

    private func attemptLoadInquiry() {
        guard let authState = AppDelegate.instance.authState else {
            Logger.shared.log(message: "Auth state not available")
            retryLoadInquiry()
            return
        }
        let currentAccessToken = authState.lastTokenResponse?.accessToken!
        let currentIdToken = authState.lastTokenResponse?.idToken!
        authState.performAction { (accessToken, idToken, error) in
            if error != nil {
                Logger.shared.log(message: "Error fetching fresh tokens: \(error?.localizedDescription ?? "ERROR")")
                self.retryLoadInquiry()
                return
            }
            guard let accessToken = accessToken else {
                Logger.shared.log(message: "Error getting accessToken")
                self.retryLoadInquiry()
                return
            }
            guard let idToken = idToken else {
                Logger.shared.log(message: "Error getting idToken")
                self.retryLoadInquiry()
                return
            }
            if currentAccessToken != accessToken {
                Logger.shared.log(message: "Access token was refreshed automatically")
            } else {
                Logger.shared.log(message: "Access token was fresh and not updated")
            }
            if currentIdToken != idToken {
                Logger.shared.log(message: "ID token was refreshed automatically")
            } else {
                Logger.shared.log(message: "ID token was fresh and not updated")
            }
            self.surveyServer.loadInquiry()
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
                .store(in: &self.cancellables)
       }
    }

    private func retryLoadInquiry() {
        // Retry every 5 seconds if user has not logged in before otherwise retry in 10 minutes
        DispatchQueue.main.asyncAfter(deadline: .now() + (AppDelegate.instance.authState == nil ? 5 : 10 * 60)) {
            self.attemptLoadInquiry()
        }
    }
}
