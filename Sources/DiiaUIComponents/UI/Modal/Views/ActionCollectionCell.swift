
import UIKit

public class ActionCollectionCell: BaseCollectionNibCell, NibLoadable {
    @IBOutlet weak private var nameLbl: UILabel!
    @IBOutlet weak private var imageView: UIImageView!

    public static let nib = UINib(nibName: reuseID, bundle: Bundle.module)

    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
        setupUI()
    }
    
    private func setupViews() {}
    
    public func configure(with title: String?, image: UIImage?) {
        nameLbl.text = title
        imageView.image = image
    }
    
    private func setupUI() {
        nameLbl.font = FontBook.smallTitle
    }
}
