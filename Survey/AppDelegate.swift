import AppAuth
import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate, OIDAuthStateChangeDelegate {
    static private(set) var instance: AppDelegate! = nil
    let kAppAuthStateKey: String = "authState"
    let kSuiteName = "com.incredihire.osx.Survey"
    var authState: OIDAuthState? = nil
    var currentAuthorizationFlow: OIDExternalUserAgentSession?
    private var applicationDidBecomeActiveCalled = false

    private func getOIDConfig() -> OIDServiceConfiguration? {
        let issuer = URL(string: ProcessInfo.processInfo.environment["OIDC_ISSUER"]!)!
        let authorizationEndpoint = URL(string: ProcessInfo.processInfo.environment["OIDC_AUTHORIZATION_ENDPOINT"]!)!
        let tokenEndpoint = URL(string: "\(ProcessInfo.processInfo.environment["API_SERVER_BASE_URL"]!)/api/v1/auth/token/desktop")!
        return OIDServiceConfiguration(authorizationEndpoint: authorizationEndpoint, tokenEndpoint: tokenEndpoint, issuer: issuer)
    }

    func doAuth() {
        let request = OIDAuthorizationRequest(configuration: self.getOIDConfig()!,
                                                    clientId: ProcessInfo.processInfo.environment["OIDC_CLIENT_ID"]!,
                                                    clientSecret: nil,
                                                    scopes: [OIDScopeOpenID, OIDScopeProfile, OIDScopeEmail],
                                                    redirectURL: URL(string: ProcessInfo.processInfo.environment["OIDC_REDIRECT_URL"]!)!,
                                                    responseType: OIDResponseTypeCode,
                                                    additionalParameters: nil)
        self.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: NSApplication.shared.keyWindow!) { authState, error in
            if let authState = authState {
                self.setAuthState(authState)
            } else {
                self.logMessage("Authorization error: \(error?.localizedDescription ?? "DEFAULT_ERROR")")
                self.setAuthState(nil)
            }
        }
    }

    func setAuthState(_ authState: OIDAuthState?) {
        if self.authState == authState {
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
        var data: Data?
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

    func applicationDidBecomeActive(_ notification: Notification) {
        if applicationDidBecomeActiveCalled {
            return
        }
        applicationDidBecomeActiveCalled = true
        if(authState == nil) {
            self.doAuth()
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
}

