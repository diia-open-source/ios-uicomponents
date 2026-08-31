
import UIKit
import DiiaCommonTypes

public struct DSRadioBtnDescription: Codable {
    public let text: String
    public let style: String

    public init(text: String, style: String) {
        self.text = text
        self.style = style
    }
}

public struct DSRadioBtnElementMlcModel: Codable {
    public let componentId: String
    public let id: String?
    public let label: String?
    public let descriptions: [DSRadioBtnDescription]
    public let isSelected: Bool?
    public let isEnabled: Bool?

    public init(
        componentId: String,
        id: String? = nil,
        label: String? = nil,
        descriptions: [DSRadioBtnDescription] = [],
        isSelected: Bool? = nil,
        isEnabled: Bool? = nil) {
        self.componentId = componentId
        self.id = id
        self.label = label
        self.descriptions = descriptions
        self.isSelected = isSelected
        self.isEnabled = isEnabled
    }
}

public final class DSRadioBtnElementMlcViewModel: NSObject {
    public let model: DSRadioBtnElementMlcModel
    public var isSelected: Observable<Bool>
    public var isEnabled: Observable<Bool>

    public init(model: DSRadioBtnElementMlcModel,
                isSelected: Observable<Bool>,
                isEnabled: Observable<Bool>,
                onClick: Callback? = nil) {
        self.model = model
        self.isSelected = isSelected
        self.isEnabled = isEnabled
    }
}

//ds_code: radioBtnElementMlc
public final class DSRadioBtnElementMlcView: BaseCodeView {
    private let mainHStack = UIStackView.create(.horizontal, spacing: Constants.spacing, alignment: .top)
    private let contentStack = UIStackView.create(.vertical, spacing: Constants.vSpacing)
    private let titleLabel = UILabel().withParameters(font: FontBook.bigText, textColor: .black)
    private let descriptionsStack = UIStackView.create(.vertical, spacing: Constants.descriptionSpacing)
    private let selectionIcon = UIImageView()

    private var viewModel: DSRadioBtnElementMlcViewModel?

    public override func setupSubviews() {
        addSubview(mainHStack)
        mainHStack.fillSuperview(padding: Constants.paddings)

        selectionIcon.withSize(Constants.selectionIconSize)
        selectionIcon.tintColor = .black

        contentStack.addArrangedSubviews([titleLabel, descriptionsStack])
        mainHStack.addArrangedSubviews([selectionIcon, contentStack])

        titleLabel.numberOfLines = 0
    }

    public func configure(with viewModel: DSRadioBtnElementMlcViewModel) {
        self.viewModel = viewModel

        titleLabel.isHidden = viewModel.model.label?.isEmpty ?? true
        titleLabel.text = viewModel.model.label

        descriptionsStack.safelyRemoveArrangedSubviews()
        descriptionsStack.isHidden = viewModel.model.descriptions.isEmpty
        viewModel.model.descriptions.forEach { description in
            let label = UILabel().withParameters(font: FontBook.usualFont,
                                                  textColor: textColor(for: description.style))
            label.numberOfLines = 0
            label.text = description.text
            descriptionsStack.addArrangedSubview(label)
        }

        viewModel.isSelected.removeObserver(observer: self)
        viewModel.isSelected.observe(observer: self) { [weak self] isSelected in
            self?.setSelectionState(isSelected)
        }

        viewModel.isEnabled.removeObserver(observer: self)
        viewModel.isEnabled.observe(observer: self) { [weak self] isEnabled in
            self?.setAvailabilityState(isEnabled)
        }

        tapGestureRecognizer { [weak self] in
            guard let self, let viewModel = self.viewModel, viewModel.isEnabled.value else { return }
            guard !viewModel.isSelected.value else { return }
            viewModel.isSelected.value = true
        }
    }

    private func textColor(for style: String?) -> UIColor {
        switch style {
        case Constants.hintStyle:
            return Constants.hintColor
        default:
            return Constants.initialColor
        }
    }

    private func setSelectionState(_ isSelected: Bool) {
        selectionIcon.image = (isSelected ?
              R.image.radioCheckbox.image : R.image.emptyChecboxBlack.image)?.withRenderingMode(.alwaysTemplate)
    }

    private func setAvailabilityState(_ isEnabled: Bool) {
        alpha = isEnabled ? 1.0 : 0.4
    }
}

private extension DSRadioBtnElementMlcView {
    enum Constants {
        static let initialColor: UIColor = .black
        static let hintColor: UIColor = .black540
        static let selectionIconSize: CGSize = .init(width: 20, height: 20)
        static let spacing: CGFloat = 12
        static let vSpacing: CGFloat = 4
        static let descriptionSpacing: CGFloat = 4
        static let hintStyle = "hint"
        static let paddings = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}
