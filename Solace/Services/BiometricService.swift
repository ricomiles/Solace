import LocalAuthentication
import os.log

actor BiometricService {
    static let shared = BiometricService()

    private init() {}

    func canUseBiometrics() -> Bool {
        var error: NSError?
        return LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }

    func authenticate() async -> Bool {
        let context = LAContext()
        var error: NSError?

        // Try biometrics first
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            do {
                return try await context.evaluatePolicy(
                    .deviceOwnerAuthenticationWithBiometrics,
                    localizedReason: "Unlock your journal."
                )
            } catch let laError as LAError where laError.code == .userCancel {
                return false
            } catch {
                // Fall through to passcode
            }
        }

        // Fallback to passcode
        let passcodeContext = LAContext()
        if passcodeContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
            do {
                return try await passcodeContext.evaluatePolicy(
                    .deviceOwnerAuthentication,
                    localizedReason: "Unlock your journal."
                )
            } catch {
                os_log("Biometric/passcode auth failed: %{public}@", log: .default, type: .debug, error.localizedDescription)
                return false
            }
        }

        // No authentication available — unlock
        return true
    }
}
