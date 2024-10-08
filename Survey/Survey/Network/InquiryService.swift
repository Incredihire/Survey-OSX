import Combine
protocol InquiryService {
    func loadInquiries() -> AnyPublisher<[Inquiry], Error>
}
