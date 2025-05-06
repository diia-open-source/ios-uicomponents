
import UIKit
import DiiaCommonTypes

public struct DSFixedCardModel: Codable {
    public let componentId: String?
    public let id: String
    public let title: String
    public let chipStatusAtm: DSCardStatusChipModel?
    public let label: String?
    public let subtitle: [DSCardSubtitleModel]?
    public let description: String?
    public let botLabel: String?
    public let tickerAtm: DSTickerAtom?
    public let btnStrokeAdditionalAtm: DSButtonModel?
    public let btnPrimaryAdditionalAtm: DSButtonModel?
    
    public init(
        componentId: String?,
        id: String, title: String,
        chipStatusAtm: DSCardStatusChipModel?,
        label: String?, 
        subtitle: [DSCardSubtitleModel]?,
        description: String?, 
        botLabel: String?,
        ticker: DSTickerAtom?,
        btnStrokeAdditionalAtm: DSButtonModel?,
        btnPrimaryAdditionalAtm: DSButtonModel?
    ) {
        self.componentId = componentId
        self.id = id
        self.title = title
        self.chipStatusAtm = chipStatusAtm
        self.label = label
        self.subtitle = subtitle
        self.description = description
        self.botLabel = botLabel
        self.tickerAtm = ticker
        self.btnStrokeAdditionalAtm = btnStrokeAdditionalAtm
        self.btnPrimaryAdditionalAtm = btnPrimaryAdditionalAtm
    }
}

/// design_system_code: cardFixedMlc
public class DSFixedCardView: UIView {
    
    // MARK: Outlets
    @IBOutlet private weak var container: UIView!
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var statusView: VerticalRoundView!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var statusChipView: UIView!
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitlesStackView: UIStackView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var tickerView: FloatingTextLabel!
    @IBOutlet private weak var botLabel: UILabel!
    @IBOutlet private weak var spacerView: UIView!
    @IBOutlet private weak var strokeButton: ActionButton!
    @IBOutlet private weak var primaryButton: ActionButton!
    
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
        tickerView.reset()
    }
    
    public func willDisplay() {
        tickerView.animate()
    }
    
    public func didEndDisplaying() {
        tickerView.stopAnimation()
    }
    
    public func configure(with model: DSCommonCardViewModel) {
        accessibilityIdentifier = model.componentId
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
        tickerView.isHidden = model.ticker == nil
        if let ticker = model.ticker {
            tickerView.configure(model: ticker)
        }
        
        //TODO: - Finish this card logic implementation
        primaryButton.isHidden = model.primaryButtonAction == nil
        if let primaryButtonAction = model.primaryButtonAction {
            primaryButton.action = primaryButtonAction
        }
        
        strokeButton.isHidden = model.strokeButtonAction == nil
        if let strokeButtonAction = model.strokeButtonAction {
            strokeButton.action = strokeButtonAction
        }
        
        spacerView.isHidden = !(strokeButton.isHidden && botLabel.isHidden)
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
        titleLabel.withParameters(font: FontBook.bigText, numberOfLines: Constants.titleNumberOfLines)
        descriptionLabel.withParameters(font: FontBook.usualFont, textColor: .black.withAlphaComponent(Constants.alpha))
        botLabel.font = FontBook.bigText
        primaryButton.titleLabel?.font = FontBook.usualFont
        strokeButton.titleLabel?.font = FontBook.usualFont
    }
    
    private func setupViews() {
        container.layer.cornerRadius = Constants.cornerRadius
        separatorView.backgroundColor = Constants.separatorColor
        shadowView.layer.applySketchShadow(color: Constants.shadowColor,
                                           alpha: 1,
                                           y: Constants.shadowYOffset,
                                           blur: Constants.shadowBlur)
    }
    
    private func setupButtons() {
        primaryButton.type = .text
        primaryButton.setTitleColor(.white, for: .normal)
        primaryButton.contentEdgeInsets = Constants.buttonInsets
        primaryButton.layer.cornerRadius = primaryButton.bounds.height / 2
        primaryButton.backgroundColor = .black
        primaryButton.contentHorizontalAlignment = .center
        primaryButton.contentVerticalAlignment = .center
        
        strokeButton.type = .text
        strokeButton.setTitleColor(.black, for: .normal)
        strokeButton.contentEdgeInsets = Constants.buttonInsets
        strokeButton.layer.cornerRadius = strokeButton.bounds.height / 2
        strokeButton.backgroundColor = .clear
        strokeButton.withBorder(width: Constants.borderWidth, color: .black)
    }
}

extension DSFixedCardView {
    private enum Constants {
        static let separatorColor: UIColor = .init("#E2ECF4")
        static let buttonInsets = UIEdgeInsets(top: 10, left: 18, bottom: 10, right: 18)
        static let cornerRadius: CGFloat = 8
        static let borderWidth: CGFloat = 2
        static let shadowColor: UIColor = .shadowColor
        static let shadowYOffset: CGFloat = 20
        static let alpha: CGFloat = 0.3
        static let stackSpacing: CGFloat = 8

        static let shadowBlur: CGFloat = 16
        static let titleNumberOfLines = 2
    }
}
