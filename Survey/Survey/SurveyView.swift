import SwiftUI
import SwiftUIX

struct SurveyView: View {
    var question: String
    @State private var selectedOption: String?

    var body: some View {
        VStack(spacing: 20) {
            Text(question)
                .font(.title)
                .foregroundColor(.black)
                .padding()

            HStack(spacing: 40) {
                ForEach(options.indices, id: \.self) { index in
                    let option = options[index]
                    VStack {
                        Button(action: {
                            selectedOption = option
                        }, label: {
                            Circle()
                                .stroke(Color.black, lineWidth: 2)
                                .background(
                                    Circle()
                                        .fill(selectedOption == option ? Color.black : Color.clear)
                                        .padding(4)
                                )
                                .frame(width: 15, height: 15)
                        })

                        Text(option)
                            .frame(width: 180, height: 40)
                            .background(selectedOption == option ? Color.gray.opacity(0.3) : Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 3)
                            )
                            .cornerRadius(8)
                            .foregroundColor(.black)
                    }
                }
            }
            .padding()

            Button(action: {
                print("Selected option: \(selectedOption ?? "None")")
            }, label: {
                Text("Submit")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(minWidth: 150)
                    .background(Color.green)
                    .cornerRadius(8)
            })
            .buttonStyle(PlainButtonStyle())
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black, lineWidth: 2)
            )
            .padding(0)
        }
        .padding()
        .background(Color.white)
    }

    private var options: [String] {
        ["Strongly disagree", "Disagree", "Neither agree nor disagree", "Agree", "Strongly agree"]
    }
}

struct SurveyView_Previews: PreviewProvider {
    static var previews: some View {
        SurveyView(question: "My day was productive.")
    }
}
