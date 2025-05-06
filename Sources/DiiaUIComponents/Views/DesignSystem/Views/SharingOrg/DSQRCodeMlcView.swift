
import Foundation
import UIKit

public final class DSQRCodeMlcView: BaseCodeView {
    
    private let qrImage = UIImageView()
    
    public override func setupSubviews() {
        super.setupSubviews()
        addSubview(qrImage)
        qrImage.fillSuperview()
    }
    
    public func configure(for model: QRCodeMlc) {
        accessibilityIdentifier = model.componentId
        qrImage.image = .qrCode(from: model.qrLink)
    }
    
}
