
import Foundation
import UIKit

/// design_system_code: dashboardCardMlc

public class DSDashboardCardMlcViewModel {
    public let dashboardCardMlc: DSDashboardCardMlc
    public let eventHandler: ((ConstructorItemEvent) -> ())?
    
    init(dashboardCardMlc: DSDashboardCardMlc,
         eventHandler: ((ConstructorItemEvent) -> ())?) {
        self.dashboardCardMlc = dashboardCardMlc
        self.eventHandler = eventHandler
    }
}

public class DSDashboardCardMlcView: BaseCodeView {
    private var icon = UIImageView()
    private let label = UILabel().withParameters(font: FontBook.statusFont)
    private let amountLabel = UILabel().withParameters(font: FontBook.cardsHeadingFont)
    private let amountSmallLabel = UILabel().withParameters(font: FontBook.emptyStateTitleFont)
    private let descriptionLabel = UILabel().withParameters(font: FontBook.usualFont,
                                                            textColor: UIColor.black.withAlphaComponent(0.5))
    private let button = ActionButton()
    private var emptyIcon = UIImageView()
    private let emptyDescription = UILabel().withParameters(font: FontBook.usualFont)
    
    private let labelStack = UIStackView.create(.horizontal, spacing: Constants.smallPadding, alignment: .center)
    private let amountView = UIView()
    private let fullViewStack = UIStackView.create(spacing: Constants.smallPadding, alignment: .top, distribution: .equalSpacing)
    private let emptyStack = UIStackView.create(spacing: Constants.padding, alignment: .center)
    
    private var imageProvider: DSImageNameProvider? = UIComponentsConfiguration.shared.imageProvider
    private var viewModel: DSDashboardCardMlcViewModel?
    
    public override func setupSubviews() {
        super.setupSubviews()
        layer.cornerRadius = Constants.cornerRadius
        translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.withHeight(Constants.buttonHeight)
        emptyDescription.textAlignment = .center
        icon.withSize(Constants.imageSize)
        labelStack.addArrangedSubviews([icon, label])
        amountView.addSubview(amountLabel)
        amountView.addSubview(amountSmallLabel)
        fullViewStack.addArrangedSubviews([labelStack, amountView, descriptionLabel, button])
        emptyStack.addArrangedSubviews([emptyIcon, emptyDescription])
        
        button.type = .text
        button.setupUI(font: FontBook.statusFont,
                       cornerRadius: Constants.buttonRadius,
                       bordered: false,
                       textColor: .black,
                       secondaryColor: Constants.buttonColor,
                       contentHorizontalAlignment: .center)
        button.contentEdgeInsets = Constants.buttonTitleEdgeInsets
        
        addSubview(fullViewStack)
        
        fullViewStack.fillSuperview(padding: .allSides(Constants.padding))
        
        amountView.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountSmallLabel.translatesAutoresizingMaskIntoConstraints = false
        
        amountView.heightAnchor.constraint(equalToConstant: Constants.lineHeight).isActive = true
        amountLabel.leadingAnchor.constraint(equalTo: amountView.leadingAnchor).isActive = true
        amountSmallLabel.leadingAnchor.constraint(equalTo: amountLabel.trailingAnchor).isActive = true
        amountLabel.heightAnchor.constraint(equalTo: amountView.heightAnchor).isActive = true
        amountSmallLabel.bottomAnchor.constraint(equalTo: amountLabel.bottomAnchor).isActive = true
        
        emptyIcon.withSize(Constants.emptyImageSize)
        button.withHeight(Constants.buttonHeight)
        
        addSubview(emptyStack)
        emptyStack.translatesAutoresizingMaskIntoConstraints = false
        emptyStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        emptyStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding).isActive = true
        emptyStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding).isActive = true
        
        fullViewStack.isHidden = true
        emptyStack.isHidden = true
    }
    
    public func configure(with viewModel: DSDashboardCardMlcViewModel) {
        self.viewModel = viewModel
        accessibilityIdentifier = viewModel.dashboardCardMlc.componentId
        icon.image = imageProvider?.imageForCode(imageCode: viewModel.dashboardCardMlc.icon) ?? UIImage()
        emptyIcon.image = imageProvider?.imageForCode(imageCode: viewModel.dashboardCardMlc.iconCenter) ?? UIImage()
        emptyDescription.text = viewModel.dashboardCardMlc.descriptionCenter
        label.text = viewModel.dashboardCardMlc.label
        descriptionLabel.text = viewModel.dashboardCardMlc.description
        amountLabel.attributedText = viewModel.dashboardCardMlc.amountLarge?.attributed(font: FontBook.cardsHeadingFont, lineHeight: Constants.lineHeight)
        amountSmallLabel.attributedText = viewModel.dashboardCardMlc.amountSmall?.attributed(font: FontBook.emptyStateTitleFont,
                                                                  lineHeight: Constants.lineHeight)
        
        button.action = .init(title: viewModel.dashboardCardMlc.btnSemiLightAtm?.label, image: nil,
                              callback: {[weak self] in
            if let btnAction = self?.viewModel?.dashboardCardMlc.btnSemiLightAtm?.action {
                self?.viewModel?.eventHandler?(.action(btnAction))
                self?.isAccessibilityElement = true
                self?.accessibilityTraits = .button
            }
        })
        
        let tapViewRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewAction))
        tapViewRecognizer.numberOfTapsRequired = 1
        addGestureRecognizer(tapViewRecognizer)
        
        configureView(for: viewModel.dashboardCardMlc.type)
        setupAccessibility()
    }
    
    private func setupAccessibility() {
        amountView.isAccessibilityElement = true
        amountView.accessibilityTraits = .staticText
        amountView.accessibilityLabel = "\(viewModel?.dashboardCardMlc.amountLarge ?? "") \(viewModel?.dashboardCardMlc.amountSmall ?? "")"
    }
    
    @objc private func viewAction() {
        if let viewAction = viewModel?.dashboardCardMlc.action {
            self.viewModel?.eventHandler?(.action(viewAction))
        }
    }
    
    private func displayFullStack(_ isVisible: Bool) {
        fullViewStack.isHidden = !isVisible
        labelStack.isHidden = !isVisible
        amountView.isHidden = !isVisible
    }
    
    private func configureView(for type: DSWidgetType) {
        switch type {
        case .empty:
            displayFullStack(false)
            emptyStack.isHidden = false
            backgroundColor = UIColor.init(white: 1.0, alpha: 0.5)
            accessibilityLabel = viewModel?.dashboardCardMlc.descriptionCenter
        case .button:
            emptyStack.isHidden = true
            displayFullStack(true)
            button.isHidden = false
            descriptionLabel.isHidden = true
            configureGradient(for: .button)
            accessibilityLabel = "\(viewModel?.dashboardCardMlc.label ?? "") \(viewModel?.dashboardCardMlc.amountLarge ?? "") \(viewModel?.dashboardCardMlc.amountSmall ?? "")"
        case .description:
            emptyStack.isHidden = true
            displayFullStack(true)
            button.isHidden = true
            descriptionLabel.isHidden = false
            configureGradient(for: .description)
            accessibilityLabel = "\(viewModel?.dashboardCardMlc.label ?? "") \(viewModel?.dashboardCardMlc.amountLarge ?? "") \(viewModel?.dashboardCardMlc.amountSmall ?? "")"
        }
    }
    
    private func configureGradient(for type: DSWidgetType) {
        let gradient = GradientView()
        var colors = [UIColor]()
        switch type {
        case .button:
            colors = Constants.buttonWidgetColors
        case .description:
            colors = Constants.textWidgetColors
        default: break
        }
        gradient.configureGradient(for: colors,
                                   corner: Constants.cornerRadius,
                                   startPoint: .init(x: 0.0, y: 0.5),
                                   endPoint: .init(x: 1.0, y: 0.5))
        insertSubview(gradient, at: 0)
        gradient.fillSuperview()
    }
}

extension DSDashboardCardMlcView {
    enum Constants {
        static let cornerRadius: CGFloat = 16
        static let buttonRadius: CGFloat = 16
        static let buttonHeight: CGFloat = 32
        static let padding: CGFloat = 16
        static let lineHeight: CGFloat = 24
        static let smallPadding: CGFloat = 8
        static let imageSize = CGSize(width: 20, height: 20)
        static let emptyImageSize = CGSize(width: 24, height: 24)
        static let buttonColor = UIColor(white: 1, alpha: 0.42)
        static let buttonTitleEdgeInsets: UIEdgeInsets = .init(top: 0, left: 12, bottom: 0, right: 12)
        static let buttonWidgetColors = [UIColor(hex: 0x4BB3FE).withAlphaComponent(0.5),
                                         UIColor(hex: 0xA9D4E7).withAlphaComponent(0.5)]
        static let textWidgetColors = [UIColor(hex: 0x8ED0D0).withAlphaComponent(0.5),
                                       UIColor(hex: 0xA7ED96).withAlphaComponent(0.5)]
    }
}
