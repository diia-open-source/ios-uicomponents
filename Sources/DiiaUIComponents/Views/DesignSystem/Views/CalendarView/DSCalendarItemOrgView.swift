
import Foundation
import UIKit
import DiiaCommonTypes

public final class DSCalendarItemViewModel: NSObject {
    public var itemOrg: DSCalendarItemOrg?
    @objc public dynamic var isSelected: Bool = false
    public var onChange: ((Bool) -> Void)?
    
    init(itemOrg: DSCalendarItemOrg? = nil, isSelected: Bool = false) {
        self.itemOrg = itemOrg
        self.isSelected = isSelected
    }
}

public final class DSCalendarItemOrgView: BaseCodeView {
    
    private let itemLabel = UILabel().withParameters(font: FontBook.bigText,
                                                     textColor: Constants.grayColor,
                                                     textAlignment: .center)
    private let itemMark = UIView().withSize(Constants.legendSize)
    
    private var viewModel: DSCalendarItemViewModel?
    private var observations: [NSKeyValueObservation] = []
    
    public override func setupSubviews() {
        addSubviews([itemLabel, itemMark])
        itemLabel.anchor(size: Constants.buttonSize)
        
        itemLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        itemLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        itemLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor).isActive = true
        itemLabel.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor).isActive = true
        itemLabel.layer.cornerRadius = Constants.buttonSize.height/2.0
        itemLabel.layer.masksToBounds = true
        
        itemMark.isHidden = true
        itemMark.backgroundColor = Constants.grayColor
        itemMark.layer.cornerRadius = Constants.legendSize.height/2.0
        itemMark.translatesAutoresizingMaskIntoConstraints = false
        itemMark.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        itemMark.bottomAnchor.constraint(equalTo: bottomAnchor,
                                        constant: -Constants.legendPadding).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    public func configure(for model: DSCalendarItemViewModel) {
        viewModel = model
        accessibilityIdentifier = Constants.componentId
        itemLabel.text = model.itemOrg?.calendarItemAtm?.label
        itemMark.isHidden = model.itemOrg?.legendType == nil || model.itemOrg?.legendType == .common
        
        if model.itemOrg?.calendarItemAtm?.isToday == true {
            itemLabel.layer.borderWidth = 1.0
            itemLabel.layer.borderColor = Constants.grayColor.cgColor
        }
        observations = [
            model.observe(\.isSelected, onChange: { [weak self] selected in
                self?.changeSelected(isSelected: selected)
            })
        ]
    }
    
    public func configure(for model: DSCalendarItemOrg) {
        accessibilityIdentifier = Constants.componentId
        itemLabel.text = model.calendarItemAtm?.label
    }
    
    @objc private func onTap() {
        guard let viewModel = viewModel, viewModel.itemOrg?.calendarItemAtm?.isActive == true else { return }
        viewModel.isSelected = true
        viewModel.onChange?(viewModel.isSelected)
    }
    
    public func changeSelected(isSelected: Bool = false) {
        let textColor: UIColor = viewModel?.itemOrg?.calendarItemAtm?.isActive ?? false ? .black : Constants.grayColor
        itemLabel.backgroundColor = isSelected ? .black : .clear
        itemLabel.textColor = isSelected ? .white : textColor
        itemMark.backgroundColor = itemLabel.textColor
        viewModel?.onChange?(isSelected)
    }
}

extension DSCalendarItemOrgView {
    enum Constants {
        static let legendPadding: CGFloat = 4
        static let legendSize = CGSize(width: 4, height: 4)
        static let buttonSize = CGSize(width: 40, height: 40)
        static let componentId = "calendarItem"
        static let grayColor = UIColor.black.withAlphaComponent(0.3)
    }
}
