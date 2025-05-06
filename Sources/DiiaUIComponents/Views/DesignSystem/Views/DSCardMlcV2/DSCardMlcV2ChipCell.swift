
import UIKit

final public class DSCardMlcV2ChipCell: UICollectionViewCell, Reusable {
    private let chipView = DSChipStatusAtmView()
    
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
        contentView.addSubview(chipView)
        chipView.fillSuperview()
    }
    
    // MARK: - Public Methods
    public func configure(with model: DSCardStatusChipModel) {
        chipView.configure(for: model)
    }
}
