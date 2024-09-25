import Foundation
import os

class Logger {
    static let shared = Logger()
    private let log: OSLog

    private init() {
        self.log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.yourapp.default", category: "General")
    }
    func log(error: Error) {
        os_log("Error logged: %@", log: log, type: .error, error.localizedDescription)
    }
   func log(message: String) {
        os_log("%@", log: log, type: .info, message)
    }
}
