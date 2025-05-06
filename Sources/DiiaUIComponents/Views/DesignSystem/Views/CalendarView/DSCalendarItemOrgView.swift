
import Foundation
import UIKit
import DiiaCommonTypes

public class DSCalendarItemViewModel: NSObject {
    public var itemOrg: DSCalendarItemOrg?
    @objc public dynamic var isSelected: Bool = false
    public var onChange: ((Bool) -> Void)?
    
    init(itemOrg: DSCalendarItemOrg? = nil, isSelected: Bool = false) {
        self.itemOrg = itemOrg
        self.isSelected = isSelected
    }
}

public final class DSCalendarItemOrgView: BaseCodeView {
    
    private let itemLabel = UILabel()
    
    private var viewModel: DSCalendarItemViewModel?
    private var observations: [NSKeyValueObservation] = []
    
    public override func setupSubviews() {
        addSubview(itemLabel)
        itemLabel.anchor(size: Constants.buttonSize)
        itemLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        itemLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        itemLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor).isActive = true
        itemLabel.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor).isActive = true
        itemLabel.layer.cornerRadius = Constants.buttonSize.height/2.0
        itemLabel.layer.masksToBounds = true
        itemLabel.textAlignment = .center
        itemLabel.font = FontBook.bigText
        itemLabel.textColor = Constants.grayColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    public func configure(for model: DSCalendarItemViewModel) {
        viewModel = model
        accessibilityIdentifier = Constants.componentId
        itemLabel.text = model.itemOrg?.calendarItemAtm?.label
        
        if let isToday = model.itemOrg?.calendarItemAtm?.isToday, isToday {
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
        viewModel?.onChange?(isSelected)
    }
}

extension DSCalendarItemOrgView {
    enum Constants {
        static let buttonSize = CGSize(width: 40, height: 40)
        static let componentId = "calendarItem"
        static let grayColor = UIColor.black.withAlphaComponent(0.3)
    }
}
