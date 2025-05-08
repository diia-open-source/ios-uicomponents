
import Foundation
import UIKit
import DiiaCommonTypes
import Lottie

/// design_system_code: DSCalendarOrg

public final class DSCalendarOrgView: BaseCodeView, DSInputComponentProtocol {
    
    private let currentTimeMlcView = DSCurrentTimeMlcView()
    private let backBtn = ActionButton(type: .icon)
    private let forwardBtn = ActionButton(type: .icon)
    private let stubMsgBoxView = BoxView(subview: StubMessageViewV2()).withConstraints(insets: Constants.stubPadding)
    private let calendarStack = UIStackView.create(spacing: Constants.calendarSpacing)
    private var chipsView = DSCalendarChipsView()
    
    private lazy var animation: LottieAnimationView = {
        let animation = LottieAnimation.named("loader")
        let lottieView = LottieAnimationView(animation: animation)
        lottieView.loopMode = .loop
        lottieView.backgroundBehavior = .pauseAndRestore
        return lottieView
    }()
    
    private lazy var animationView: BoxView<LottieAnimationView> = {
        let box = BoxView(subview: animation)
        box.backgroundColor = .white
        box.layer.cornerRadius = Constants.loadingRadius
        box.withConstraints(size: Constants.loadingSize,
                            centeredX: true,
                            centeredY: true)
        return box
    }()
    
    private var imageProvider: DSImageNameProvider? = UIComponentsConfiguration.shared.imageProvider
    private var viewModel: DSCalendarOrgViewModel?
    private var selectedCalendarItem: DSCalendarItemViewModel?
    private var calendarMode: Calendar.Component = .month
    private lazy var weekdays: [String] = { return calendar.shortWeekdaySymbols.map { $0 } }()
    
    public override func setupSubviews() {
        let topCalendarHeaderStack = UIStackView.create(.horizontal, views: [backBtn, currentTimeMlcView, forwardBtn])
        let buttonSize = CGSize(width: Constants.topViewHeight, height: Constants.topViewHeight)
        forwardBtn.withSize(buttonSize)
        backBtn.withSize(buttonSize)
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(AppConstants.Colors.emptyDocuments)
        separatorView.withHeight(Constants.lineHeight)
        
        let calendarBoxView = BoxView(subview: calendarStack)
        calendarBoxView.withConstraints(insets: Constants.offset)
        
        let fullCalendarStack = UIStackView.create(views: [topCalendarHeaderStack, separatorView, calendarBoxView])
        
        let cornerBoxView = BoxView(subview: fullCalendarStack)
        cornerBoxView.backgroundColor = .white
        cornerBoxView.layer.cornerRadius = Constants.cornerRadius
        
        let globalStackView = UIStackView.create(views: [cornerBoxView, chipsView], spacing: Constants.viewPadding)
        addSubview(globalStackView)
        
        globalStackView.fillSuperview()
        
        addSubview(stubMsgBoxView)
        stubMsgBoxView.anchor(top: calendarBoxView.topAnchor,
                           leading: globalStackView.leadingAnchor,
                           bottom: calendarBoxView.bottomAnchor,
                           trailing: globalStackView.trailingAnchor)
        stubMsgBoxView.backgroundColor = .white
        stubMsgBoxView.layer.cornerRadius = Constants.cornerRadius
        stubMsgBoxView.isHidden = true
        
        addSubview(animationView)
        
        animationView.anchor(top: fullCalendarStack.topAnchor,
                             leading: fullCalendarStack.leadingAnchor,
                             bottom: fullCalendarStack.bottomAnchor,
                             trailing: fullCalendarStack.trailingAnchor)
        let animationViewHeight = animationView.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.defaultCalendarHeight)
        animationViewHeight.priority = .defaultHigh
        animationViewHeight.isActive = true
        
        animationView.isHidden = true
        
        backBtn.tintColor = .black
        forwardBtn.tintColor = .black
        
        backBtn.contentHorizontalAlignment = .center
        forwardBtn.contentHorizontalAlignment = .center
    }
    
    public func configure(for viewModel: DSCalendarOrgViewModel) {
        if let currentTimeMlc = viewModel.currentTimeMlc {
            currentTimeMlcView.configure(for: currentTimeMlc)
        }
        if let backBtnModel = viewModel.backBtn {
            configureForwardButton(with: backBtnModel)
        }
        if let forwardBtnModel = viewModel.forwardBtn {
            configureForwardButton(with: forwardBtnModel)
        }
        
        let currentDateTap = UITapGestureRecognizer(target: self, action: #selector(monthsConfigure))
        currentTimeMlcView.addGestureRecognizer(currentDateTap)
        
        selectedCalendarItem = nil
        
        viewModel.eventHandler?(.calendarAction(event: .onAppear, viewModel: viewModel))
        configureCalendar()
        
        configureObservers(for: viewModel)
        self.viewModel = viewModel
    }
    
    fileprivate func configureObservers(for viewModel: DSCalendarOrgViewModel) {
        self.viewModel?.isLoading.removeObserver(observer: self)
        viewModel.isLoading.observe(observer: self) { [weak self] isLoading in
            guard let self = self else { return }
            self.updateLoading(to: isLoading)
        }
        
        self.viewModel?.calendarOrg.removeObserver(observer: self)
        viewModel.calendarOrg.observe(observer: self) { [weak self] calendarOrg in
            guard let self = self else { return }
            self.viewModel?.items = calendarOrg.items
            self.stubMsgBoxView.isHidden = true
            if calendarOrg.currentTimeMlc != nil {
                self.viewModel?.currentTimeMlc = calendarOrg.currentTimeMlc
            }
            if calendarOrg.iconForMovingBackwards?.iconAtm != nil {
                self.viewModel?.backBtn = calendarOrg.iconForMovingBackwards?.iconAtm
            }
            if calendarOrg.iconForMovingForward?.iconAtm != nil {
                self.viewModel?.forwardBtn = calendarOrg.iconForMovingForward?.iconAtm
            }
            if let backBtnModel = self.viewModel?.backBtn {
                configureBackwardButton(with: backBtnModel)
            }
            if let forwardBtnModel = self.viewModel?.forwardBtn {
                configureForwardButton(with: forwardBtnModel)
            }
            if let stubMessage = calendarOrg.stubMessageMlc {
                let viewModel = StubMessageViewModel(model: stubMessage)
                stubMsgBoxView.subview.configure(with: viewModel)
                stubMsgBoxView.isHidden = false
            }
            self.configureCalendar()
        }
        self.viewModel?.selectedPeriod.removeObserver(observer: self)
        viewModel.selectedPeriod.observe(observer: self) { [weak self] selectedPeriod in
            guard let self else { return }
            self.viewModel?.selectedChipData.value = nil
            if self.calendarMode == .month {
                guard let viewModel = self.viewModel else { return }
                viewModel.eventHandler?(.calendarAction(event: .monthSelected(date: selectedPeriod),
                                                        viewModel: viewModel))
            } else {
                self.monthsConfigure()
            }
        }
        self.viewModel?.selectedDate.removeObserver(observer: self)
        viewModel.selectedDate.observe(observer: self) { [weak self] selectedDate in
            guard let self else { return }
            self.viewModel?.selectedChipData.value = nil
            if let date = selectedDate,
               let calendarItem = self.viewModel?.items?.first(where: {
                   $0.calendarItemOrg.date == self.fullDateFormatter.string(from: date)})?.calendarItemOrg,
               let chipsGroupOrg = calendarItem.chipGroupOrg {
                self.chipsView.configure(for: chipsGroupOrg, chipSelectedCallback: { [weak self] selectedData in
                    self?.viewModel?.selectedChipData.value = selectedData
                })
            } else {
                self.chipsView.configure()
            }
        }
        
        self.viewModel?.selectedChipData.removeObserver(observer: self)
        viewModel.selectedChipData.observe(observer: self) { [weak self] selectedChipData in
            guard let viewModel = self?.viewModel else { return }
            viewModel.eventHandler?(.calendarAction(event: .timeSelected(date: selectedChipData),
                                                    viewModel: viewModel))
        }
    }
    
    private func configureForwardButton(with model: DSIconModel) {
        forwardBtn.action = Action(iconName: imageProvider?.imageNameForCode(imageCode: model.code),
                                   callback: {[weak self] in
            self?.changePeriod(reduce: true, for: model.action?.resource)
        })
        forwardBtn.isEnabled = model.isEnable ?? true
        forwardBtn.accessibilityLabel = model.accessibilityDescription
    }
    
    private func configureBackwardButton(with model: DSIconModel) {
        backBtn.action = Action(iconName: imageProvider?.imageNameForCode(imageCode: model.code),
                                   callback: {[weak self] in
            self?.changePeriod(reduce: false, for: model.action?.resource)
        })
        backBtn.isEnabled = model.isEnable ?? true
        backBtn.accessibilityLabel = model.accessibilityDescription
    }
    
    private func configureCalendar() {
        guard let viewModel = viewModel else { return }
        let selectedPeriod = viewModel.selectedPeriod.value ?? Date()
        let availableItems = self.viewModel?.items
        
        calendarStack.safelyRemoveArrangedSubviews()
        setupHeader()
        
        var dateIteration = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedPeriod))!
        dateIteration = calendar.date(byAdding: .day, value: -1, to: dateIteration)!
        let firstWeekDay = calendar.component(.weekday, from: dateIteration)
        
        repeat {
            let weekStackView = UIStackView.create(.horizontal, spacing: Constants.horizontalSpacing, distribution: .fillEqually)
            if calendarStack.arrangedSubviews.count == 1 {
                (1..<firstWeekDay).forEach({_ in weekStackView.addArrangedSubview(UIView())})
            }
            repeat {
                dateIteration = calendar.date(byAdding: .day, value: 1, to: dateIteration)!
                let isAvailable = availableItems?.contains(where: {$0.calendarItemOrg.date == fullDateFormatter.string(from: dateIteration)}) == true
                let dayItem = createDayItem(date: dateIteration, isAvailable: isAvailable)
                weekStackView.addArrangedSubview(dayItem)
            } while calendar.isDate(dateIteration,
                                    equalTo: calendar.date(byAdding: .day, value: 1, to: dateIteration)!,
                                    toGranularity: .weekOfMonth)
            if weekStackView.arrangedSubviews.count < weekdays.count {
                let daysAfter = weekdays.count - weekStackView.arrangedSubviews.count
                (0..<daysAfter).forEach({_ in weekStackView.addArrangedSubview(UIView())})
            }
            calendarStack.addArrangedSubview(weekStackView)
        } while calendar.isDate(dateIteration,
                                equalTo: calendar.date(byAdding: .day, value: 1,
                                                       to: dateIteration)!, toGranularity: .month)
    }
    
    private func createDayItem(date: Date, isAvailable: Bool) -> UIView {
        let calendarItem = DSCalendarItemOrgView()
        let viewModel = DSCalendarItemViewModel(itemOrg: .init(date: fullDateFormatter.string(from: date),
                                                               calendarItemAtm: .init(label: dateFormatter.string(from: date),
                                                                                      isActive: isAvailable,
                                                                                      isToday: calendar.isDateInToday(date))))
        viewModel.onChange = { [weak self] isSelected in
            guard isSelected, self?.selectedCalendarItem != viewModel else { return }
            self?.selectedCalendarItem?.isSelected = false
            self?.selectedCalendarItem = viewModel
            self?.viewModel?.selectedDate.value = self?.fullDateFormatter.date(from: viewModel.itemOrg?.date ?? "")
        }
        calendarItem.configure(for: viewModel)
        return calendarItem
    }
    
    @objc public func monthsConfigure() {
        guard let viewModel = viewModel else { return }
        let selectedPeriod = viewModel.selectedPeriod.value ?? Date()
        
        calendarStack.safelyRemoveArrangedSubviews()
        setupYearHeader()
        
        calendarMode = .year
        viewModel.selectedDate.value = nil
        
        var month = 1
        for _ in 0..<Constants.monthVertical {
            let rowStack = UIStackView.create(.horizontal, distribution: .fillEqually)
            for _ in 0..<Constants.monthHorizontal {
                if let date = calendar.date(from: DateComponents(year: selectedPeriod.year, month: month)) {
                    rowStack.addArrangedSubview(createMonthLabel(date: date))
                }
                month += 1
            }
            calendarStack.addArrangedSubview(rowStack)
        }
    }
    
    private func createMonthLabel(date: Date) -> UIView {
        var isActive = calendar.isDate(date, equalTo: Date(), toGranularity: .month) || date > Date()
        if let maxDateStr = viewModel?.currentTimeMlc?.maxDate, let maxDate = Constants.monthYearFormatter.date(from: maxDateStr) {
            isActive = isActive && (date.compare(maxDate) == .orderedAscending || date.compare(maxDate) == .orderedSame)
        }
        let item = DSCalendarItemOrg(date: fullDateFormatter.string(from: date),
                                     calendarItemAtm: .init(label: date.monthStr.prefix(3).capitalized,
                                                            isActive: isActive,
                                                            isToday: false,
                                                            isSelected: false))
        let calendarItemView = DSCalendarItemOrgView()
        let viewModel = DSCalendarItemViewModel(itemOrg: item)
        calendarItemView.configure(for: viewModel)
        viewModel.onChange = { [weak self] isSelected in
            guard isSelected, self?.selectedCalendarItem != viewModel else { return }
            self?.selectedCalendarItem?.isSelected = false
            self?.selectedCalendarItem = viewModel
            self?.calendarMode = .month
            self?.viewModel?.selectedPeriod.value = self?.fullDateFormatter.date(from: viewModel.itemOrg?.date ?? "") ?? Date()
        }
        return calendarItemView
    }
    
    //MARK: Setup calendar headers
    
    private func setupHeader() {
        guard let viewModel = viewModel else { return }
        
        let selectedPeriod = viewModel.selectedPeriod.value ?? Date()
        
        if let currentTimeMlc = viewModel.currentTimeMlc {
            currentTimeMlcView.configure(for: currentTimeMlc)
        } else {
            let currentTime = selectedPeriod.monthStr.capitalized + " \(calendar.component(.year, from: selectedPeriod))"
            currentTimeMlcView.configure(for: DSCurrentTimeMlc(label: currentTime))
        }
        
        let horizontalStack = UIStackView.create(.horizontal, spacing: Constants.horizontalSpacing, distribution: .fillEqually)
        var weekSymbols = calendar.shortWeekdaySymbols
        weekSymbols.append(weekSymbols.remove(at: weekSymbols.startIndex))
        for weekday in weekSymbols {
            let calendarItem = DSCalendarItemOrgView()
            calendarItem.configure(for: .init(date: weekday,
                                              calendarItemAtm: .init(label: weekday)))
            horizontalStack.addArrangedSubview(calendarItem)
        }
        calendarStack.addArrangedSubview(horizontalStack)
    }
    
    private func setupYearHeader(for currentTime: DSCurrentTimeMlc? = nil) {
        guard let viewModel = viewModel, let selectedPeriod = viewModel.selectedPeriod.value else { return }
        
        self.stubMsgBoxView.isHidden = true
        
        let currentTime = "\(calendar.component(.year, from: selectedPeriod))"
        currentTimeMlcView.configure(for: DSCurrentTimeMlc(label: currentTime))
        
        let maxDateStr = viewModel.currentTimeMlc?.maxDate ?? ""
        let maxDateYear = Constants.monthYearFormatter.date(from: maxDateStr)?.year ?? (Date().year + 1)
        
        let isBackAvailable = selectedPeriod.year > Date().year
        backBtn.isEnabled = isBackAvailable
        
        let isNextAvailable = selectedPeriod.year < maxDateYear
        forwardBtn.isEnabled = isNextAvailable
    }
    
    private func updateLoading(to state: Bool) {
        animationView.isHidden = !state
        chipsView.isHidden = state
        if state {
            animationView.subview.play()
        } else {
            animationView.subview.pause()
        }
    }
    
    //MARK: Navigation month - year action
    
    private func changePeriod(reduce: Bool, for dateStr: String? = nil) {
        guard let viewModel = viewModel else { return }
        let selectPeriod = viewModel.selectedPeriod.value ?? Date()
        viewModel.selectedDate.value = nil
        if calendarMode == .month, let date = dateStr {
            viewModel.selectedPeriod.value = Constants.monthYearFormatter.date(from: date) ?? selectPeriod
        } else {
            viewModel.selectedPeriod.value = calendar.date(byAdding: calendarMode,
                                                           value: reduce ? 1 : -1,
                                                           to: selectPeriod) ?? selectPeriod
        }
    }
    
    //MARK: Input Protocol
    public func isValid() -> Bool {
        return viewModel?.selectedChipData.value != nil
    }
    
    public func inputCode() -> String {
        return viewModel?.inputCode ?? "calendarOrg"
    }
    
    public func inputData() -> AnyCodable? {
        return viewModel?.selectedChipData.value
    }
}

extension DSCalendarOrgView {
    enum Constants {
        static let defaultCalendarHeight: CGFloat = 340
        static let loadingSize = CGSize(width: 80, height: 80)
        static let loadingRadius: CGFloat = 8
        static let topViewHeight: CGFloat = 56
        static let lineHeight: CGFloat = 1
        static let cornerRadius: CGFloat = 8
        static let stubPadding = UIEdgeInsets(top: 64, left: 24, bottom: 64, right: 24)
        static let offset = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
        static let calendarSpacing: CGFloat = 4
        static let horizontalSpacing: CGFloat = 2
        static let monthHorizontal = 3
        static let monthVertical = 4
        static let viewPadding: CGFloat = 24
        static var monthYearFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "uk_UA")
            formatter.dateFormat = "MM.yyyy"
            formatter.timeZone = TimeZone(secondsFromGMT: .zero)
            return formatter
        }()
    }
}

private extension Date {
    var monthStr: String {
        var calendar = Calendar.current
        calendar.locale = .init(identifier: "uk_UA")
        calendar.timeZone = TimeZone(secondsFromGMT: .zero)!
        let names = calendar.standaloneMonthSymbols
        let month = calendar.component(.month, from: self)
        return names[month - 1]
    }
}

private extension DSCalendarOrgView {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "uk_UA")
        formatter.dateFormat = "d"
        return formatter
    }
    
    var fullDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "uk_UA")
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: .zero)!
        return formatter
    }
    
    var calendar: Calendar {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "uk_UA")
        calendar.firstWeekday = 2
        calendar.timeZone = TimeZone(secondsFromGMT: .zero)!
        return calendar
    }
}
