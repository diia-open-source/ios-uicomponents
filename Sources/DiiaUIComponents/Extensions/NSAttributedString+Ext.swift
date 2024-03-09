import UIKit

public extension NSAttributedString {
    func height(containerWidth: CGFloat) -> CGFloat {
        let rect = self.boundingRect(with: CGSize.init(width: containerWidth, height: CGFloat.greatestFiniteMagnitude),
                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                     context: nil)
        return ceil(rect.size.height)
    }
}

public extension NSMutableAttributedString {
    
    func finalizeWithImage(imageName: String) -> NSMutableAttributedString {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: imageName)
        let imageString = NSAttributedString(attachment: imageAttachment)
        
        let updatedString = self
        updatedString.append(imageString)
        return updatedString
    }
}
