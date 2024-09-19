import SwiftUI

struct ContentLoginView: View {
    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {
        Group {
            if authViewModel.isLoggedIn {
                SurveyView(authViewModel: authViewModel) // Pass the AuthViewModel here
            } else {
                LoginView(authViewModel: authViewModel)
            }
        }
    }
}
