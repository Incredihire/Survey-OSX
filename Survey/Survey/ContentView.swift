import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello World")
            .font(.largeTitle)
            .padding()
    }
}

// Define the preview for ContentView
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone 14") // Specify the device model here
                .previewDisplayName("iPhone 14") // Optional: Add a display name for the preview
                .previewLayout(.device) // Ensure the preview is shown in device shape

            ContentView()
                .previewDevice("iPad Pro (12.9-inch) (6th generation)") // Preview on iPad
                .previewDisplayName("iPad Pro") // Optional: Add a display name for the preview
                .previewLayout(.device) // Ensure the preview is shown in device shape
        }
    }
}
