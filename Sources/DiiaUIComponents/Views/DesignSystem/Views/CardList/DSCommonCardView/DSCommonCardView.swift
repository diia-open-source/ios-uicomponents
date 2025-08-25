
import UIKit
import DiiaCommonTypes

public struct DSCommonCardViewModel {
    public let componentId: String?
    public let id: String
    public let title: String
    public let chipStatusAtm: DSCardStatusChipModel?
    public let label: String?
    public let subtitles: [DSCardSubtitleModel]?
    public let description: String?
    public let botLabel: String?
    public let ticker: DSTickerAtom?
    public let primaryButtonAction: Action?
    public var strokeButtonAction: Action?
    public var primaryButtonActive: Bool?
    
    public init(model: DSCardModel,
                primaryButtonAction: Action? = nil,
                strokeButtonAction: Action? = nil) {
        self.componentId = model.componentId
        self.id = model.id
        self.title = model.title
        self.chipStatusAtm = model.chipStatusAtm
        self.label = model.label
        if let subtitle = model.subtitle {
            self.subtitles = [subtitle]
        } else {
            self.subtitles = model.subtitles
        }
        self.description = model.description
        self.botLabel = model.botLabel
        self.ticker = model.tickerAtm
        self.primaryButtonAction = primaryButtonAction
        self.primaryButtonActive = true
        self.strokeButtonAction = strokeButtonAction
    }
    
    public init(model: DSFixedCardModel,
                actionHandler: ((DSActionParameter) -> Void)? = nil) {
        self.componentId = model.componentId
        self.id = model.id
        self.title = model.title
        self.chipStatusAtm = model.chipStatusAtm
        self.label = model.label
        self.subtitles = model.subtitle
        self.description = model.description
        self.botLabel = model.botLabel
        self.ticker = model.tickerAtm
        
        // TODO: Temporary fix(Ask about this at BA chanel)!!!!!!!!!!
        if let button = model.btnPrimaryAdditionalAtm {
            switch button.state {
            case .enabled, .disabled:
                self.primaryButtonAction = Action(title: button.label, iconName: nil, callback: {
                    if let action = button.action, action.resource != nil {
                        actionHandler?(action)
                    } else {
                        actionHandler?(.init(
                            type: button.action?.type ?? "cardMlc",
                            resource: model.id))
                    }
                })
            case .invisible:
                self.primaryButtonAction = nil
            default:
                self.primaryButtonAction = Action(title: button.label, iconName: nil, callback: {
                    if let action = button.action {
                        actionHandler?(action)
                    }
                })
            }
            self.primaryButtonActive = button.state != .disabled
        } else {
            self.primaryButtonAction = nil
        }
        
        if let button = model.btnStrokeAdditionalAtm {
            switch button.state {
            case .enabled:
                self.strokeButtonAction = Action(title: button.label, iconName: nil, callback: {
                    if let action = button.action {
                        actionHandler?(action)
                    }
                })
            case .disabled, .invisible:
                self.strokeButtonAction = nil
            default:
                self.strokeButtonAction = Action(title: button.label, iconName: nil, callback: {
                    if let action = button.action {
                        actionHandler?(action)
                    }
                })
            }
            self.strokeButtonAction = Action(title: button.label, iconName: nil, callback: {
                if let action = button.action {
                    actionHandler?(action)
                }
            })
        } else {
            self.strokeButtonAction = nil
        }
    }
    
    public init(model: DSCardModel,
                actionHandler: ((DSActionParameter) -> Void)? = nil) {
        var subtitles: [DSCardSubtitleModel]?
        if let subtitle = model.subtitle {
            subtitles = [subtitle]
        } else {
            subtitles = model.subtitles
        }
        let fixedCardMlc = DSFixedCardModel(
            componentId: model.componentId,
            id: model.id,
            title: model.title,
            chipStatusAtm: model.chipStatusAtm,
            label: model.label,
            subtitle: subtitles,
            description: model.description,
            botLabel: model.botLabel,
            ticker: model.tickerAtm,
            btnStrokeAdditionalAtm: model.btnStrokeAdditionalAtm,
            btnPrimaryAdditionalAtm: model.btnPrimaryAdditionalAtm)
        self.init(model: fixedCardMlc, actionHandler: actionHandler)
    }
}

/// design_system_code: cardMlc
public class DSCommonCardView: UIView {
    // MARK: Outlets
    @IBOutlet private weak var container: UIView!
    @IBOutlet private weak var statusView: VerticalRoundView!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var statusChipView: UIView!
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitlesStackView: UIStackView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var tickerViewContainer: UIView!
    @IBOutlet private weak var tickerView: DSTickerView!
    @IBOutlet private weak var botLabel: UILabel!
    @IBOutlet private weak var spacerView: UIView!
    @IBOutlet private weak var strokeButton: ActionButton!
    @IBOutlet private weak var primaryButton: ActionButton!
    
    private var viewModel: DSCommonCardViewModel?
    public var viewId: String?
    
    // MARK: Life cycle
    override public init(frame: CGRect) {
        super.init(frame: frame)
        fromNib(bundle: Bundle.module)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fromNib(bundle: Bundle.module)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        tickerView.startAnimation()
    }
    
    public func willDisplay() {
        tickerView.startAnimation()
    }
    
    public func didEndDisplaying() {
        tickerView.stopAnimation()
    }
    
    public func configure(with model: DSCommonCardViewModel) {
        accessibilityIdentifier = model.componentId
        viewModel = model
        titleLabel.text = model.title
        
        statusChipView.isHidden = model.chipStatusAtm == nil
        if let statusChip = model.chipStatusAtm {
            statusLabel.text = statusChip.name.uppercased()
            statusView.backgroundColor = UIColor(statusChip.statusViewColor)
            statusLabel.textColor = UIColor(statusChip.statusTextColor)
        }
        
        label.isHidden = model.label == nil
        if let label = model.label {
            self.label.text = label
        }
        
        subtitlesStackView.isHidden = model.subtitles == nil
        if let subtitle = model.subtitles, subtitle.count > 0 {
            subtitlesStackView.safelyRemoveArrangedSubviews()
            subtitle.forEach { addSubtitle($0) }
        }
        
        descriptionLabel.isHidden = model.description == nil
        if let description = model.description {
            descriptionLabel.text = description
        }
        
        botLabel.isHidden = model.botLabel == nil
        if let botLabel = model.botLabel {
            self.botLabel.text = botLabel
        }
        
        separatorView.isHidden = model.ticker != nil
        tickerViewContainer.isHidden = model.ticker == nil
        tickerView.isHidden = model.ticker == nil
        if let ticker = model.ticker {
            tickerView.configure(with: ticker)
        }
        
        //TODO: - Finish this card logic implementation 
        primaryButton.isHidden = model.primaryButtonAction == nil
        if let primaryButtonAction = model.primaryButtonAction {
            primaryButton.action = primaryButtonAction
        }
        setPrimaryButtonActive(model.primaryButtonActive == true)
        
        strokeButton.isHidden = model.strokeButtonAction == nil
        if let strokeButtonAction = model.strokeButtonAction {
            strokeButton.action = strokeButtonAction
        }
        
        spacerView.isHidden = !(strokeButton.isHidden && botLabel.isHidden)
        
        setupAccessibility()
    }
    
    public func setPrimaryButtonActive(_ isActive: Bool) {
        primaryButton.alpha = isActive ? 1 : Constants.inactiveAlpha
        primaryButton.isEnabled = isActive
    }
    
    private func addSubtitle(_ model: DSCardSubtitleModel) {
        let iconLabel = UILabel().withParameters(font: FontBook.smallHeadingFont, numberOfLines: 1)
        let subtitleLabel = UILabel().withParameters(font: FontBook.usualFont)
        
        iconLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        iconLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        let subtitleStack = UIStackView.create(
            .horizontal,
            views: [iconLabel, subtitleLabel],
            spacing: Constants.stackSpacing
        )
        subtitlesStackView.addArrangedSubview(subtitleStack)
        
        subtitleLabel.text = model.value
        iconLabel.isHidden = model.icon == nil
        if let icon = model.icon {
            iconLabel.text = icon
        }
    }
    
    // MARK: - Private methods
    private func initialSetup() {
        setupFonts()
        setupViews()
        setupButtons()
    }
    
    private func setupFonts() {
        statusLabel.font = FontBook.statusFont
        label.font = FontBook.usualFont
        titleLabel.font = FontBook.bigText
        descriptionLabel.withParameters(font: FontBook.usualFont, textColor: .black.withAlphaComponent(Constants.inactiveAlpha))
        botLabel.font = FontBook.bigText
        primaryButton.titleLabel?.font = FontBook.usualFont
        strokeButton.titleLabel?.font = FontBook.usualFont
    }
    
    private func setupViews() {
        container.layer.cornerRadius = Constants.cornerRadius
        separatorView.backgroundColor = Constants.separatorColor
    }
    
    private func setupButtons() {
        primaryButton.type = .text
        primaryButton.setTitleColor(.white, for: .normal)
        primaryButton.contentEdgeInsets = Constants.buttonInsets
        primaryButton.layer.cornerRadius = primaryButton.bounds.height * 0.5
        primaryButton.setContentHuggingPriority(.required, for: .horizontal)
        primaryButton.backgroundColor = .black
        primaryButton.contentHorizontalAlignment = .center
        primaryButton.contentVerticalAlignment = .center
        
        strokeButton.type = .text
        strokeButton.setTitleColor(.black, for: .normal)
        strokeButton.contentEdgeInsets = Constants.buttonInsets
        strokeButton.layer.cornerRadius = strokeButton.bounds.height * 0.5
        strokeButton.backgroundColor = .clear
        strokeButton.withBorder(width: Constants.borderWidth, color: .black)
    }
    
    // MARK: - Accessibility
    private func setupAccessibility() {
        guard let viewModel else { return }
        isAccessibilityElement = false
        
        let label = viewModel.label ?? ""
        let description = viewModel.description ?? ""
        let botLabel = viewModel.botLabel ?? ""
        
        container.isAccessibilityElement = true
        container.accessibilityTraits = .staticText
        container.accessibilityLabel = "\(viewModel.title), \(label), \(viewModel.subtitles?.map({ $0.value }).joined(separator: ",") ?? ""), \(description), \(botLabel)"
        container.accessibilityValue = viewModel.chipStatusAtm?.name
        
        strokeButton.isAccessibilityElement = true
        strokeButton.accessibilityTraits = .button
        strokeButton.accessibilityLabel = viewModel.strokeButtonAction?.title
        
        primaryButton.isAccessibilityElement = true
        primaryButton.accessibilityTraits = .button
        primaryButton.accessibilityLabel = viewModel.primaryButtonAction?.title
        
        accessibilityElements = [container, strokeButton, primaryButton].map({ $0 as Any })
    }
}

extension DSCommonCardView {
    private enum Constants {
        static let separatorColor: UIColor = .init("#E2ECF4")
        static let buttonInsets = UIEdgeInsets(top: 10, left: 32, bottom: 10, right: 32)
        static let cornerRadius: CGFloat = 8
        static let borderWidth: CGFloat = 2
        static let shadowColor: UIColor = .shadowColor
        static let shadowYOffset: CGFloat = 20
        static let inactiveAlpha: CGFloat = 0.3
        static let stackSpacing: CGFloat = 8

        static let shadowBlur: CGFloat = 16
    }
}
