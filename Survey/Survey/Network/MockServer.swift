import Foundation
import Combine
class MockServer: InquiryService {
    func loadInquiries() -> AnyPublisher<[Inquiry], Error> {
        guard let url = Bundle.main.url(forResource: "db", withExtension: "json") else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "File not found"])
            return Fail(error: error).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Inquiry].self, decoder: JSONDecoder())
            .handleEvents(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    Logger.shared.log(error: error)
                }
            })
            .eraseToAnyPublisher()
    }
}
