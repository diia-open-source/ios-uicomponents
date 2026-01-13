
import UIKit
import DiiaCommonTypes

public final class DSToggleButtonViewModel: NSObject {
    private let model: DSBtnToggleModel
    public let code: String
    public let label: String
    @objc public dynamic var isSelected: Bool
    public var onClick: Callback?
    
    public init(model: DSBtnToggleModel) {
        self.model = model
        self.code = model.code
        self.label = model.label
        self.isSelected = false
    }
    
    public var icon: UIImage? {
        let selectionStyle = isSelected ? model.selected : model.notSelected
        return UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: selectionStyle.icon)
    }
}

/// design_system_code: btnToggleMlc
public final class DSButtonToggleView: BaseCodeView {
    private let iconViewContainer = UIView().withSize(Constants.iconContainerSize)
    private let iconView = UIImageView()
    private let textLabel = UILabel().withParameters(font: FontBook.bigText)
    
    // MARK: - Properties
    private var viewModel: DSToggleButtonViewModel?
    private var observation: NSKeyValueObservation?
    
    // MARK: - Init
    public override func setupSubviews() {
        iconViewContainer.addSubview(iconView)
        iconView.fillSuperview(padding: Constants.iconPadding)
        stack([iconViewContainer, textLabel],
              spacing: Constants.spacing,
              alignment: .center)
        iconViewContainer.layer.cornerRadius = Constants.iconContainerSize.height / 2
        
        handleSelection()
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DSToggleButtonViewModel) {
        self.viewModel = viewModel
        
        observation = viewModel.observe(\.isSelected) { [weak self] isSelected in
            guard let self = self else { return }
            self.iconViewContainer.backgroundColor = viewModel.isSelected ? Constants.activeColor : Constants.inactiveColor
            self.iconView.image = viewModel.icon
        }
        textLabel.text = viewModel.label
    }
    
    // MARK: - Private methods
    private func handleSelection() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    @objc private func onClick() {
        viewModel?.onClick?()
    }
}

// MARK: - Constants
extension DSButtonToggleView {
    private enum Constants {
        static let iconContainerSize = CGSize(width: 52, height: 52)
        static let iconPadding = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        static let spacing: CGFloat = 12
        static let inactiveColor: UIColor = .black.withAlphaComponent(0.1)
        static let activeColor: UIColor = .black
    }
}
