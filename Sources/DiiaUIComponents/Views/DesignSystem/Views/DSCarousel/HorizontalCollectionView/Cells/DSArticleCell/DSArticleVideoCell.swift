
import UIKit

/// design_system_code: articleVideoMlc
final public class DSArticleVideoCell: UICollectionViewCell, Reusable {
    private let videoContainer = DSVideoContainerView()
    
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
        
        contentView.addSubview(videoContainer)
        videoContainer.fillSuperview()
    }
    
    // MARK: - Public Methods
    public func configure(with model: DSVideoData) {
        videoContainer.configure(data: model)
    }
}

// MARK: - Constants
extension DSArticleVideoCell {
    private enum Constants {
        static let cornerRadius: CGFloat = 16
    }
}
