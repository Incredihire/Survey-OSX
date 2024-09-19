import Foundation
import Security

class AuthViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""

    var isLoggedIn: Bool {
        return loadCredentials() != nil
    }

    func login(completion: @escaping (Bool) -> Void) {
        if username == "user" && password == "password" {
            saveCredentials(username: username, password: password)
            completion(true)
        } else {
            completion(false)
        }
    }

    func logout() {
        deleteCredentials()
    }

    private func saveCredentials(username: String, password: String) {
        guard let passwordData = password.data(using: .utf8) else { return }
        
        let credentials: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecValueData as String: passwordData
        ]

        // Delete any existing credentials
        SecItemDelete(credentials as CFDictionary)

        // Add new credentials
        SecItemAdd(credentials as CFDictionary, nil)
    }

    private func loadCredentials() -> (username: String, password: String)? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess {
            if let data = dataTypeRef as? Data,
               let password = String(data: data, encoding: .utf8) {
                return (username: username, password: password)
            }
        }
        return nil
    }

    private func deleteCredentials() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username
        ]

        SecItemDelete(query as CFDictionary)
    }
}
