import Foundation

enum R {
    enum Strings: String, CaseIterable {
        // MARK: - Accessibility
        case general_accessibility_back_button_hint
        
        // MARK: - General
        case general_ok
        case general_done
        case general_step
        case general_loading
        case general_retry
        case general_close
        case general_number_copied
        
        func localized() -> String {
            let localized = NSLocalizedString(rawValue, bundle: Bundle.module, comment: "")
            return localized
        }
        
        func formattedLocalized(arguments: CVarArg...) -> String {
            let localized = NSLocalizedString(rawValue, bundle: Bundle.module, comment: "")
            return String(format: localized, arguments)
        }
    }
}
