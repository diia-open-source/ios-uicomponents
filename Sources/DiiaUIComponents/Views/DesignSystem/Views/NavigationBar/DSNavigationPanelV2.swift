
import UIKit
import DiiaCommonTypes

public struct DSNavigationPanelV2: Codable {
    public let componentId: String?
    public let title: String
    public let iconLeft: DSIconModel
    public let isClosed: Bool?
    
    public init(componentId: String?, title: String, iconLeft: DSIconModel, isClosed: Bool?) {
        self.componentId = componentId
        self.title = title
        self.iconLeft = iconLeft
        self.isClosed = isClosed
    }
}

/// design_system_code: navigationPanelMlcV2
public class DSNavigationPanelV2View: BaseCodeView {
    private let smallTitle = UILabel().withParameters(font: FontBook.mainFont.regular.size(18), numberOfLines: Constants.smallTitleNumberOfLines, textAlignment: .center, lineBreakMode: .byTruncatingTail)
    private let backButton = ActionButton(type: .icon)
    private var isClosed = false
    
    override public func setupSubviews() {
        addSubviews([smallTitle, backButton])
        backButton.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, size: Constants.closeButtonSize)
        smallTitle.anchor(leading: backButton.trailingAnchor, padding: .init(top: 0, left: Constants.leftPadiing, bottom: 0, right: 0))
        smallTitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        smallTitle.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        smallTitle.alpha = 0
        
        backButton.iconRenderingMode = .alwaysOriginal
    }
    
    // MARK: - Setup
    public func configure(data: DSNavigationPanelV2, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.accessibilityIdentifier = data.componentId
        smallTitle.text = data.title
        let imageProvider = UIComponentsConfiguration.shared.imageProvider
        backButton.action = .init(
            image: imageProvider?.imageForCode(imageCode: data.iconLeft.code),
            callback: {
                eventHandler(.action(data.iconLeft.action ?? .init(type: "Back")))
        })
        if data.isClosed == true {
            self.isClosed = true
            smallTitle.alpha = 1
        }
    }
    
    // MARK: - Private
    private func updateOffset(_ offset: CGFloat, in scrollView: UIScrollView) {
        if isClosed { return }
        guard let firstStackView = (scrollView.subviews.first as? UIStackView)?.arrangedSubviews.first else { return }
        let titleFullHeight = firstStackView.frame.height
        updateExpanded(offset < titleFullHeight)
    }
    
    private func updateExpanded(_ isExpanded: Bool) {
        if smallTitle.alpha == (isExpanded ? 0 : 1) { return }
        UIView.animate(withDuration: Constants.animationDuration, animations: {
            self.smallTitle.alpha = isExpanded ? 0 : 1
        })
    }
    
}

extension DSNavigationPanelV2View: ScrollDependentComponentProtocol {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset
        updateOffset(contentOffset.y, in: scrollView)
    }
}

extension DSNavigationPanelV2View {
    private enum Constants {
        static let animationDuration: CGFloat = 0.4
        static let smallTitleNumberOfLines: Int = 1
        static let scrollContentOffset: CGFloat = 10
        static let leftPadiing: CGFloat = 8
        static let bigTitleInset: CGFloat = 24
        static let closeButtonSize = CGSize(width: 28, height: 28)
    }
}
