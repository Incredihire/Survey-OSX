import Foundation

class Logger {
    static let shared = Logger()
    private init() {}
    func log(error: Error) {
        print("Error logged: \(error.localizedDescription)")
    }
}
