import AppAuth
import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate, OIDAuthStateChangeDelegate {

    var currentAuthorizationFlow: OIDExternalUserAgentSession?

    typealias PostRegistrationCallback = (_ configuration: OIDServiceConfiguration?, _ registrationResponse: OIDRegistrationResponse?) -> Void

    /**
     The OIDC issuer from which the configuration will be discovered.
    */
    let kIssuer: String = "https://accounts.google.com";

    /**
     The OAuth client ID.

     For client configuration instructions, see the [README](https://github.com/openid/AppAuth-iOS/blob/master/Examples/Example-iOS_Swift-Carthage/README.md).
     Set to nil to use dynamic registration with this example.
    */
    let kClientID: String? = "OIDC_CLIENT_ID_HERE";

    let kClientSecret: String? = "OIDC_CLIENT_SECRET_HERE";
    /**
     The OAuth redirect URI for the client @c kClientID.

     For client configuration instructions, see the [README](https://github.com/openid/AppAuth-iOS/blob/master/Examples/Example-iOS_Swift-Carthage/README.md).
    */
    let kRedirectURI: String = "OIDC_CLIENT_ID_REVERESE_HERE:/auth/callback";

    /**
     NSCoding key for the authState property.
    */
    let kAppAuthExampleAuthStateKey: String = "authState";

    @State private var authState: OIDAuthState? = nil;

    func doClientRegistration(configuration: OIDServiceConfiguration, callback: @escaping PostRegistrationCallback) {

        guard let redirectURI = URL(string: kRedirectURI) else {
            self.logMessage("Error creating URL for : \(kRedirectURI)")
            return
        }

        let request: OIDRegistrationRequest = OIDRegistrationRequest(configuration: configuration,
                                                                     redirectURIs: [redirectURI],
                                                                     responseTypes: nil,
                                                                     grantTypes: nil,
                                                                     subjectType: nil,
                                                                     tokenEndpointAuthMethod: "client_secret_post",
                                                                     additionalParameters: nil)

        // performs registration request
        self.logMessage("Initiating registration request")

        OIDAuthorizationService.perform(request) { response, error in

            if let regResponse = response {
                self.setAuthState(OIDAuthState(registrationResponse: regResponse))
                self.logMessage("Got registration response: \(regResponse)")
                callback(configuration, regResponse)
            } else {
                self.logMessage("Registration error: \(error?.localizedDescription ?? "DEFAULT_ERROR")")
                self.setAuthState(nil)
            }
        }
    }


    func doAuthWithAutoCodeExchange(configuration: OIDServiceConfiguration, clientID: String, clientSecret: String?) {

        guard let redirectURI = URL(string: kRedirectURI) else {
            self.logMessage("Error creating URL for : \(kRedirectURI)")
            return
        }

//        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
//            self.logMessage("Error accessing AppDelegate")
//            return
//        }

        // builds authentication request
        let request = OIDAuthorizationRequest(configuration: configuration,
                                              clientId: clientID,
                                              clientSecret: clientSecret,
                                              scopes: [OIDScopeOpenID, OIDScopeProfile],
                                              redirectURL: redirectURI,
                                              responseType: OIDResponseTypeCode,
                                              additionalParameters: nil)

        // performs authentication request
        self.logMessage("Initiating authorization request with scope: \(request.scope ?? "DEFAULT_SCOPE")")

        let keyWindow = NSApplication.shared.keyWindow!
        self.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: keyWindow) { authState, error in

            if let authState = authState {
                self.setAuthState(authState)
                self.logMessage("Got authorization tokens. Access token: \(authState.lastTokenResponse?.accessToken ?? "DEFAULT_TOKEN")")
            } else {
                self.logMessage("Authorization error: \(error?.localizedDescription ?? "DEFAULT_ERROR")")
                self.setAuthState(nil)
            }
        }

    }

    func setAuthState(_ authState: OIDAuthState?) {
        if (self.authState == authState) {
            return;
        }
        self.authState = authState;
        self.authState?.stateChangeDelegate = self;
        self.stateChanged()
    }

    func didChange(_ state: OIDAuthState) {
        self.stateChanged()
    }

    func stateChanged() {
        self.saveState()
        self.updateUI()
    }
    func saveState() {

        var data: Data? = nil

        if let authState = self.authState {
            data = NSKeyedArchiver.archivedData(withRootObject: authState)
        }

        if let userDefaults = UserDefaults(suiteName: "group.net.openid.appauth.Example") {
            userDefaults.set(data, forKey: kAppAuthExampleAuthStateKey)
            userDefaults.synchronize()
        }
    }
    func updateUI() {

//        self.codeExchangeButton.isEnabled = self.authState?.lastAuthorizationResponse.authorizationCode != nil && !((self.authState?.lastTokenResponse) != nil)
//
//        if let authState = self.authState {
//            self.authAutoButton.setTitle("1. Re-Auth", for: .normal)
//            self.authManual.setTitle("1(A) Re-Auth", for: .normal)
//            self.userinfoButton.isEnabled = authState.isAuthorized ? true : false
//        } else {
//            self.authAutoButton.setTitle("1. Auto", for: .normal)
//            self.authManual.setTitle("1(A) Manual", for: .normal)
//            self.userinfoButton.isEnabled = false
//        }
    }

    func loadState() {
        guard let data = UserDefaults(suiteName: "group.net.openid.appauth.Example")?.object(forKey: kAppAuthExampleAuthStateKey) as? Data else {
            return
        }

        if let authState = NSKeyedUnarchiver.unarchiveObject(with: data) as? OIDAuthState {
            self.setAuthState(authState)
        }
    }

    func logMessage(_ message: String?) {

        guard let message = message else {
            return
        }

        print(message);

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss";
        let dateString = dateFormatter.string(from: Date())

        // appends to output log
//        DispatchQueue.main.async {
//            let logText = "\(self.logTextView.text ?? "")\n\(dateString): \(message)"
//            self.logTextView.text = logText
//        }
        Logger.shared.log(message: message)
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
      // Register for GetURL events.
      let appleEventManager = NSAppleEventManager.shared()
      appleEventManager.setEventHandler(
        self,
        andSelector: "handleGetURLEvent:replyEvent:",
        forEventClass: AEEventClass(kInternetEventClass),
        andEventID: AEEventID(kAEGetURL)
      )
      self.loadState()
      self.updateUI()


        guard let issuer = URL(string: kIssuer) else {
            self.logMessage("Error creating URL for : \(kIssuer)")
            return
        }

        self.logMessage("Fetching configuration for issuer: \(issuer)")

        // discovers endpoints
        OIDAuthorizationService.discoverConfiguration(forIssuer: issuer) { configuration, error in

            guard let config = configuration else {
                self.logMessage("Error retrieving discovery document: \(error?.localizedDescription ?? "DEFAULT_ERROR")")
                self.setAuthState(nil)
                return
            }

            self.logMessage("Got configuration: \(config)")

            if let clientId = self.kClientID {
                self.doAuthWithAutoCodeExchange(configuration: config, clientID: clientId, clientSecret: self.kClientSecret!)
            } else {
                self.doClientRegistration(configuration: config) { configuration, response in

                    guard let configuration = configuration, let clientID = response?.clientID else {
                        self.logMessage("Error retrieving configuration OR clientID")
                        return
                    }

                    self.doAuthWithAutoCodeExchange(configuration: configuration,
                                                    clientID: clientID,
                                                    clientSecret: response?.clientSecret)
                }
            }
        }





    }

    func handleGetURLEvent(event: NSAppleEventDescriptor?, replyEvent: NSAppleEventDescriptor?) {
        if let urlString =
          event?.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue{
            let url = URL(string: urlString)!
            if let authorizationFlow = self.currentAuthorizationFlow, authorizationFlow.resumeExternalUserAgentFlow(with: url) {
                self.currentAuthorizationFlow = nil
            }
        }
    }

}

