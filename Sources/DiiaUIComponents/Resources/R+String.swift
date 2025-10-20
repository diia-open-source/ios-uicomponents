import Foundation

enum R {
    enum Strings: String, CaseIterable {
        // MARK: - Accessibility
        case general_accessibility_back_button_hint
        case general_accessibility_loading_hint
        case made_in_ua_cashback_dashboard_amount
        case recruitment_accessibility_video_play_button
        case general_accessibility_accordion_opened
        case general_accessibility_accordion_closed
        case general_accessibility_copy_button
        case document_accessibility_doc_photo
        case document_accessibility_signature_photo
        
        case accessibility_photo_url
        case general_accessibility_filters_applied
        case general_accessibility_text_field_clear_button
        
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
