
import UIKit
import Lottie
import DiiaCommonTypes

public struct DSStaticVerificationViewModel {
    public let qrCode: QRCodeMlc?
    public let barCode: BarCodeMlc?
}

public class DSStaticVerificationView: BaseCodeView {
    private let qrCodeView = DSQRCodeMlcView()
    private let barCodeView = DSBarCodeMlcView()
    
    public override func setupSubviews() {
        backgroundColor = .clear
        
        addSubviews([qrCodeView, barCodeView])
        [qrCodeView, barCodeView].forEach {
            $0.anchor(leading: leadingAnchor, trailing: trailingAnchor, padding: Constants.paddings)
            $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            $0.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
        qrCodeView.heightAnchor.constraint(equalTo: qrCodeView.widthAnchor).isActive = true
    }
    
    public func configure(with viewModel: DSStaticVerificationViewModel) {
        qrCodeView.isHidden = viewModel.qrCode == nil
        if let qrCode = viewModel.qrCode {
            qrCodeView.configure(for: qrCode)
        }
        
        barCodeView.isHidden = viewModel.barCode == nil
        if let barCode = viewModel.barCode {
            barCodeView.configure(for: barCode)
        }
    }
}

// MARK: - Constants
extension DSStaticVerificationView {
    private enum Constants {
        static let paddings = UIEdgeInsets(top: .zero, left: 40, bottom: .zero, right: 40)
    }
}
