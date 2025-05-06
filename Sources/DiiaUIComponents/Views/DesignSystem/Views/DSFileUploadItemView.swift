
import UIKit
import DiiaCommonTypes

public enum DSFileLoadingState {
    case notLoaded
    case error(error: DSFileLoadingFileError)
    case loading
    case loaded(id: String)
}

public enum DSFileLoadingFileError {
    case tooLarge
    case failedToUpload
    
    public var description: String {
        switch self {
        case .failedToUpload:
            return R.Strings.file_failed_to_upload.localized()
        case .tooLarge:
            return R.Strings.file_file_too_large.localized()
        }
    }
}

final public class DSFileUploadItemViewModel {
    public let filename: String
    public let image: UIImage
    public let state: Observable<DSFileLoadingState> = .init(value: .notLoaded)
    public var onDelete: Callback?
    public var onRetryClick: Callback?
    
    public init(filename: String, image: UIImage, onDelete: Callback? = nil, onRetryClick: Callback? = nil) {
        self.filename = filename
        self.image = image
        self.onDelete = onDelete
        self.onRetryClick = onRetryClick
    }
    
    public func resourceId() -> String? {
        switch state.value {
        case .loaded(let id): return id
        default: return nil
        }
    }
}

final public class DSFileUploadItemView: BaseCodeView {
    private let icon = UIImageView()
    private let titleLabel = UILabel().withParameters(font: FontBook.bigText)
    private let errorLabel = UILabel().withParameters(font: FontBook.usualFont)
    private let mainStack = UIStackView.create(views: []).withMargins(Constants.mainStackInsets)
    private let fileStack = UIStackView.create(.horizontal, views: [], spacing: Constants.fileStackSpacing, alignment: .center)
    private let labelsStack = UIStackView.create(views: [])
    
    private weak var viewModel: DSFileUploadItemViewModel?
    
    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        addSubview(mainStack)
        mainStack.fillSuperview()
        
        icon.contentMode = .scaleAspectFit
        icon.withSize(Constants.iconSize)
        labelsStack.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        errorLabel.textColor = UIColor(AppConstants.Colors.persianRed)
        
        labelsStack.addArrangedSubviews([
            titleLabel,
            errorLabel
        ])
        
        fileStack.addArrangedSubviews([
            labelsStack,
            icon
        ])
        
        mainStack.addArrangedSubviews([
            fileStack
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClick))
        icon.addGestureRecognizer(tapGesture)
        icon.isUserInteractionEnabled = true
    }
    
    public func configure(viewModel: DSFileUploadItemViewModel) {
        self.viewModel?.state.removeObserver(observer: self)
        self.viewModel = viewModel
        self.titleLabel.text = viewModel.filename
        viewModel.state.observe(observer: self) { [weak self] state in
            self?.icon.stopRotation()
            switch state {
            case .error(let errorType):
                self?.errorLabel.isHidden = false
                self?.titleLabel.isHidden = false
                self?.titleLabel.textColor = Constants.inactiveTextColor
                self?.icon.isHidden = false
                self?.errorLabel.text = errorType.description
                switch errorType {
                case .failedToUpload:
                    self?.icon.image = R.image.retry.image
                case .tooLarge:
                    self?.icon.image = R.image.deleteIcon.image
                }
            case .loaded:
                self?.errorLabel.isHidden = true
                self?.titleLabel.textColor = .black
                self?.icon.isHidden = false
                self?.icon.image = R.image.deleteIcon.image
            case .loading:
                self?.errorLabel.isHidden = true
                self?.icon.image = R.image.loading.image
                self?.icon.isHidden = false
                self?.icon.startRotating()
            case .notLoaded:
                break
            }
        }
    }
    
    @objc private func onClick() {
        guard let state = viewModel?.state.value else { return }
        switch state {
        case .error(let errorType):
            switch errorType {
            case .failedToUpload:
                viewModel?.onRetryClick?()
            case .tooLarge:
                viewModel?.onDelete?()
            }
        case .loaded:
            viewModel?.onDelete?()
        case .loading, .notLoaded:
            break
        }
    }
}

extension DSFileUploadItemView {
    private enum Constants {
        static let mainStackInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        static let iconSize = CGSize(width: 24, height: 24)
        static let inactiveTextColor = UIColor.black.withAlphaComponent(0.3)
        static let fileStackSpacing: CGFloat = 16
    }
}
