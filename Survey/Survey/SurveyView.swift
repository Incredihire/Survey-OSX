import SwiftUI

struct SurveyView: View {
    var question: String
    @State private var selectedOption: String?

    var body: some View {
        VStack(spacing: 20) {
            Text(question)
                .font(.title)
                .foregroundColor(.black)
                .padding()

            HStack {
                Button("Awful") {
                    self.selectedOption = "Awful"
                }
                .buttonStyle(CustomButtonStyle(color: .red))

                Button("Bad") {
                    self.selectedOption = "Bad"
                }
                .buttonStyle(CustomButtonStyle(color: .orange))

                Button("Decent") {
                    self.selectedOption = "Decent"
                }
                .buttonStyle(CustomButtonStyle(color: .blue))

                Button("Good") {
                    self.selectedOption = "Good"
                }
                .buttonStyle(CustomButtonStyle(color: .green))

                Button("Great") {
                    self.selectedOption = "Great"
                }
                .buttonStyle(CustomButtonStyle(color: .green))
            }
            .padding(.horizontal)

            if let selectedOption = selectedOption {
                Text("You selected: \(selectedOption)")
                    .padding()
                    .font(.headline)
            }
        }
        .padding()
    }
}

struct CustomButtonStyle: ButtonStyle {
    var color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0) // Scale down when pressed
    }
}

struct SurveyView_Previews: PreviewProvider {
    static var previews: some View {
        SurveyView(question: "How was your day?")
    }
}
