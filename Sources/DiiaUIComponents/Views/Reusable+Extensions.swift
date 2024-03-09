import UIKit

// MARK: - NibReusable
public typealias NibReusable = Reusable & NibLoadable

// MARK: - Reusable
public protocol Reusable: AnyObject {
    /// The reuse identifier to use when registering and later dequeuing a reusable cell
    static var reuseID: String { get }
}

public extension Reusable {
    /// By default, use the name of the class as String for its reuseIdentifier
    static var reuseID: String {
        return String(describing: self)
    }
}

// MARK: - NibLoadable
public protocol NibLoadable: AnyObject {
    /// The nib file to use to load a new instance of the View designed in a XIB
    static var nib: UINib { get }
}

// cant be public, because if it's called from outer pkgs the Bundle will be UIComponents bundle
internal extension NibLoadable {
    /// By default, use the nib which have the same name as the name of the class,
    /// and located in the bundle of that class
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle.module)
    }
}

extension NibLoadable where Self: UIView {
    static func loadFromNib() -> Self {
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("The nib \(nib) expected its root view to be of type \(self)")
        }
        return view
    }
}

// MARK: - UICollectionView
public extension UICollectionView {
    
    final func register<T: UICollectionViewCell>(cellType: T.Type) where T: Reusable {
        register(cellType.self, forCellWithReuseIdentifier: cellType.reuseID)
    }

    final func dequeueReusableCell<T: UICollectionViewCell>(
        for indexPath: IndexPath,
        cellType: T.Type = T.self
    ) -> T where T: Reusable {
        let bareCell = dequeueReusableCell(withReuseIdentifier: cellType.reuseID,
                                           for: indexPath)
        guard let cell = bareCell as? T else {
            fatalError(
                "Failed to dequeue a cell with identifier \(cellType.reuseID) matching type \(cellType.self)."
            )
        }
        return cell
    }

    final func register<T: UICollectionReusableView>(
        supplementaryViewType: T.Type,
        ofKind elementKind: String) where T: Reusable {
            register(
                supplementaryViewType.self,
                forSupplementaryViewOfKind: elementKind,
                withReuseIdentifier: supplementaryViewType.reuseID
            )
        }

    final func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
        ofKind elementKind: String,
        for indexPath: IndexPath,
        viewType: T.Type = T.self
    ) -> T where T: Reusable {
        let view = self.dequeueReusableSupplementaryView(
            ofKind: elementKind,
            withReuseIdentifier: viewType.reuseID,
            for: indexPath
        )
        guard let typedView = view as? T else {
            fatalError(
                "Failed to dequeue a supplementary view with identifier \(viewType.reuseID) "
                + "matching type \(viewType.self)."
            )
        }
        return typedView
    }
}

// MARK: - UITableView
public extension UITableView {

    final func register<T: UITableViewCell>(cellType: T.Type) where T: Reusable {
        register(cellType.self, forCellReuseIdentifier: cellType.reuseID)
    }

    final func dequeueReusableCell<T: UITableViewCell>(
        for indexPath: IndexPath,
        cellType: T.Type = T.self
    ) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseID,
                                             for: indexPath) as? T else {
            fatalError(
                "Failed to dequeue a cell with identifier \(cellType.reuseID) matching type \(cellType.self)."
            )
        }
        return cell
    }

    final func register<T: UITableViewHeaderFooterView>(headerFooterViewType: T.Type) where T: Reusable {
        register(headerFooterViewType.self,
                 forHeaderFooterViewReuseIdentifier: headerFooterViewType.reuseID)
    }

    final func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ viewType: T.Type = T.self) -> T?
    where T: Reusable {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: viewType.reuseID) as? T? else {
            fatalError(
                "Failed to dequeue a header/footer with identifier \(viewType.reuseID) "
                + "matching type \(viewType.self). "
            )
        }
        return view
    }
}
