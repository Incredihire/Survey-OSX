# Survey-OSX

##Project Setup and Installation Instructions

##Tools Required
SwiftUIX: A library for enhanced SwiftUI components.
Xcode: Ensure you have the latest version installed.
Repository URL
SwiftUIX Repository

##Installation Steps

1. Clone the Repository
Open Terminal and run the following command to clone the project:
bash
Copy code
git clone https://github.com/your-repo-url.git
Navigate to the project directory:
bash
Copy code
cd your-project-folder
3. Open the Project in Xcode
Open the .xcodeproj or .xcworkspace file in Xcode by double-clicking it or using:
bash
Copy code
open YourProject.xcodeproj
4. Configure OpenID Connect by editing the /Survey/Survey.xcodeproj/project.pbxproj file and replacing the Target -> Build Setting -> User Defined variables below with the proper values supplied by the OIDC provider (i.e. Google Auth)
    - OIDC_AUTHORIZATION_ENDPOINT = "https://accounts.google.com/o/oauth2/v2/auth";
    - OIDC_CLIENT_ID = "0123456789012-abcdef3456g7hi89jk0lm12nop34qr5s.apps.googleusercontent.com";
    - OIDC_ISSUER = "https://accounts.google.com";
    - OIDC_REDIRECT_URL = "com.googleusercontent.apps.0123456789012-abcdef3456g7hi89jk0lm12nop34qr5s:/auth/callback";


##Xcode Development Instructions
1. Build the Project
Press Cmd + B to build your project. This compiles all components and checks for errors before running.
3. Run the App
Press Cmd + R to run the app. Alternatively, click the play button (a triangle) in the top left corner of the Xcode window.

##Possible Errors

When you clone the project and start running it, you might encounter an error: "One of the paths in DEVELOPMENT_ASSET_PATHS does not exist: ..."
Solution: Check the exact path; the name of the folder may appear in red or may not exist at all. If the folder is empty, delete it and recreate it with the exact same name. If it doesn’t exist, create a new folder with the name indicated in the missing path.
