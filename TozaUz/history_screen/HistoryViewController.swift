//
//  HistoryViewController.swift
//  TozaUz
//
//  Created by Mekhriddin Jumaev on 03/07/24.
//

import UIKit

class HistoryViewController: UIViewController, CalendarViewDelegate {
    func didTapCalendar(selectedDate: Date, isFrom: Bool) {
        if isFrom {
            fromDate = selectedDate
        } else {
            toDate = selectedDate
        }
    }
    
    let calendar = Calendar.current

    lazy var fromDate = calendar.date(byAdding: .month, value: -1, to: Date()) ?? Date() {
        didSet {
            TopView.fromDateLabel.text = formatDateToString(date: fromDate)
            count = 0
            results = []
            showLoadingView()
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                self.fetchMobileEarning(page: self.page)
            }
        }
        
    }
    
    func formatDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
        
    
    var toDate = Date() {
        didSet {
            TopView.toDateLabel.text = formatDateToString(date: toDate)
            count = 0
            results = []
            showLoadingView()
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                self.fetchMobileEarning(page: self.page)
            }
        }
    }
    
    var count: Int = 0
    
    var page: Int = 1
    
    var results = [MobileEarning]() {
        didSet {
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
            }
        }
    }
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    let TopView = TopCalendarView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 85))

    lazy var mainTableView: UITableView = {
        let tableView = UITableView()
        TopView.delegate = self
        tableView.tableHeaderView = TopView
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(PayoutTableViewCell.self, forCellReuseIdentifier: String.init(describing: PayoutTableViewCell.self))
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "history_tran".translate()
        initViews()
        
        showLoadingView()
        TopView.fromDateLabel.text = formatDateToString(date:  fromDate)
        TopView.toDateLabel.text = formatDateToString(date:  Date())
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.fetchMobileEarning(page: self.page)
        }
    }

    
    private func initViews() {
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(mainTableView)
        mainTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func fetchMobileEarning(page: Int) {
        TozaAPI.shared.getMobileEarningList(startDate: formatDateToString(date: fromDate), endDate: formatDateToString(date: toDate), page: page) { [weak self] result in
            guard let self = self else { return }
            self.dissmissLoadingView()
            switch result {
            case .success(let response):
                print("Mobile earning list response: \(response)")
                self.results += response.results
                self.count = response.count
                if let nextURL = response.next {
               
                    // Perform next page request if needed
                    print("Next page URL: \(nextURL)")
                }
            case .failure(let error):
                print("Failed to get mobile earning list: \(error)")
            }
        }
    }

}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: PayoutTableViewCell.self), for: indexPath) as? PayoutTableViewCell else { return UITableViewCell() }
        let result = results[indexPath.row]
        cell.amountDesLabel.text = String(result.amount) + " so'm"
        cell.cardDesLabel.isHidden = true
        cell.nameDesLabel.text = String(result.tarrif)
        
        
        if let formattedDate = result.createdAt.toFormattedDate() {
            cell.dateDesLabel.text = formattedDate
        } else {
          print("Error: Invalid date format")
        }
        

        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
            print("XXX", count, results.count, page)
            if count > results.count {
                page += 1
                DispatchQueue.global().async { [weak self] in
                    guard let self = self else { return }
                    self.fetchMobileEarning(page: self.page)
                }
            }
        }
    }
}

extension HistoryViewController: TopCalendarViewDelegate {
    func fromTapped() {
        let vc = CalendarViewController()
        vc.selectedDate = fromDate
        vc.isFrom = true
        vc.delegate = self
        navigationController?.presentPanModal(vc)
    }
    
    func toTapped() {
        let vc = CalendarViewController()
        vc.isFrom = false
        vc.delegate = self
        vc.selectedDate = toDate
        navigationController?.presentPanModal(vc)
    }
}

protocol TopCalendarViewDelegate: AnyObject {
    func fromTapped()
    func toTapped()
}

class TopCalendarView: UIView {
    
    weak var delegate: TopCalendarViewDelegate?
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var fromView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ProfileColor")
        view.applyShadow()
        view.layer.cornerRadius = 22
        return view
    }()
    
    lazy var calendarImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = AppColors.mainColor
        return imageView
    }()
    
    lazy var calendarImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = AppColors.mainColor
        return imageView
    }()
    
    lazy var fromDesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "from".translate()
        label.textColor = .gray
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var fromDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.text = "2024.04.23"
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    
    lazy var toDesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "to".translate()
        label.textColor = .gray
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var toDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.text = "2024.04.23"
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var toView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ProfileColor")
        view.applyShadow()
        view.layer.cornerRadius = 22
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        
        fromView.addPressAnimation() {
            self.delegate?.fromTapped()
        }
        
        toView.addPressAnimation() {
            self.delegate?.toTapped()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews() {
        self.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(fromView)
        fromView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(self.snp.centerX).offset(-5)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-15)
            make.height.equalTo(60)
        }
        
        fromView.addSubview(calendarImageView1)
        calendarImageView1.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.height.width.equalTo(25)
        }
        
        fromView.addSubview(fromDesLabel)
        fromDesLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalTo(calendarImageView1.snp.right).offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        
        
        fromView.addSubview(fromDateLabel)
        fromDateLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-15)
            make.left.equalTo(calendarImageView1.snp.right).offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        
        subView.addSubview(toView)
        toView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.left.equalTo(self.snp.centerX).offset(5)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-15)
            make.height.equalTo(60)
        }
        
        toView.addSubview(calendarImageView2)
        calendarImageView2.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.height.width.equalTo(25)
        }
        
        toView.addSubview(toDesLabel)
        toDesLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalTo(calendarImageView2.snp.right).offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        
        toView.addSubview(toDateLabel)
        toDateLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-15)
            make.left.equalTo(calendarImageView2.snp.right).offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        
    }
}
