//
//  PayoutHistoryViewController.swift
//  TozaUz
//
//  Created by Mekhriddin Jumaev on 03/07/24.
//

import UIKit

class PayoutHistoryViewController: UIViewController {
        
    var results = [ResultInfo]() {
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
    
    lazy var mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        tableView.register(PayoutTableViewCell.self, forCellReuseIdentifier: String.init(describing: PayoutTableViewCell.self))
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        getPayoutHistory()
        initViews()
        view.backgroundColor = .systemBackground
        title = "history_profile".translate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    
    func getPayoutHistory() {
        showLoadingView()
        
        // Dispatch work to a background queue
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            TozaAPI.shared.getPayoutHistory { result in
                DispatchQueue.main.async {
                    self.dissmissLoadingView()
                    switch result {
                    case .success(let response):
                        if let results = response.results {
                            self.results = results
                        } else {
                            self.results = []
                        }
                        
                        print("Password update info response: \(response)")
                        
                    case .failure(let error):
                        print("Failed to get password update info: \(error)")
                    }
                }
            }
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

}

extension PayoutHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: PayoutTableViewCell.self), for: indexPath) as? PayoutTableViewCell else { return UITableViewCell() }
        let result = results[indexPath.row]
        cell.amountDesLabel.text = String(result.amount) + " so'm"
        cell.cardDesLabel.text = String(result.card)
        cell.nameDesLabel.text = (result.admin.firstName ?? "") + " " + (result.admin.lastName ?? "")
        
        
        if let formattedDate = result.createdAt.toFormattedDate() {
            cell.dateDesLabel.text = formattedDate
        } else {
          print("Error: Invalid date format")
        }
        

        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
}
