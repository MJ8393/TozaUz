//
//  HomeViewController.swift
//  TozaUz
//
//  Created by Mekhriddin Jumaev on 03/07/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    var currentBalance: Int64 = 0
    
    lazy var mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: String.init(describing: HomeTableViewCell.self))
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        return tableView
    }()
    
    let refreshControl = UIRefreshControl()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "main".translate()
        navigationController?.navigationBar.tintColor = .label
        view.backgroundColor = .systemBackground
        initViews()
        getInfo()
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    @objc func refreshData() {
        getInfo()
    }
    
    func makeTrancsionRequest(amount: Int64, card: String, cardName: String) {
        TozaAPI.shared.createPayme(amount: amount, card: card, cardName: cardName) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                print("Payme create response: \(response)")
                let alertController = UIAlertController(title: "sucessful".translate(), message: "Запрос создан. Скоро рассмотрю.".translate(), preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "ok".translate(), style: .default, handler: nil)
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
            case .failure(let error):
                print("Failed to create payme: \(error)")
                self.showAlert(message: "action_on_process".translate())
            }
        }

    }
    
    func getInfo() {
        // Start refreshing UI, if needed
        DispatchQueue.global(qos: .background).async {
            TozaAPI.shared.getMeBank() { result in
                DispatchQueue.main.async { [weak self] in
                    // Stop refreshing UI on the main queue
                    self?.refreshControl.endRefreshing()
                    switch result {
                    case .success(let response):
                        if let cell = self?.mainTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? HomeTableViewCell {
                            cell.nameXXLabel.text = "balanse".translate() + ": \(response.capital ?? 0)" + "som".translate()
                            self?.currentBalance = Int64(response.capital ?? 0)
                            if let user = response.user {
                                UD.firstName = user.firstName ?? "No name"
                                UD.lastName = user.lastName ?? "No name"
                                UD.phoneNum = user.phoneNumber ?? "No phone"
                            }
                        }
                        print("Me bank response: \(response)")
                    case .failure(let error):
                        print("Failed to get me bank info: \(error)")
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: HomeTableViewCell.self), for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
}

extension HomeViewController: HomeTableViewCellDelegate {
    func continueDidTappedd() {
        if let cell = mainTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? HomeTableViewCell {
            if let amount = cell.amountTextField.text, let card = cell.cardTextField.text, let cardName = cell.nameTextField.text, let amountToTransfer = Int64(amount.replacingOccurrences(of: " ", with: "")) {
                if amount.replacingOccurrences(of: " ", with: "") == "" {
                    showAlert(message: "check_amount".translate())
                } else if card.replacingOccurrences(of: " ", with: "") == "" {
                    showAlert(message: "check_card_num".translate())
                } else if cardName.replacingOccurrences(of: " ", with: "") == "" {
                    showAlert(message: "check_full_name".translate())
                }else if amountToTransfer < 10000 {
                    showAlert(message: "amount_action_1".translate())
                }else if currentBalance < amountToTransfer {
                    showAlert(message: "amount_action_2".translate())
                } else {
                    makeTrancsionRequest(amount: amountToTransfer, card: cardName, cardName: cardName)
                }
            } else {
                showAlert(message: "check_info_action".translate())
            }
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            mainTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
   
        mainTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
