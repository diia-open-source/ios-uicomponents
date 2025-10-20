
import Foundation
import UIKit
import DiiaCommonTypes

public struct DSTableBlockAccordionModel: Codable {
    public let componentId: String?
    public let heading: String
    public let isOpen: Bool
    public let items: [AnyCodable]
}

/// design_system_code: tableBlockAccordionOrg
public class DSTableBlockAccordionView: BaseCodeView {
    private enum DSTableBlockAccordeonViewState {
        case opened
        case closed
    }
    
    private let accordionIcon = UIImageView()
    private let headingLabel = UILabel().withParameters(font: FontBook.smallHeadingFont)
    private let mainStack =  UIStackView.create(.vertical, spacing: Constants.stackSpacing).withMargins(Constants.mainStackInsets)
    private let itemsStack = UIStackView.create(.vertical, spacing: Constants.stackSpacing)
    private let headingStack = UIStackView.create(.horizontal, spacing: Constants.stackSpacing, alignment: .center)
    private var isOpened = false

    private var viewFabric = DSViewFabric.instance
    
    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.layer.cornerRadius = Constants.cornerRadius
        addSubview(mainStack)
        mainStack.fillSuperview()
        
        headingLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        headingLabel.numberOfLines = 0
        headingStack.addArrangedSubview(headingLabel)
        
        accordionIcon.contentMode = .scaleAspectFit
        accordionIcon.withSize(Constants.accordeonIconSize)
        headingStack.addArrangedSubview(accordionIcon)
        mainStack.addArrangedSubview(headingStack)
        mainStack.addArrangedSubview(itemsStack)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapped))
        headingStack.addGestureRecognizer(gesture)
        headingStack.isUserInteractionEnabled = true
        
        setupAccessibility()
    }
    
    public func configure(with model: DSTableBlockAccordionModel, eventHandler: @escaping ((ConstructorItemEvent) -> Void)) {
        itemsStack.safelyRemoveArrangedSubviews()
        
        headingLabel.text = model.heading
        headingStack.accessibilityLabel = model.heading
        self.isOpened = model.isOpen
        setState(isOpened ? .opened : .closed, animated: false)
        
        model.items.forEach { item in
            if let view = viewFabric.makeView(from: item, withPadding: .fixed(paddings: .zero), eventHandler: eventHandler) {
                itemsStack.addArrangedSubview(view)
            }
        }
    }
    
    private func setState(_ state: DSTableBlockAccordeonViewState, animated: Bool) {
        switch state {
        case .opened:
            accordionIcon.image = R.image.expand_minus.image
            headingStack.accessibilityValue = R.Strings.general_accessibility_accordion_opened.localized()
        case .closed:
            accordionIcon.image = R.image.expand_plus.image
            headingStack.accessibilityValue = R.Strings.general_accessibility_accordion_closed.localized()
        }
        
        let closure = { [weak self] in
            let isOpened = state == .opened

            self?.itemsStack.isHidden = !isOpened
            self?.itemsStack.alpha = isOpened ? 1.0 : 0.0
            self?.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: Constants.animationDuration, animations: closure)
        } else {
            closure()
        }
    }
    
    @objc private func onTapped() {
        isOpened.toggle()
        setState(isOpened ? .opened : .closed, animated: true)
    }
    
    public func setFabric(_ viewFabric: DSViewFabric) {
        self.viewFabric = viewFabric
    }
    
    // MARK: - Accessibility
    private func setupAccessibility() {
        headingStack.isAccessibilityElement = true
        headingStack.accessibilityTraits = .button
    }
}

extension DSTableBlockAccordionView {
    private enum Constants {
        static let cornerRadius = CGFloat(16)
        static let mainStackInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let accordeonIconSize = CGSize(width: 24, height: 24)
        static let stackSpacing = CGFloat(16)
        static let animationDuration: TimeInterval = 0.3
    }
}
