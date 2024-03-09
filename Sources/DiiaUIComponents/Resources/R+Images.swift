import UIKit

extension R {
    enum image: String, CaseIterable {
        // MARK: - General
        case clear
        case loadingBar
        case buttonContainer
        case gradienCircle
        case checkbox_disabled
        case checkbox_enabled
        case roundButton_disabled
        case penaltyGradient
        case filledCheckbox
        case emptyChecboxBlack
        case gradientCircleWithInsets
        case expand_plus
        case receiptsLoading
        case expand_minus
        case radioCheckbox
        case checkmarkIcon
        case forwardWhite
        case calendar
        case insuranceBar
        case checkboxUnchecked
        case checkboxChecked
        case checkboxCheckedBlack
        case backArrow = "back-arrow"
        case menu_back
        case search_black
        case search_light
        case close
        case closeRectangle
        case loading
        case pause
        case play
        case playbackSliderThumb
        
        var image: UIImage? {
            return UIImage(named: rawValue, in: Bundle.module, compatibleWith: nil)
        }
        
        var name: String {
            return rawValue
        }
    }
}
