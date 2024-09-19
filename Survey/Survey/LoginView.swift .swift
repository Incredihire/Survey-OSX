import SwiftUI

struct LoginView: View {
    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            Text("Welcome Back!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)

            TextField("Username", text: $authViewModel.username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $authViewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                // Explicitly specify the login parameters
                authViewModel.login(completion: { success in
                    if success {
                        // Handle successful login, you may want to navigate to the survey view
                    } else {
                        // Handle login failure (show an alert, for example)
                    }
                })
            }) {
                Text("Log In")
                    .fontWeight(.semibold)
                    .font(.headline)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .shadow(color: Color.blue.opacity(0.5), radius: 5)
            }
            .frame(maxWidth: 200)
            .padding(.top, 20)

            Spacer()
        }
        .padding()
    }
}
