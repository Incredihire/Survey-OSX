import SwiftUI

@main
struct SurveyApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            ContentLoginView(authViewModel: authViewModel)
        }
    }
}
