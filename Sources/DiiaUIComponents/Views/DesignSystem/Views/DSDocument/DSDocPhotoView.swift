import UIKit

public class DSDocPhotoView: BaseCodeView {
    
    private var photoView = UIImageView()
    
    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        photoView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(photoView)
        photoView.fillSuperview()
        photoView.heightAnchor.constraint(equalTo: photoView.widthAnchor, multiplier: DocumentsLayoutProvider.docPhotoProportion).isActive = true
        photoView.contentMode = .scaleAspectFill
        layer.masksToBounds = true
        layer.cornerRadius = Constants.viewCorner
    }
    
    public func configure(content: UIImage?) {
        photoView.image = content
    }
    
    public func configure(content: String?) {
        guard let dataContent = content else { return }
        photoView.image = .createWithBase64String(dataContent)
    }
    
    private func setupUI() {}
}

extension DSDocPhotoView {
    enum Constants {
        static let viewCorner: CGFloat = 16
        static let viewSize = CGSize(width: 132, height: 176)
    }
}
