import UIKit

public enum ChecklistType {
    case single(checkboxStyle: CheckboxStyle)
    case multiple(checkboxStyle: CheckboxStyle)
    
    var checkboxStyle: CheckboxStyle {
        switch self {
        case .single(let checkboxStyle), .multiple(let checkboxStyle):
            return checkboxStyle
        }
    }
}

public enum CheckboxStyle {
    case checkbox
    case radioButton
    case radioCheckmark
    
    public var selectedImage: UIImage? {
        switch self {
        case .checkbox:
            return R.image.checkbox_enabled.image
        case .radioButton:
            return R.image.radioCheckbox.image
        case .radioCheckmark:
            return R.image.filledCheckbox.image
        }
    }
    
    public var disabledImage: UIImage? {
        switch self {
        case .checkbox:
            return R.image.checkbox_disabled.image
        case .radioButton, .radioCheckmark:
            return R.image.emptyChecboxBlack.image
        }
    }
    
    public var disableSelectedImage: UIImage? {
        switch self {
        case .checkbox:
            return R.image.checkboxSquarePartiallySelected.image
        case .radioButton:
            return R.image.radioBtnSelectedDisable.image
        case .radioCheckmark:
            return R.image.checkBoxSelectedDisable.image
        }
    }
}
