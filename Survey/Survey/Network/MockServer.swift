import Foundation
import Combine

class MockServer {
    func loadInquiries() -> AnyPublisher<[Inquiry], Error> {
        guard let url = Bundle.main.url(forResource: "db", withExtension: "json") else {
            return Fail(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "File not found"])).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Inquiry].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
