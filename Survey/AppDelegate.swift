import AppAuth
import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate, OIDAuthStateChangeDelegate {
    static private(set) var instance: AppDelegate! = nil
    let kIssuer: String = "SURVEY_OSX_OIDC_ISSUER_HERE"
    let kClientID: String? = "SURVEY_OSX_OIDC_CLIENT_ID_HERE"
    let kClientSecret: String? = "SURVEY_OSX_OIDC_CLIENT_SECRET_HERE"
    let kRedirectURI: String = "SURVEY_OSX_OIDC_REDIRECT_URI_HERE"
    let kAppAuthStateKey: String = "authState"
    let kSuiteName = "com.incredihire.osx.Survey7"
    var authState: OIDAuthState? = nil
    var currentAuthorizationFlow: OIDExternalUserAgentSession?

    func doAuthWithAutoCodeExchange(configuration: OIDServiceConfiguration, clientID: String, clientSecret: String?) {
        guard let redirectURI = URL(string: kRedirectURI) else {
            self.logMessage("Error creating URL for : \(kRedirectURI)")
            return
        }
        let request = OIDAuthorizationRequest(configuration: configuration,
                                              clientId: clientID,
                                              clientSecret: clientSecret,
                                              scopes: [OIDScopeOpenID, OIDScopeEmail, OIDScopeProfile],
                                              redirectURL: redirectURI,
                                              responseType: OIDResponseTypeCode,
                                              additionalParameters: nil)
        let keyWindow = NSApplication.shared.keyWindow!
        self.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: keyWindow) { authState, error in
            if let authState = authState {
                self.setAuthState(authState)
            } else {
                self.logMessage("Authorization error: \(error?.localizedDescription ?? "DEFAULT_ERROR")")
                self.setAuthState(nil)
            }
        }
    }

    func setAuthState(_ authState: OIDAuthState?) {
        if (self.authState == authState) {
            return
        }
        self.authState = authState
        self.authState?.stateChangeDelegate = self
        self.stateChanged()
    }

    func didChange(_ state: OIDAuthState) {
        self.stateChanged()
    }

    func stateChanged() {
        self.saveState()
    }

    func saveState() {
        var data: Data? = nil
        if let authState = self.authState {
            do {
                data = try NSKeyedArchiver.archivedData(withRootObject: authState, requiringSecureCoding: true)
            } catch {
                fatalError("Could not archive authState data: \(error)")
            }
        }

        if let userDefaults = UserDefaults(suiteName: kSuiteName) {
            userDefaults.set(data, forKey: kAppAuthStateKey)
            userDefaults.synchronize()
        }
    }

    func loadState() {
        guard let data = UserDefaults(suiteName: kSuiteName)?.object(forKey: kAppAuthStateKey) as? Data else {
            return
        }
        do {
            if let authState = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [OIDAuthState.self], from: data) as? OIDAuthState {
                self.setAuthState(authState)
            }
        } catch {
            fatalError("Could not unarchive authState data: \(error)")
        }
    }

    func logMessage(_ message: String?) {
        guard let message = message else {
            return
        }
        Logger.shared.log(message: message)
    }

    func applicationWillFinishLaunching(_ notification: Notification) {
        AppDelegate.instance = self
        let appleEventManager = NSAppleEventManager.shared()
        appleEventManager.setEventHandler(
            self,
            andSelector: #selector(AppDelegate.self.handleGetURLEvent(event:replyEvent:)),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )
        self.loadState()
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        if(authState == nil) {
            // initial auth request
            guard let issuer = URL(string: kIssuer) else {
               self.logMessage("Error creating URL for : \(kIssuer)")
               return
            }
            OIDAuthorizationService.discoverConfiguration(forIssuer: issuer) { configuration, error in
               guard let config = configuration else {
                   self.logMessage("Error retrieving discovery document: \(error?.localizedDescription ?? "DEFAULT_ERROR")")
                   self.setAuthState(nil)
                   return
               }
               if let clientId = self.kClientID {
                   self.doAuthWithAutoCodeExchange(configuration: config, clientID: clientId, clientSecret: self.kClientSecret)
               }
            }
        }
    }

    @objc func handleGetURLEvent(event: NSAppleEventDescriptor?, replyEvent: NSAppleEventDescriptor?) {
        if let urlString =
          event?.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue{
            let url = URL(string: urlString)!
            if let authorizationFlow = self.currentAuthorizationFlow, authorizationFlow.resumeExternalUserAgentFlow(with: url) {
                self.currentAuthorizationFlow = nil
            }
        }
    }
    
    func refreshTokens() {
        if let authState = self.authState {
            let currentAccessToken: String? = authState.lastTokenResponse?.accessToken
            let currentIdToken: String? = authState.lastTokenResponse?.idToken
            authState.performAction() { (accessToken, idToken, error) in
                if error != nil  {
                    self.logMessage("Error fetching fresh tokens: \(error?.localizedDescription ?? "ERROR")")
                    return
                }
                guard let accessToken = accessToken else {
                    self.logMessage("Error getting accessToken")
                    return
                }

                if currentAccessToken != accessToken {
                    self.logMessage("Access token was refreshed automatically")
                } else {
                    self.logMessage("Access token was fresh and not updated")
                }

                guard let idToken = idToken else {
                    self.logMessage("Error getting idToken")
                    return
                }
                if currentIdToken != idToken {
                    self.logMessage("ID token was refreshed automatically")
                } else {
                    self.logMessage("ID token was fresh and not updated")
                }
           }
        }
    }
}

