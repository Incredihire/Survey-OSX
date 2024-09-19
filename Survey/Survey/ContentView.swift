import SwiftUI

struct ContentView: View {
    @ObservedObject var authViewModel: AuthViewModel // Declare AuthViewModel

    var body: some View {
        SurveyView(authViewModel: authViewModel) // Pass it to SurveyView
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(authViewModel: AuthViewModel()) // Provide a mock AuthViewModel for previews
    }
}
