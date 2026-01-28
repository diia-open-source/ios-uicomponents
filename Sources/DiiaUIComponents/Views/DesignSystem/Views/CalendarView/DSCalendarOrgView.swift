
import Foundation
import UIKit
import DiiaCommonTypes
import Lottie

/// design_system_code: DSCalendarOrg

public final class DSCalendarOrgView: BaseCodeView, DSInputComponentProtocol {
    private let legendView = DSLegendMlcView()
    private let currentTimeMlcView = DSCurrentTimeMlcView()
    private let backBtn = ActionButton(type: .icon)
    private let forwardBtn = ActionButton(type: .icon)
    private let stubMsgBoxView = BoxView(subview: StubMessageViewV2()).withConstraints(insets: Constants.stubPadding)
    private let pagginationMsgView = BoxView(subview: DSPaginationMessageMlcView()).withConstraints(centeredX: true, centeredY: true)
    private let calendarStack = UIStackView.create(spacing: Constants.calendarSpacing, distribution: .fillEqually)
    private let chipsView = DSCalendarChipsView()
    private let chipsViewV2 = DSChipGroupOrgV2View()
    private lazy var globalStackView = UIStackView.create(views: [legendView, chipsView, chipsViewV2])
    private var fullCalendarStackCornerView: UIView?

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
        box.withConstraints(size: Constants.loadingSize, centeredX: true, centeredY: true)
        return box
    }()
    
    private var imageProvider = UIComponentsConfiguration.shared.imageProvider
    private var viewModel: DSCalendarOrgViewModel?
    private var selectedCalendarItem: DSCalendarItemViewModel?
    private var calendarMode: Calendar.Component = .month
    
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
        let fullCalendarStackCornerView = BoxView(subview: fullCalendarStack)
        fullCalendarStackCornerView.backgroundColor = .white
        self.fullCalendarStackCornerView = fullCalendarStackCornerView

        globalStackView.insertArrangedSubview(fullCalendarStackCornerView, at: 1)

        addSubview(globalStackView)
        globalStackView.fillSuperview()

        addSubview(stubMsgBoxView)
        stubMsgBoxView.anchor(top: calendarBoxView.topAnchor,
                           leading: globalStackView.leadingAnchor,
                           bottom: calendarBoxView.bottomAnchor,
                           trailing: globalStackView.trailingAnchor)
        stubMsgBoxView.backgroundColor = .white
        stubMsgBoxView.isHidden = true
        
        addSubview(pagginationMsgView)
        pagginationMsgView.anchor(top: calendarBoxView.topAnchor,
                           leading: globalStackView.leadingAnchor,
                           bottom: calendarBoxView.bottomAnchor,
                           trailing: globalStackView.trailingAnchor)
        pagginationMsgView.backgroundColor = .white
        pagginationMsgView.isHidden = true
        
        addSubview(animationView)
        
        animationView.anchor(top: fullCalendarStack.topAnchor,
                             leading: fullCalendarStack.leadingAnchor,
                             bottom: fullCalendarStack.bottomAnchor,
                             trailing: fullCalendarStack.trailingAnchor)
        let animationHeight = animationView.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.defaultCalendarHeight)
        animationHeight.priority = .defaultHigh
        animationHeight.isActive = true
        
        animationView.isHidden = true
        
        backBtn.tintColor = .black
        forwardBtn.tintColor = .black
        
        backBtn.contentHorizontalAlignment = .center
        forwardBtn.contentHorizontalAlignment = .center
    }
    
    public func configure(for viewModel: DSCalendarOrgViewModel) {
        let spacing = viewModel.isOldVersion ? Constants.viewPadding : Constants.viewPaddingV2
        globalStackView.spacing = spacing

        let cornerRadius = viewModel.isOldVersion ? Constants.cornerRadius : Constants.cornerRadiusV2
        stubMsgBoxView.layer.cornerRadius = cornerRadius
        pagginationMsgView.layer.cornerRadius = cornerRadius
        fullCalendarStackCornerView?.layer.cornerRadius = cornerRadius

        legendView.isHidden = viewModel.legends == nil
        if let legend = viewModel.legends?.first(where: {$0.type == .initial}) {
            legendView.configure(with: .init(componentId: legend.componentId, label: legend.label))
        } else {
            legendView.isHidden = true
        }
        self.viewModel = viewModel
        if let currentTimeMlc = viewModel.calendarOrg.value.currentTimeMlc {
            currentTimeMlcView.configure(for: currentTimeMlc)
        }
        if let backBtnModel = viewModel.calendarOrg.value.iconForMovingBackwards {
            configureForwardButton(with: backBtnModel)
        }
        if let forwardBtnModel = viewModel.calendarOrg.value.iconForMovingForward {
            configureForwardButton(with: forwardBtnModel)
        }
        let currentDateTap = UITapGestureRecognizer(target: self, action: #selector(monthsConfigure))
        currentTimeMlcView.addGestureRecognizer(currentDateTap)
        
        selectedCalendarItem = nil
        
        viewModel.eventHandler?(.calendarAction(event: .onAppear, viewModel: viewModel))
        configureCalendar()
        
        configureObservers(for: viewModel)
    }
    
    private func configureObservers(for viewModel: DSCalendarOrgViewModel) {
        self.viewModel?.isLoading.removeObserver(observer: self)
        viewModel.isLoading.observe(observer: self) { [weak self] isLoading in
            guard let self else { return }
            self.updateLoading(to: isLoading)
        }
        
        self.viewModel?.calendarOrg.removeObserver(observer: self)
        viewModel.calendarOrg.observe(observer: self) { [weak self] calendarModel in
            guard let self else { return }
            self.stubMsgBoxView.isHidden = true
            self.pagginationMsgView.isHidden = true
            if let backBtnModel = calendarModel.iconForMovingBackwards {
                self.configureBackwardButton(with: backBtnModel)
            }
            if let forwardBtnModel = calendarModel.iconForMovingForward {
                self.configureForwardButton(with: forwardBtnModel)
            }
            self.configureCalendar()
        }
        self.viewModel?.stubMessage.removeObserver(observer: self)
        viewModel.stubMessage.observe(observer: self) { [weak self] stubMessageMlc in
            guard let self else { return }
            if let stubMessageMlc {
                let viewModel = StubMessageViewModel(model: stubMessageMlc)
                self.stubMsgBoxView.subview.configure(with: viewModel)
            }
            self.stubMsgBoxView.isHidden = stubMessageMlc == nil
        }
        self.viewModel?.paginationMessage.removeObserver(observer: self)
        viewModel.paginationMessage.observe(observer: self) { [weak self] paginationMessageMlc in
            guard let self else { return }
            if let paginationMessageMlc {
                self.pagginationMsgView.subview.configure(with: paginationMessageMlc)
                if let eventHandler = self.viewModel?.eventHandler {
                    self.pagginationMsgView.subview.setEventHandler(eventHandler)
                }
            }
            self.pagginationMsgView.isHidden = paginationMessageMlc == nil
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
            if let selectedDate,
               let calendarItem = self.viewModel?.calendarOrg.value.items.first(where: {
                   $0.calendarItemOrg.date == self.fullDateFormatter.string(from: selectedDate)
               })?.calendarItemOrg {
                if let chipsGroupOrg = calendarItem.chipGroupOrg {
                    self.chipsView.isHidden = false
                    self.chipsView.configure(for: chipsGroupOrg,
                                             chipSelectedCallback: { [weak self] selectedData in
                        self?.viewModel?.selectedChipData.value = selectedData
                    })
                } else if let chipBlackOrg = calendarItem.chipGroupOrgV2 {
                    self.chipsViewV2.isHidden = false
                    self.chipsViewV2.configure(for: chipBlackOrg,
                                               chipSelectedCallback: { [weak self] selectedData in
                        self?.viewModel?.selectedChipData.value = selectedData
                    })
                }
            } else {
                self.chipsView.configure()
                self.chipsView.isHidden = self.viewModel?.isOldVersion == false
                self.chipsViewV2.isHidden = true
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
        forwardBtn.action = Action(image: imageProvider.imageForCode(imageCode: model.code),
                                   callback: {[weak self] in
            self?.changePeriod(reduce: true, for: model.action?.resource)
        })
        forwardBtn.isEnabled = model.isEnable ?? true
        forwardBtn.accessibilityLabel = model.accessibilityDescription
    }
    
    private func configureBackwardButton(with model: DSIconModel) {
        backBtn.action = Action(image: imageProvider.imageForCode(imageCode: model.code),
                                callback: {[weak self] in
            self?.changePeriod(reduce: false, for: model.action?.resource)
        })
        backBtn.isEnabled = model.isEnable ?? true
        backBtn.accessibilityLabel = model.accessibilityDescription
    }
    
    private func configureCalendar() {
        guard let viewModel = viewModel else { return }
        var selectedPeriod = Date()
        if let date = viewModel.selectedPeriod.value {
            selectedPeriod = date
        } else if let displayMonthStr = viewModel.calendarOrg.value.currentTimeMlc?.displayMonth,
                  let displayMonth = Constants.monthYearFormatter.date(from: displayMonthStr) {
            selectedPeriod = displayMonth
        }
        let availableItems = self.viewModel?.calendarOrg.value.items
        
        calendarStack.safelyRemoveArrangedSubviews()
        setupHeader()
        
        var dateIteration = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedPeriod))!
        dateIteration = calendar.date(byAdding: .day, value: -1, to: dateIteration)!
        let firstWeekDay = calendar.component(.weekday, from: dateIteration)
        
        repeat {
            let weekStackView = UIStackView.create(.horizontal,
                                                   spacing: Constants.horizontalSpacing,
                                                   distribution: .fillEqually)
            if calendarStack.arrangedSubviews.count == 1 {
                (1..<firstWeekDay).forEach({_ in weekStackView.addArrangedSubview(UIView())})
            }
            repeat {
                dateIteration = calendar.date(byAdding: .day, value: 1, to: dateIteration)!
                let calendarItem = availableItems?.first(where: {
                    $0.calendarItemOrg.date == fullDateFormatter.string(from: dateIteration)
                })
                let isAvailable = calendarItem != nil
                let dayItem = createDayItem(
                    date: dateIteration,
                    isAvailable: isAvailable,
                    legendType: calendarItem?.calendarItemOrg.legendType)
                weekStackView.addArrangedSubview(dayItem)
            } while calendar.isDate(dateIteration,
                                    equalTo: calendar.date(byAdding: .day, value: 1, to: dateIteration)!,
                                    toGranularity: .weekOfMonth)
            let weekdays = calendar.shortWeekdaySymbols
            if weekStackView.arrangedSubviews.count < weekdays.count {
                let daysAfter = weekdays.count - weekStackView.arrangedSubviews.count
                (0..<daysAfter).forEach({_ in weekStackView.addArrangedSubview(UIView())})
            }
            calendarStack.addArrangedSubview(weekStackView)
        } while calendar.isDate(dateIteration,
                                equalTo: calendar.date(byAdding: .day, value: 1,
                                                       to: dateIteration)!, toGranularity: .month)
    }
    
    private func createDayItem(date: Date, isAvailable: Bool, legendType: DSLegendType? = nil) -> UIView {
        let calendarItem = DSCalendarItemOrgView()
        let viewModel = DSCalendarItemViewModel(
            itemOrg: .init(date: fullDateFormatter.string(from: date),
                           calendarItemAtm: .init(label: dateFormatter.string(from: date),
                                                  isActive: isAvailable,
                                                  isToday: calendar.isDateInToday(date)),
                           legendType: legendType))
        viewModel.onChange = { [weak self] isSelected in
            guard isSelected, self?.selectedCalendarItem != viewModel else { return }
            self?.selectedCalendarItem?.isSelected = false
            self?.selectedCalendarItem = viewModel
            self?.viewModel?.selectedDate.value = self?.fullDateFormatter.date(from: viewModel.itemOrg?.date ?? "")
            if let legendType = viewModel.itemOrg?.legendType,
               let legendMlc = self?.viewModel?.legends?.first(where: {$0.type == legendType}) {
                self?.legendView.configure(
                    with: .init(componentId: legendMlc.componentId,
                                label: legendMlc.label)
                )
            }
        }
        calendarItem.configure(for: viewModel)
        return calendarItem
    }
    
    @objc public func monthsConfigure() {
        guard let viewModel = viewModel else { return }
        let selectedPeriod = viewModel.selectedPeriod.value ?? Date()
        
        calendarStack.safelyRemoveArrangedSubviews()
        
        chipsView.isHidden = true
        chipsViewV2.isHidden = true
        
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
        if let maxDateStr = viewModel?.calendarOrg.value.currentTimeMlc?.maxDate,
           let maxDate = Constants.monthYearFormatter.date(from: maxDateStr) {
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
        
        if let currentTimeMlc = viewModel.calendarOrg.value.currentTimeMlc {
            currentTimeMlcView.configure(for: currentTimeMlc)
        } else {
            let currentTime = selectedPeriod.monthStr.capitalized + " \(calendar.component(.year, from: selectedPeriod))"
            currentTimeMlcView.configure(for: DSCurrentTimeMlc(label: currentTime))
        }
        
        configureMonthButtons(viewModel, selectedPeriod)
        
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
        
        configureYearButtons(viewModel, selectedPeriod)
    }
    
    private func configureYearButtons(_ viewModel: DSCalendarOrgViewModel, _ selectedPeriod: Date) {
        let maxDateStr = viewModel.calendarOrg.value.currentTimeMlc?.maxDate ?? ""
        let maxDateYear = Constants.monthYearFormatter.date(from: maxDateStr)?.year ?? (Date().year + 1)
        
        let minDateStr = viewModel.calendarOrg.value.currentTimeMlc?.minDate ?? ""
        let minDateYear = Constants.monthYearFormatter.date(from: minDateStr)?.year ?? Date().year
        
        let isBackAvailable = selectedPeriod.year > minDateYear
        backBtn.isEnabled = isBackAvailable
        
        let isNextAvailable = selectedPeriod.year < maxDateYear
        forwardBtn.isEnabled = isNextAvailable
    }
    
    private func configureMonthButtons(_ viewModel: DSCalendarOrgViewModel, _ selectedPeriod: Date) {
        let maxDateStr = viewModel.calendarOrg.value.currentTimeMlc?.maxDate ?? ""
        let maxDateMonth = Constants.monthYearFormatter.date(from: maxDateStr) ?? Date()
        
        let minDateStr = viewModel.calendarOrg.value.currentTimeMlc?.minDate ?? ""
        let minDateMonth = Constants.monthYearFormatter.date(from: minDateStr) ?? Date()
        
        let isBackAvailable = selectedPeriod > minDateMonth
        backBtn.isEnabled = isBackAvailable
        
        let isNextAvailable = selectedPeriod < maxDateMonth
        forwardBtn.isEnabled = isNextAvailable
    }
    
    
    private func updateLoading(to state: Bool) {
        animationView.isHidden = !state
        chipsView.isHidden = state || viewModel?.isOldVersion == false
        chipsViewV2.isHidden = true
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
        static let cornerRadiusV2: CGFloat = 16
        static let stubPadding = UIEdgeInsets(top: 64, left: 24, bottom: 0, right: 24)
        static let offset = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
        static let calendarSpacing: CGFloat = 4
        static let horizontalSpacing: CGFloat = 2
        static let monthHorizontal = 3
        static let monthVertical = 4
        static let viewPadding: CGFloat = 24
        static let viewPaddingV2: CGFloat = 8
        static var monthYearFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "uk_UA")
            formatter.dateFormat = "MM.yyyy"
            formatter.timeZone = TimeZone(identifier: "Europe/Kyiv")!
            return formatter
        }()
    }
}

private extension Date {
    var monthStr: String {
        var calendar = Calendar.current
        calendar.locale = .init(identifier: "uk_UA")
        calendar.timeZone = TimeZone(identifier: "Europe/Kyiv")!
        let names = calendar.standaloneMonthSymbols
        let month = calendar.component(.month, from: self)
        return names[month - 1]
    }
}

private extension DSCalendarOrgView {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "uk_UA")
        formatter.timeZone = TimeZone(identifier: "Europe/Kyiv")!
        formatter.dateFormat = "d"
        return formatter
    }
    
    var fullDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "uk_UA")
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.timeZone = TimeZone(identifier: "Europe/Kyiv")!
        return formatter
    }
    
    var calendar: Calendar {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "uk_UA")
        calendar.timeZone = TimeZone(identifier: "Europe/Kyiv")!
        calendar.firstWeekday = 2
        return calendar
    }
}
