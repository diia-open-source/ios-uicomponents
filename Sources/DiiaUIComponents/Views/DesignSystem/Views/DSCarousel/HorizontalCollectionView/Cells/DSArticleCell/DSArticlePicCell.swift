
import UIKit

/// design_system_code: articlePicAtm
final public class DSArticlePicCell: UICollectionViewCell, Reusable {
    private let imageContainer = DSImageContainerView()
    
    // MARK: - Lifecycle
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
    
    // MARK: - Private Methods
    private func initialSetup() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(imageContainer)
        imageContainer.fillSuperview()
    }
    
    // MARK: - Public Methods
    public func configure(with model: DSImageData) {
        imageContainer.configure(data: model)
    }
}

// MARK: - Constants
extension DSArticlePicCell {
    private enum Constants {
        static let cornerRadius: CGFloat = 16
    }
}
