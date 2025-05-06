
import UIKit
import DiiaCommonTypes


public class DSSmallCheckIconMlcViewModel: NSObject {
    public let componentId: String?
    public let id: String?
    public let code: String
    public let iconType: DSTickerType
    public var isSelected: Observable<Bool>
    public var onChange: ((Bool) -> Void)?
   
    public init(componentId: String?,
                id: String?,
                iconType: DSTickerType,
                code: String,
                isSelected: Observable<Bool> = .init(value: false),
                onChange: ((Bool) -> Void)? = nil) {
        self.componentId = componentId
        self.id = id
        self.code = code
        self.iconType = iconType
        self.isSelected = isSelected
        self.onChange = onChange
    }
}

//ds code: smallCheckIconMlc
public class DSSmallCheckIconMlcView: BaseCodeView {
    private let iconView = UIImageView()
    private let checkmarkIconView = UIImageView()
    private weak var viewModel: DSSmallCheckIconMlcViewModel?
    
    public override func setupSubviews() {
        addSubview(iconView)
        addSubview(checkmarkIconView)
        iconView.fillSuperview()

        iconView.withBorder(width: Constants.borderWidth, color: Constants.borderColor)
        checkmarkIconView.withSize(Constants.checkmarkIconSize)
        checkmarkIconView.anchor(top: iconView.topAnchor, trailing: iconView.trailingAnchor)
        checkmarkIconView.image = R.image.checkboxChecked.image
        
        addTapGestureRecognizer()
    }
    
    public func configure(with viewModel: DSSmallCheckIconMlcViewModel) {
        viewModel.isSelected.removeObserver(observer: self)
        accessibilityIdentifier = viewModel.componentId
        self.viewModel = viewModel
   
        viewModel.isSelected.observe(observer: self) { [weak self] isSelected in
            self?.checkmarkIconView.isHidden = !isSelected
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        iconView.layer.cornerRadius = frame.height / 2
        iconView.clipsToBounds = true
        
        switch viewModel?.iconType {
        case .neutral:
            iconView.image = UIImage.from(color: UIColor(AppConstants.Colors.tickerGrayColor))
        case .positive:
            iconView.image =  R.image.insuranceBar.image ?? UIImage()
        case .informative:
            iconView.image = UIImage.from(color: UIColor(AppConstants.Colors.tickerBlueColor))
        case .warning:
            iconView.image = UIImage.from(color: UIColor(AppConstants.Colors.yellowErrorColor))
        case .negative:
            iconView.image = UIImage.from(color: UIColor(AppConstants.Colors.tickerRedColor))
        case .blue:
            iconView.image = UIImage.gradientImage(with: Constants.gradientBlueColors, size: iconView.bounds.size)
        case .rainbow:
            iconView.image = UIImage.gradientImage(with: Constants.gradientRainbowColors, size: iconView.bounds.size)
        case .pink:
            iconView.image = UIImage.gradientImage(with: Constants.gradientPinkColors, size: iconView.bounds.size)
        default:
            iconView.image = R.image.insuranceBar.image ?? UIImage()
        }
    }

    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    @objc private func onClick() {
        guard let viewModel = viewModel else { return }
        viewModel.isSelected.value = true
        viewModel.onChange?(viewModel.isSelected.value)
    }
}

private extension DSSmallCheckIconMlcView {
    enum Constants {
        static let borderWidth: CGFloat = 1.5
        static let borderColor: UIColor = .black.withAlphaComponent(0.1)
        static let checkmarkIconSize: CGSize = .init(width: 20, height: 20)
        static let gradientBlueColors = [UIColor("#A9CEE7"),UIColor("#4BB3FE")]
        static let gradientPinkColors = [UIColor("#FF3974"),UIColor("#FF6262")]
        static let gradientRainbowColors = [UIColor("#FC2C78"),UIColor("#FFD15C"), UIColor("#4EE89E"), UIColor("#993FC3")]
    }
}
