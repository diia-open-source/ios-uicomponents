
import Foundation
import UIKit
import DiiaCommonTypes

public extension String {
    func asTextParameter() -> String {
        "{" + self + "}"
    }
    
	func attributedTextWithParameters(font: UIFont = FontBook.usualFont, lineHeightMultiple: CGFloat = 1.25, paragraphSpacing: CGFloat? = nil, parameters: [TextParameter]?) -> NSAttributedString? {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
		if let paragraphSpacing = paragraphSpacing {
			paragraphStyle.paragraphSpacing = paragraphSpacing
		}
        let attributedText = NSMutableAttributedString(
            string: self,
            attributes: [
                .font: font,
                .paragraphStyle: paragraphStyle
            ])
        
        for parameter in parameters ?? [] {
            let range = attributedText.mutableString.range(of: parameter.data.name.asTextParameter())
            
            guard Range(range, in: attributedText.string) != nil else { continue }
            attributedText.replaceCharacters(in: range, with: parameter.data.alt)
            let replacedRange = NSRange(location: range.location, length: parameter.data.alt.count)

            switch parameter.type {
            case .link:
                if let link = parameter.data.resource.percentEncodedUrl(), !link.isEmpty {
                    attributedText.addAttributes([.link: link], range: replacedRange)
                }
            case .phone:
                let phoneLink = "tel://\(parameter.data.resource.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())"
                attributedText.addAttributes([.link: phoneLink], range: replacedRange)
            case .email:
                if parameter.data.resource.isValidEmail {
                    let emailLink = "mailto:\(parameter.data.resource)"
                    attributedText.addAttributes([.link: emailLink], range: replacedRange)
                }
            }
        }
        return attributedText
    }
}
