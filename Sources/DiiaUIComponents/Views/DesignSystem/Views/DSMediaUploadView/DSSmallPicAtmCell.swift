
import UIKit
import DiiaCommonTypes

public enum DSImageLoadingState {
    case notLoaded
    case error
    case loading
    case loaded(id: String)
}

final public class DSSmallPicAtmViewModel {
    public let image: UIImage
    public let state: Observable<DSImageLoadingState> = .init(value: .notLoaded)
    public var onDelete: Callback?
    public var onErrorClick: Callback?
    
    public init(image: UIImage, state: DSImageLoadingState = .loading) {
        self.image = image
        self.state.value = state
    }
}

/// design_system_code: smallPicAtm
final public class DSSmallPicAtmCell: UICollectionViewCell, Reusable {
    private let imageView = UIImageView()
    private let overlayView = UIView()
    private let deleteButton = ActionButton(type: .icon)
    private let stateImageView = UIImageView()
    private let errorLabel = UILabel()
    
    private var viewModel: DSSmallPicAtmViewModel?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    override public func prepareForReuse() {
        viewModel?.state.removeObserver(observer: self)
        viewModel = nil
    }
    
    // MARK: - Public Methods
    public func configure(viewModel: DSSmallPicAtmViewModel) {
        self.viewModel?.state.removeObserver(observer: self)
        self.viewModel = viewModel
        
        imageView.image = viewModel.image
        
        viewModel.state.observe(observer: self) { [weak self] state in
            self?.stateImageView.stopRotation()
            switch state {
            case .error:
                self?.overlayView.isHidden = false
                self?.overlayView.backgroundColor = UIColor("#CA2F28CC")
                self?.errorLabel.isHidden = false
                self?.stateImageView.isHidden = false
                self?.stateImageView.image = R.image.ds_white_retry.image
                self?.deleteButton.isHidden = false
            case .loaded:
                self?.overlayView.isHidden = true
                self?.errorLabel.isHidden = true
                self?.stateImageView.isHidden = true
                self?.deleteButton.isHidden = false
            case .loading:
                self?.overlayView.isHidden = false
                self?.overlayView.backgroundColor = UIColor("#00000099")
                self?.errorLabel.isHidden = true
                self?.stateImageView.image = R.image.loading.image
                self?.stateImageView.isHidden = false
                self?.deleteButton.isHidden = true
                self?.stateImageView.startRotating()
            case .notLoaded:
                break
            }
        }
    }
    
    @objc func onClick() {
        guard let state = viewModel?.state.value else { return }
        switch state {
        case .error:
            viewModel?.onErrorClick?()
        case .loading, .loaded, .notLoaded:
            break
        }
    }
    
    // MARK: - Private Methods
    private func initialSetup() {
        addSubview(imageView)
        addSubview(overlayView)
        addSubview(deleteButton)
        addSubview(stateImageView)
        addSubview(errorLabel)
        
        layer.cornerRadius = Constants.cornerRadius
        clipsToBounds = true
        
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFill
        
        overlayView.fillSuperview()
        
        deleteButton.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, size: Constants.buttonSize)
        
        stateImageView.anchor(size: Constants.imageSize)
        stateImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stateImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stateImageView.contentMode = .scaleAspectFit
        
        errorLabel.withParameters(font: FontBook.statusFont, textColor: .white)
        errorLabel.textAlignment = .center
        errorLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: Constants.errorPaddingInsets)
        
        errorLabel.text = R.Strings.media_upload_error.localized()
        
        deleteButton.setupUI(secondaryColor: .clear, imageRenderingMode: .alwaysOriginal)
        deleteButton.action = .init(image: R.image.ds_ellipseCross.image, callback: { [weak self] in
            self?.viewModel?.onDelete?()
        })
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClick))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }
}

private extension DSSmallPicAtmCell {
    enum Constants {
        static let cornerRadius: CGFloat = 8
        static let imageSize: CGSize = .init(width: 24, height: 24)
        static let buttonSize: CGSize = .init(width: 40, height: 40)
        static let errorPaddingInsets: UIEdgeInsets = .init(top: 0, left: 8, bottom: 12, right: 8)
    }
}
