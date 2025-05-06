
import UIKit
import DiiaCommonTypes

public struct DSScalingTitleMlc: Codable {
    public let componentId: String?
    public let label: String
    
    public init(componentId: String?, label: String) {
        self.componentId = componentId
        self.label = label
    }
}

/// design_system_code: scalingTitleMlc
public class DSScalingTitleView: BaseCodeView {
    
    private let smallTitle = UILabel().withParameters(font: FontBook.mainFont.regular.size(18), numberOfLines: Constants.smallTitleNumberOfLines)
    private let titleLabel = UILabel().withParameters(font: FontBook.mainFont.regular.size(21))
    private var titleBottom: NSLayoutConstraint?

    private var isExpanded = true
    
    override public func setupSubviews() {
        addSubviews([smallTitle, titleLabel])
        smallTitle.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor)
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor)
        
        titleBottom = titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        titleBottom?.isActive = true
        smallTitle.alpha = 0
    }
    
    // MARK: - Setup
    public func configure(label: String) {
        titleLabel.text = label
        smallTitle.text = label
    }
    
    public func configure(data: DSScalingTitleMlc) {
        self.accessibilityIdentifier = data.componentId
        configure(label: data.label)
    }
    
    // MARK: - Private
    private func setIsExpanded(_ isExpanded: Bool) {
        guard isExpanded != self.isExpanded else { return }
        self.isExpanded = isExpanded
        self.titleBottom?.isActive = false
        self.titleBottom = (isExpanded ? titleLabel : smallTitle).bottomAnchor.constraint(equalTo: bottomAnchor)
        self.titleBottom?.isActive = true
        UIView.animate(withDuration: Constants.animationDuration, animations: {
            self.titleLabel.alpha = isExpanded ? 1 : 0
            self.smallTitle.alpha = isExpanded ? 0 : 1
            self.layoutIfNeeded()
        })
    }
}

extension DSScalingTitleView: ScrollDependentComponentProtocol {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        setIsExpanded(scrollView.contentOffset.y <= Constants.scrollContentOffset)
    }
}

extension DSScalingTitleView {
    private enum Constants {
        static let animationDuration: CGFloat = 0.3
        static let smallTitleNumberOfLines: Int = 2
        static let scrollContentOffset: CGFloat = 10
        static let closeButtonSize = CGSize(width: 24, height: 24)
        static let closeButtonPadding = UIEdgeInsets(top: .zero, left: 16, bottom: .zero, right: .zero)
    }
}

extension AnchoredConstraints {
    func changeState(isActive: Bool) {
        [top, leading, bottom, trailing, width, height].forEach { $0?.isActive = isActive }
    }
}
