//
//  ChancePassViewController.swift
//  TozaUz
//
//  Created by Mekhriddin Jumaev on 03/07/24.
//

import UIKit

class ChancePassViewController: UIViewController {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.dataSource = self
        tableView.register(ChangePasswordTableViewCell.self, forCellReuseIdentifier: String.init(describing: ChangePasswordTableViewCell.self))
        tableView.separatorStyle = .none
//        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    lazy var mainButton: MainButton = {
        let button = MainButton(title: "changePAssword".translate())
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .label
        title = "changePAssword".translate()
        navigationController?.navigationBar.prefersLargeTitles = false
        initViews()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tap)
        
        mainButton.addPressAnimation { [weak self] in
            guard let self = self else { return }
            view.endEditing(true)
            
            if let cell = mainTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ChangePasswordTableViewCell {
                
                let oldPassword = cell.passwordTextField1.text ?? ""
                let newPassword = cell.passwordTextField.text ?? ""
       
                if oldPassword.trimmingCharacters(in: .whitespaces).isEmpty {
                    showAlert(message: "check_info_action".translate())
                } else if newPassword.trimmingCharacters(in: .whitespaces).isEmpty {
                    showAlert(message: "check_info_action".translate())
                } else if newPassword.trimmingCharacters(in: .whitespaces).count < 3 {
                    showAlert(message: "check_pass_action".translate())
                } else {
                    showLoadingView()
                    TozaAPI.shared.updateUserPassword(oldPassword: oldPassword, newPassword: newPassword) { [weak self] result in
                        guard let self = self else { return }
                        self.dissmissLoadingView()
                        switch result {
                        case .success(_):
                            let alertController = UIAlertController(title: "sucessful".translate(), message: "password_change_success".translate(), preferredStyle: .alert)
                                   let okAction = UIAlertAction(title: "Tushinarli", style: .default) { _ in
                                       self.navigationController?.popViewController(animated: true)
                                   }
                                   alertController.addAction(okAction)
                                   present(alertController, animated: true, completion: nil)
                        case .failure(let error):
                            self.showAlert(message: "old_pass_incorrect".translate())
                            print("Failed to authenticate user: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
    
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    private func initViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(mainTableView)
        subView.addSubview(mainButton)

        mainTableView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(mainButton.snp.top)
        }
        
        mainButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20 - getBottomSafeAreaHeight())
            make.height.equalTo(60)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            
            mainButton.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(-keyboardHeight - 10.0)
                // Add other constraints for the button if needed
            }
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        mainButton.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(-20 - getBottomSafeAreaHeight())
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

}

extension ChancePassViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: ChangePasswordTableViewCell.self), for: indexPath) as? ChangePasswordTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        return cell
    }
    
    
}
