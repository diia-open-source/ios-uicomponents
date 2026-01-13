
import UIKit
import DiiaCommonTypes

public struct DSSearchModel: Codable {
    public let componentId: String?
    public let label : String
    public let iconLeft: DSIconModel?
    public let iconRight: DSIconModel?
}

public final class DSSearchInputView: BaseCodeView {
    
    private var searchTextField = UITextField()
    private var clearSearchButton = UIButton()
    private var searchIcon = UIImageView(image: R.image.search_black.image, contentMode: .scaleAspectFit)
    private var clearCallback: Callback?
    private var textChangeCallback: Callback?
    private var isActive: Bool = true {
        willSet {
            searchIcon.image = newValue ? R.image.search_black.image : R.image.search_light.image
        }
    }
    private var customPlaceholder = ""
    
    public var searchText: String? {
        get {
            return searchTextField.text
        }
    }
    
    public override func setupSubviews() {
        let stack = hstack(searchIcon,
                           searchTextField,
                           clearSearchButton,
                           spacing: Constants.viewSpacing,
                           padding: Constants.viewPadding)
        stack.withHeight(Constants.viewHeight)
        searchIcon.withSize(Constants.iconSize)
        clearSearchButton.withSize(Constants.buttonSize)
        stack.backgroundColor = .clear
        setupUI()
        setupAccessibility()
    }
    
    private func setupUI() {
        layer.cornerRadius = Constants.cornerRadius
        backgroundColor = .white

        searchTextField.returnKeyType = .search
        searchTextField.textColor = .black
        searchTextField.tintColor = .black
        searchTextField.autocorrectionType = .no
        
        searchTextField.placeholder = nil
        searchTextField.font = FontBook.usualFont
        
        clearSearchButton.isHidden = true
        clearSearchButton.setImage(R.image.closeRectangle.image, for: .normal)
        clearSearchButton.addTarget(self, action: #selector(clearSearchAction), for: .touchUpInside)
        
        searchTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        searchTextField.addTarget(self, action: #selector(editingEnded), for: .editingDidEnd)
        searchTextField.addTarget(self, action: #selector(editingBegin), for: .editingDidBegin)
    }
    
    private func setupAccessibility() {
        clearSearchButton.isAccessibilityElement = true
        clearSearchButton.accessibilityTraits = .button
        clearSearchButton.accessibilityLabel = R.Strings.general_accessibility_text_field_clear_button.localized()
    }
    
    public func setup(placeholder: String,
                      font: UIFont = FontBook.usualFont,
                      delegate: UITextFieldDelegate? = nil,
                      isActive: Bool = true,
                      closeCallback: Callback? = nil,
                      textChangeCallback: Callback? = nil) {
        self.searchTextField.attributedPlaceholder = placeholder.attributed(font: font, color: .black540)
        self.searchTextField.delegate = self
        self.searchTextField.font = font
        self.isActive = isActive
        self.clearCallback = closeCallback
        self.textChangeCallback = textChangeCallback
        customPlaceholder = placeholder
    }
    
    public func toggleSearch(active: Bool) {
        if active {
            searchTextField.becomeFirstResponder()
        } else {
            searchTextField.resignFirstResponder()
        }
    }
    
    @objc private func clearSearchAction(_ sender: UIButton) {
        searchTextField.text = nil
        textChanged()
        clearCallback?()
    }
    
    @objc private func editingEnded() {
        self.isActive = false
        updateSearchView()
    }
    
    @objc private func editingBegin() {
        self.isActive = true
        updateSearchView()
    }
    
    @objc private func textChanged() {
        updateSearchView()
        textChangeCallback?()
    }
    
    private func updateSearchView() {
        let isAnyText = searchText?.isEmpty == true
        clearSearchButton.isHidden = isAnyText
    }
}

extension DSSearchInputView: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        superview?.endEditing(false)
        return true
    }
}

extension DSSearchInputView {
    enum Constants {
        static let animationDuration: CGFloat = 0.1
        static let placeholderActiveEdge: CGFloat = 16
        static let placeholderDefaultEdge: CGFloat = 0
        static let viewPadding = UIEdgeInsets.init(top: 8, left: 12, bottom: 8, right: 8)
        static let viewSpacing: CGFloat = 8
        static let viewHeight: CGFloat = 24
        static let cornerRadius: CGFloat = 16
        static let buttonSize = CGSize(width: 24, height: 24)
        static let iconSize = CGSize(width: 24, height: 24)
    }
}
