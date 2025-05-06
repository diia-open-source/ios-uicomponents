
import Foundation
import UIKit

public final class DSBarCodeMlcView: BaseCodeView {
    
    private let barCodeLabel = UILabel()
    private let barCodeImage = UIImageView()
    
    public override func setupSubviews() {
        super.setupSubviews()
        
        addSubview(barCodeImage)
        addSubview(barCodeLabel)
        
        barCodeImage.anchor(top: topAnchor,
                            leading: leadingAnchor,
                            trailing: trailingAnchor,
                            size: .init(width: 0,
                                        height: Constants.barCodeHeight))
        
        barCodeLabel.anchor(top: barCodeImage.bottomAnchor,
                            leading: leadingAnchor,
                            bottom: bottomAnchor,
                            trailing: trailingAnchor,
                            padding: .init(top: Constants.padding, left: .zero, bottom: .zero, right: .zero))
        
        barCodeLabel.textAlignment = .center
        barCodeLabel.font = FontBook.bigText
    }
    
    public func configure(for model: BarCodeMlc) {
        accessibilityIdentifier = model.componentId
        barCodeLabel.text = separateBarcode(code: model.barCode)
        barCodeImage.image = .barcode(from: model.barCode)
    }
    
    private func separateBarcode(code: String) -> String {
        let stride: Int = 4
        let separator: String = "  "
        if code.count < stride / 2 { return code }
        var result = ""
        var counter = 0
        while counter < 2 {
            for index in (counter * stride)..<((counter+1) * stride) {
                result += code.character(at: index) ?? ""
            }
            result += separator
            counter += 1
        }
        for index in (counter * stride)..<code.count {
            result += code.character(at: index) ?? ""
        }
        return result
    }
}

extension DSBarCodeMlcView {
    enum Constants {
        static let barCodeHeight: CGFloat = 100
        static let padding: CGFloat = 16
    }
}
