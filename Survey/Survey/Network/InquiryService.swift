import Combine
protocol InquiryService {
    func loadInquiry() -> AnyPublisher<Inquiry, Error>
}
