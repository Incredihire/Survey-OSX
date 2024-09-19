import SwiftUI

struct ContentView: View {
    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {
        SurveyView(authViewModel: authViewModel) //
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(authViewModel: AuthViewModel()) 
    }
}
