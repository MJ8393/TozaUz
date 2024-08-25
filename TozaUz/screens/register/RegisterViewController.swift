//
//  File.swift
//  TozaUz
//
//  Created by Mekhriddin Jumaev on 29/06/24.
//

import UIKit

class RegisterViewController: UIViewController {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.dataSource = self
        tableView.register(RegisterTableViewCell.self, forCellReuseIdentifier: String(describing: RegisterTableViewCell.self))
        tableView.separatorStyle = .none
//        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    lazy var mainButton: MainButton = {
        let button = MainButton(title: "continue".translate())
//        button.addTarget(self, action: #selector(continueRegisterIt), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "sign_up".translate()
        navigationController?.navigationBar.prefersLargeTitles = true
        initViews()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tap)
        
        mainButton.addPressAnimation() { [weak self] in
            guard let self = self else {return }
            self.continueRegisterIt()
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
    
    func continueRegisterIt() {
        view.endEditing(true)
        if let cell = mainTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? RegisterTableViewCell {
            
            let firstName = cell.phoneTextField.text ?? ""
            let secondtName = cell.passwordTextField.text ?? ""
            let phoneName = cell.passwordTextField2.text ?? ""
            let password = cell.passwordTextField3.text ?? ""
            
            let phoneNumber = phoneName.replacingOccurrences(of: " ", with: "")
            
            if firstName.trimmingCharacters(in: .whitespaces).isEmpty {
                showAlert(message: "check_your_name".translate())
            } else if secondtName.trimmingCharacters(in: .whitespaces).isEmpty {
                showAlert(message: "check_family_name".translate())
            } else if phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty {
                showAlert(message: "check_phone_num".translate())
            } else if password.trimmingCharacters(in: .whitespaces).isEmpty {
                showAlert(message: "check_password".translate())
            } else if password.trimmingCharacters(in: .whitespaces).count < 3 {
                showAlert(message: "check_pass_action".translate())
            } else {
                showLoadingView()
                TozaAPI.shared.registerUser(firstName: firstName, lastName: secondtName, phoneNumber: phoneNumber, password: password) { result in
                    self.dissmissLoadingView()
                    switch result {
                    case .success(let otp):
                        print("OTP: ", otp)
                        let vc = VerifyAccountVC()
                        vc.otp = otp
                        vc.phone_number = phoneNumber
                        self.navigationController?.pushViewController(vc, animated: true)
                    case .failure(let error):
                        self.showAlert(message: "error_alert_action".translate())
                        print("Failed to register user: \(error)")
                    }
                }
            }
        }
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

extension RegisterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RegisterTableViewCell.self), for: indexPath) as? RegisterTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        return cell
    }
}


extension UIViewController {
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "failure".translate(), message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "ok".translate(), style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
}
