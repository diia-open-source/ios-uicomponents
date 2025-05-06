
import DiiaCommonTypes
import UIKit

public struct DSVerificationCodesBuilder: DSViewBuilderProtocol {
    public static let modelKey = "verificationCodesOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSVerificationCodesModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let verificationCodesView = DSVerificationCodesView()
        let verificationContainer = BoxView(subview: verificationCodesView).withConstraints(insets: Constants.codePadding)
        let viewModel = DSVerificationCodesViewModel(componentId: data.componentId,
                                                     model: data.UA,
                                                     repeatAction: {})
        verificationContainer.heightAnchor.constraint(
            equalTo: verificationContainer.widthAnchor,
            multiplier: Constants.codeViewHeightProportion
        ).isActive = true
        
        verificationCodesView.configure(with: viewModel)
        
        eventHandler(.onComponentConfigured(with: .verificationOrg(viewModel: viewModel)))
        
        return verificationContainer
    }
}

private enum Constants {
    static let codePadding = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
    static let codeViewHeightProportion: CGFloat = 1.4
}
