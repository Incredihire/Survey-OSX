import Foundation
import os

class Logger {
    static let shared = Logger()
    private let log: OSLog

    private init() {
        self.log = OSLog(
            subsystem: Bundle.main.bundleIdentifier ?? "Incredihire-LLC.Survey",
            category: "MockServer"
        )
    }
 func log(error: Error, customMessage: String? = nil) {
        let message = customMessage != nil
            ? "\(customMessage!): \(error.localizedDescription)"
            : error.localizedDescription
        os_log("Error logged: %@", log: log, type: .error, message)
    }
 func log(message: String) {
        os_log("%@", log: log, type: .info, message)
    }
}
