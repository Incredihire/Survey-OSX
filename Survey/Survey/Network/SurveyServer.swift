import AppKit
import Combine
class SurveyServer: InquiryService {
    private func getRequest(path: String) -> URLRequest {
        let url = URL(string: "\(ProcessInfo.processInfo.environment["API_SERVER_BASE_URL"]!)/api/v1/\(path)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if let currentIdToken: String = AppDelegate.instance.authState?.lastTokenResponse?.idToken {
            request.setValue( "Bearer \(currentIdToken)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    func loadInquiry() -> AnyPublisher<Inquiry, Error> {
        let request = getRequest(path: "inquiries/current")
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Inquiry.self, decoder: JSONDecoder())
            .handleEvents(receiveCompletion: { completion in
                if case .failure = completion {
                    print("Network request failed")
                }
            })
            .eraseToAnyPublisher()
    }
}
