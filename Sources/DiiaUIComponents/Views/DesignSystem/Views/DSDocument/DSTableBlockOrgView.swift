import Foundation

public class DSTableBlockOrgView: BaseCodeView {
    
    let planeTableBlock = DSTableBlockPlaneOrgView()
    
    public override func setupSubviews() {
        super.setupSubviews()
        addSubview(planeTableBlock)
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
        planeTableBlock.fillSuperview(padding: .init(top: Constants.allSidePadding, left: 0, bottom: Constants.allSidePadding, right: 0))
    }
    
    public func configure(for model: DSTableBlockItemModel) {
        planeTableBlock.configure(for: model)
    }
}

extension DSTableBlockOrgView {
    enum Constants {
        static let cornerRadius: CGFloat = 16
        static let allSidePadding: CGFloat = 16
    }
}
