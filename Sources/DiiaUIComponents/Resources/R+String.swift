import Foundation

enum R {
    enum Strings: String, CaseIterable {
        // MARK: - Accessibility
        case general_accessibility_back_button_hint
        case general_accessibility_page_hint
        
        // MARK: - General
        case general_ok
        case general_back
        case general_context_menu_open
        case general_done
        case general_step
        case general_loading
        case general_retry
        case general_close
        case general_number_copied
        case general_date_picker_hint
        case general_time_picker_hint
        case general_update
        
        // MARK: - File upload
        case file_failed_to_upload
        case file_file_too_large
        case media_upload_error
        
        // MARK: - ToolBar
        case toolbar_done

        // MARK: - Pagination
        case pagination_error_text
        
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
