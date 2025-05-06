
import UIKit

extension UITableView {
    // set the tableHeaderView so that the required height can be determined, update the header's frame and set it again
    func setAndLayoutTableHeaderView(header: UIView) {
        self.tableHeaderView = header
        self.translatesAutoresizingMaskIntoConstraints = false
        header.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        header.setNeedsLayout()
        header.layoutIfNeeded()
        header.frame.size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        self.tableHeaderView = header
    }
    
    func setAndLayoutTableFooterView(footer: UIView) {
        footer.frame.size = footer.systemLayoutSizeFitting(.init(width: frame.width, height: UIView.layoutFittingCompressedSize.height))
        self.tableFooterView = footer
    }

    func dequeueReusableCell<CellClass: Reusable & UITableViewCell>(cellClass: CellClass.Type, for indexPath: IndexPath) -> CellClass {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellClass.reuseID, for: indexPath) as? CellClass
        else {
            return CellClass()
        }
        return cell
    }
}

