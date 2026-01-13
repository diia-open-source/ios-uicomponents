
import UIKit

public final class DSSingleMediaUploadPhotoView: BaseCodeView {
    private let imageView = UIImageView()
    private let overlayView = UIView()
    private let deleteButton = ActionButton(type: .icon)
    private let stateImageView = UIImageView()
    private let errorLabel = UILabel()
    private weak var viewModel: DSFileUploadItemViewModel?

    public override func setupSubviews() {
       initialSetup()
    }
    
    public func configure(with viewModel: DSFileUploadItemViewModel) {
        self.viewModel?.state.removeObserver(observer: self)
        self.viewModel = viewModel
        imageView.image = viewModel.image
        viewModel.state.observe(observer: self) { [weak self] state in
            self?.stateImageView.stopRotation()
            switch state {
            case .error(let errorType):
                self?.errorLabel.text = errorType.description
                self?.imageView.image = nil
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
    
    private func initialSetup() {
        addSubview(imageView)
        addSubview(overlayView)
        addSubview(deleteButton)
        addSubview(stateImageView)
        addSubview(errorLabel)
        
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
        
    @objc func onClick() {
        guard let state = viewModel?.state.value else { return }
        switch state {
        case .error:
            viewModel?.onRetryClick?()
        case .loading, .loaded, .notLoaded:
            break
        }
    }
}

private extension DSSingleMediaUploadPhotoView {
    enum Constants {
        static let borderColor = UIColor.black.withAlphaComponent(0.1)
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 8
        static let imageSize: CGSize = .init(width: 24, height: 24)
        static let photoSize: CGSize = .init(width: 132, height: 176)
        static let errorPaddingInsets: UIEdgeInsets = .init(top: 0, left: 8, bottom: 12, right: 8)
        static let buttonSize: CGSize = .init(width: 40, height: 40)
    }
}
