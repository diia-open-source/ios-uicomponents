
import UIKit

/// design_system_code: accordionOrg
final public class DSAccordionOrgView: BaseCodeView {
    private enum State {
        case collapsed
        case expanded
    }

    private let titleLabel = UILabel().withParameters(
        font: FontBook.bigText
    )

    private let descriptionLabel = UILabel().withParameters(
        font: FontBook.usualFont,
        textColor: Constants.descriptionTextColor
    )
    
    private let descriptionIcon = UIImageView().withSize(Constants.iconSize)

    private let headingHStack = UIStackView.create(
        .horizontal,
        spacing: Constants.spacing,
        alignment: .center,
        distribution: .fillProportionally
    )
    
    private let descriptionStack = UIStackView.create(
        .horizontal,
        spacing: Constants.smallSpacing,
        alignment: .center)

    private let collapsableContentVStack = UIStackView.create(
        .vertical,
        spacing: Constants.spacing
    )

    private let accordionIcon = UIImageView().withSize(Constants.iconSize)

    private var viewFabric = DSViewFabric.instance
    private var state: State = .collapsed
    private var model: DSAccordionOrgModel?

    // MARK: - Lifecycle
    override public func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        accordionIcon.contentMode = .scaleAspectFill
        descriptionIcon.contentMode = .scaleAspectFit

        [titleLabel, descriptionLabel].forEach {
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
        
        let headingVLabelsVStack = UIStackView.create(
            views: [titleLabel, descriptionStack],
            spacing: Constants.spacing)
        
        let mainVStack = UIStackView.create(
            views: [headingHStack, collapsableContentVStack],
            spacing: Constants.mainSpacing)
        
        addSubview(mainVStack)
        
        mainVStack.fillSuperview(padding: Constants.mainPadding)
        headingHStack.addArrangedSubviews([headingVLabelsVStack, accordionIcon])
        descriptionStack.addArrangedSubviews([descriptionIcon, descriptionLabel])
        
        addTapGestureRecognizer()
    }

    // MARK: - Public Methods
    public func configure(with model: DSAccordionOrgModel, eventHandler: @escaping ((ConstructorItemEvent) -> Void)) {
        self.model = model

        titleLabel.text = model.heading

        descriptionLabel.isHidden = model.description == nil
        descriptionLabel.text = model.description
        
        descriptionIcon.isHidden = model.descriptionIcon == nil
        
        if let descriptionIconModel = model.descriptionIcon {
            let imageProvider = UIComponentsConfiguration.shared.imageProvider
            descriptionIcon.image = imageProvider.imageForCode(imageCode: descriptionIconModel.code)
            descriptionIcon.accessibilityIdentifier = descriptionIconModel.componentId
            descriptionIcon.accessibilityLabel = descriptionIconModel.accessibilityDescription
        }
        
        descriptionStack.isHidden = descriptionIcon.isHidden && descriptionIcon.isHidden

        let isExpanded = model.states.isExpanded ?? false
        setState(isExpanded ? .expanded : .collapsed, animated: false)
        
        collapsableContentVStack.safelyRemoveArrangedSubviews()
        guard let expandedContent = model.expandedContent else { return }
        let itemsModels = expandedContent.items
        for (index, model) in itemsModels.enumerated() {
            guard let view = viewFabric.makeView(
                from: model,
                withPadding: .fixed(paddings: .zero),
                eventHandler: eventHandler
            ) else {
                continue
            }
            collapsableContentVStack.addArrangedSubview(view)
            if expandedContent.showDivider == true && index < (itemsModels.count - 1) {
                collapsableContentVStack.addArrangedSubview(divider())
            }
        }
    }

    public func setFabric(_ viewFabric: DSViewFabric) {
        self.viewFabric = viewFabric
    }

    // MARK: - Private Methods
    private func setState(_ state: State, animated: Bool) {
        self.state = state

        let code: String?

        switch state {
        case .collapsed:
            code = model?.states.collapsedIcon?.code
        case .expanded:
            code = model?.states.expandedIcon?.code
        }

        accordionIcon.image = UIComponentsConfiguration
            .shared
            .imageProvider
            .imageForCode(imageCode: code)

        let closure = { [weak self] in
            let isOpened = state == .expanded

            self?.collapsableContentVStack.isHidden = !isOpened
            self?.collapsableContentVStack.alpha = isOpened ? 1.0 : 0.0
            self?.layoutIfNeeded()
        }

        if animated {
            UIView.animate(withDuration: Constants.animationDuration, animations: closure)
        } else {
            closure()
        }
    }
    
    private func divider() -> UIView {
        let view = UIView().withHeight(1)
        view.backgroundColor = Constants.separatorColor
        return view
        
    }
    
    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        headingHStack.addGestureRecognizer(tap)
    }

    // MARK: - Actions
    @objc private func onClick() {
        setState(
            state == .collapsed ? .expanded : .collapsed,
            animated: true
        )
    }
}

// MARK: - DSAccordionOrgView+Constants
private extension DSAccordionOrgView {
    enum Constants {
        static let mainPadding = UIEdgeInsets(top: 16.0, left: 0.0, bottom: 8.0, right: 0.0)
        static let iconSize = CGSize(width: 24.0, height: 24.0)
        static let animationDuration: TimeInterval = 0.3
        static let descriptionTextColor: UIColor = .black.withAlphaComponent(0.6)
        static let mainSpacing: CGFloat = 16
        static let spacing: CGFloat = 8
        static let smallSpacing: CGFloat = 4
        static let separatorColor = UIColor("#E2ECF4")
    }
}
