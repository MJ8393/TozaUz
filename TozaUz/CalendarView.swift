//
//  CalendarViewController.swift
//  Calendar
//
//  Created by Mekhriddin on 08/07/22.
//

protocol CalendarViewDelegate: AnyObject {
    func didTapCalendar(selectedDate: Date, isFrom: Bool)
}

import UIKit
import PanModal

class CalendarViewController: UIViewController {
    var isFrom: Bool = false
    
    var selectedIndex: Int?
    var selectedMonth: String?
    var selectedYear: String?
    
    weak var delegate: CalendarViewDelegate?
    
    lazy var calendarView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Июнь"
        label.font = UIFont.systemFont(ofSize: 17.5 * RatioCoeff.width)
        label.textAlignment = .center
        return label
    }()
    
    lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14 * RatioCoeff.width)
        label.text = "2022"
        label.textAlignment = .center
        return label
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrow-down-sign-to-navigate (1)")?.withRenderingMode(.alwaysOriginal).withTintColor(.label), for: .normal)
        button.tintColor = .label
        button.layer.cornerRadius = 36 * RatioCoeff.width / 2.0
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.label.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
        return button
    }()
    
    @objc func nextMonth() {
        selectedDate = CalendarHelper().plusMonth(date: selectedDate)
        setMonthView()
    }
    
    lazy var leftButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrow-down-sign-to-navigate")?.withRenderingMode(.alwaysOriginal).withTintColor(.label), for: .normal)
        button.tintColor = .label
        button.layer.cornerRadius = 36 * RatioCoeff.width / 2.0
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.label.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(previousMonth), for: .touchUpInside)
        return button
    }()
    
    lazy var topLine: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.backgroundColor = .white
        return view
    }()
    

    @objc func previousMonth() {
        selectedDate = CalendarHelper().minusMonth(date: selectedDate)
        setMonthView()
    }
    
    let day1 = CalendarLabel(text: "Пн")
    let day2 = CalendarLabel(text: "Вт")
    let day3 = CalendarLabel(text: "Ср")
    let day4 = CalendarLabel(text: "Чт")
    let day5 = CalendarLabel(text: "Пт")
    let day6 = CalendarLabel(text: "Сб")
    let day7 = CalendarLabel(text: "Вс")
    
    lazy var weekDays = [day1, day2, day3, day4, day5, day6, day7]
    
    let stackView = UIStackView()
    
    var count1: Int = 0
    var count2: Int = 0
    
    private lazy var collectionView: UICollectionView = {
      let layout = UICollectionViewFlowLayout()
      layout.minimumLineSpacing = 0
      layout.minimumInteritemSpacing = 0

      let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
      collectionView.isScrollEnabled = false
      collectionView.translatesAutoresizingMaskIntoConstraints = false
      return collectionView
    }()
    
    var selectedDate = Date()
    var totalSquare = [String]()
    var dates = [Date]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedMonth = CalendarHelper().monthString(date: selectedDate)
        selectedYear = CalendarHelper().yearString(date: selectedDate)
        view.backgroundColor = .clear
        
        configure()
        configureCollectionView()
        setMonthView()
        self.touchView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPressed)))
    }
    
    @objc func viewPressed() {
        dismiss(animated: true)
    }
    
    let touchView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setMonthView() {
        totalSquare.removeAll()
        dates.removeAll()
        
        let daysInMonth = CalendarHelper().daysInMonth(date: selectedDate)
        let firstDayOfMonth = CalendarHelper().firstDayOfMonth(date: selectedDate)
        let startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth)
        
        // last day of previous month
        let lastDateOfPrevious = CalendarHelper().LastDayOfPreviousMonth(date: firstDayOfMonth)
        var lastDayOfPrevious = CalendarHelper().daysOfMonth(date: lastDateOfPrevious)
        
        
        var count: Int = 1
        var previousCount = 0
        var nextMonthCount = 1
        var count3 = 0
        while(count <= 42) {
            if(count <= startingSpaces) {
                totalSquare.append("")
                dates.append(Date())

                previousCount += 1
            } else if count - startingSpaces > daysInMonth {
                totalSquare.append(String(nextMonthCount))
                dates.append(CalendarHelper().nextDay(date: firstDayOfMonth, next: daysInMonth + nextMonthCount - 1))
                nextMonthCount += 1
            } else {
                totalSquare.append(String(count - startingSpaces))
                dates.append(CalendarHelper().nextDay(date: firstDayOfMonth, next: count3))
                if CalendarHelper().daysOfMonth(date: selectedDate) == count - startingSpaces {              // ****************
                    selectedIndex = count - 1
                }
                count3 += 1
            }
            count += 1
        }
        
        count1 = previousCount
        count2 = nextMonthCount
        var count4 = 0
        
        while(previousCount > 0) {
            totalSquare[previousCount - 1] = String(lastDayOfPrevious)
            dates[previousCount - 1] = CalendarHelper().nextDay(date: firstDayOfMonth, next: -count4 - 1)
            lastDayOfPrevious -= 1
            previousCount -= 1
            count4 += 1
        }
        
        monthLabel.text = CalendarHelper().monthString(date: selectedDate)
        yearLabel.text = CalendarHelper().yearString(date: selectedDate)
        collectionView.reloadData()
    }
    
    private func configureCollectionView() {
        
        collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.reuseID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.layer.cornerRadius = 20
    }

    private func configure() {
        view.addSubview(calendarView)
        view.addSubview(touchView)
        calendarView.addSubview(monthLabel)
        calendarView.addSubview(yearLabel)
        calendarView.addSubview(rightButton)
        calendarView.addSubview(leftButton)
        calendarView.addSubview(collectionView)
        calendarView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution  = .fillEqually

        for i in 0...6 {
            stackView.addArrangedSubview(weekDays[i])
        }
        
        NSLayoutConstraint.activate([
            calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calendarView.topAnchor.constraint(equalTo: view.topAnchor),
            calendarView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height / 2),
            calendarView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width),
            
            touchView.topAnchor.constraint(equalTo: view.topAnchor),
            touchView.bottomAnchor.constraint(equalTo: calendarView.topAnchor),
            touchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            touchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 16),
            stackView.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 17 * RatioCoeff.height),
            
            collectionView.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 21.6 * RatioCoeff.height),
            collectionView.bottomAnchor.constraint(equalTo: calendarView.bottomAnchor),
            
            monthLabel.topAnchor.constraint(equalTo: calendarView.topAnchor, constant: 20 * RatioCoeff.height),
            monthLabel.centerXAnchor.constraint(equalTo: calendarView.centerXAnchor),
            monthLabel.heightAnchor.constraint(equalToConstant: 18 * RatioCoeff.height),
            monthLabel.widthAnchor.constraint(equalToConstant: 180),
            
            yearLabel.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 5),
            yearLabel.centerXAnchor.constraint(equalTo: monthLabel.centerXAnchor),
            yearLabel.heightAnchor.constraint(equalToConstant: 14.5 * RatioCoeff.height),
            yearLabel.widthAnchor.constraint(equalToConstant: 40),
            
            leftButton.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor, constant: 16),
            leftButton.topAnchor.constraint(equalTo: calendarView.topAnchor, constant: 22 * RatioCoeff.height),
            leftButton.heightAnchor.constraint(equalToConstant: 36 * RatioCoeff.width),
            leftButton.widthAnchor.constraint(equalToConstant: 36 * RatioCoeff.width),
            
            rightButton.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor, constant: -16),
            rightButton.topAnchor.constraint(equalTo: calendarView.topAnchor, constant: 22 * RatioCoeff.height),
            rightButton.heightAnchor.constraint(equalToConstant: 36 * RatioCoeff.width),
            rightButton.widthAnchor.constraint(equalToConstant: 36 * RatioCoeff.width),
        ])
        
    }
    
    @objc func doSomething() {
    }
}


extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.reuseID, for: indexPath) as! CalendarCollectionViewCell
        
        cell.set(text: totalSquare[indexPath.item], backgroundColor: UIColor.systemBackground)
        
        if indexPath.item < count1 || indexPath.item > 42 - count2 {
            cell.monthLabel.textColor = .systemGray
        } else {
            cell.monthLabel.textColor = .label
        }
        
        if indexPath.item == selectedIndex && selectedMonth == monthLabel.text && selectedYear == yearLabel.text {
            cell.monthLabel.textColor = .white
            cell.set(text: totalSquare[indexPath.item], backgroundColor: AppColors.mainColor)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doSomething))
        cell.addGestureRecognizer(tap)

        tap.cancelsTouchesInView = false
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalSquare.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = dates[indexPath.item]
        selectedIndex = indexPath.item
        selectedMonth = CalendarHelper().monthString(date: selectedDate)
        selectedYear = CalendarHelper().yearString(date: selectedDate)
        collectionView.reloadData()
        delegate?.didTapCalendar(selectedDate: selectedDate, isFrom: isFrom)
        self.dismiss(animated: true)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension CalendarViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = Int(collectionView.frame.width / 7)
    let height = Int(collectionView.frame.height) / 7
    return CGSize(width: width, height: height)
  }
}



public struct AnchoredConstraints {
    public var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}


let SCREEN_SIZE = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
let originalDesignSize = CGSize(width: 375, height: 667)

struct RatioCoeff {
    static let width = SCREEN_SIZE.width / originalDesignSize.width
    static let height = SCREEN_SIZE.height / originalDesignSize.height
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

extension UIView {
    @discardableResult
    open func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        
        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        
        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        if size.width != 0 {
            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
        }
        
        if size.height != 0 {
            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        
        [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach { $0?.isActive = true }
        
        return anchoredConstraints
    }
}

extension CalendarViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
          return nil
      }
    
    var longFormHeight: PanModalHeight {
        print("XXX", UIScreen.main.bounds.height)
        if UIScreen.main.bounds.height <= 700 {
            return .contentHeight(CGFloat(UIScreen.main.bounds.height / 2.0 - 30.0))
        }
        return .contentHeight(CGFloat(UIScreen.main.bounds.height / 2.0 - 50.0))
    }

    var shortFormHeight: PanModalHeight {
        if UIScreen.main.bounds.height <= 700 {
            return .contentHeight(CGFloat(UIScreen.main.bounds.height / 2.0 - 30.0))
        }
        return .contentHeight(CGFloat(UIScreen.main.bounds.height / 2.0 - 50.0))
    }

    var cornerRadius: CGFloat {
        return 22
    }

    var panModalBackgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.5)
    }
}


// fuck
class CustomBarButtonView: UIView {
    
    var buttonAction: (() -> Void)?
    
    lazy var customButton: BaseButton = {
        let button = BaseButton()
        return button
    }()
    
    init(image: UIImage) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        customButton.backgroundColor = UIColor.clear
        customButton.layer.cornerRadius = 40 / 2
        customButton.setImage(image, for: .normal)
        customButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        customButton.imageView?.contentMode = .scaleAspectFit
        customButton.tintColor = .label
        customButton.imageView!.snp.makeConstraints { make in
            make.width.height.equalTo(22)
        }
        
        self.addSubview(customButton)
        customButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalTo(40)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonTapped() {
        self.buttonAction?()
    }
}

class CustomBuyButtonView: UIView {
    
    var buttonAction: (() -> Void)?
    
    lazy var customButton: BaseButton = {
        let button = BaseButton()
        return button
    }()
    
    init(_ title: String = "buy".translate()) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        customButton.backgroundColor = UIColor.clear
        customButton.layer.cornerRadius = 40 / 2
        customButton.setTitle(title, for: .normal)
        customButton.setTitleColor(.systemBackground, for: .normal)
        customButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        customButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        customButton.imageView?.contentMode = .scaleAspectFit
        customButton.backgroundColor = .label
        customButton.layer.cornerRadius = 12.5
//        customButton.imageView!.snp.makeConstraints { make in
//            make.height.equalTo(25)
//            make.width.equalTo(50)
//        }
        
        self.addSubview(customButton)
        customButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(25)
            
            if LanguageManager.getAppLang() == .Uzbek {
                make.width.equalTo(100)
            } else {
                make.width.equalTo(60)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonTapped() {
        self.buttonAction?()
    }
}


class BaseButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        transform = .identity
        UIView.animate(withDuration: 0.3) {
            self.transform = .identity
        }
    }
}

