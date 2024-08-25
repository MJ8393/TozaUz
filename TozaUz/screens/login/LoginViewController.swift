//
//  LoginViewController.swift
//  TozaUz
//
//  Created by Mekhriddin Jumaev on 29/06/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.dataSource = self
        tableView.register(LoginTableViewCell.self, forCellReuseIdentifier: String.init(describing: LoginTableViewCell.self))
        tableView.separatorStyle = .none
//        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    lazy var mainButton: MainButton = {
        let button = MainButton(title: "continue".translate())
//        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "login".translate()
        navigationController?.navigationBar.prefersLargeTitles = true
        initViews()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tap)
        
        mainButton.addPressAnimation() { [weak self] in
            guard let self = self else { return }
            self.loginTapped()
        }
    }
    
    @objc func loginTapped() {
        
        if let cell = mainTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? LoginTableViewCell {
            
            let phoneName = cell.phoneTextField.text ?? ""
            let password = cell.passwordTextField.text ?? ""
            
            let phoneNumber = phoneName.replacingOccurrences(of: " ", with: "")

            if phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty {
                showAlert(message: "check_phone_num".translate())
            } else if password.trimmingCharacters(in: .whitespaces).isEmpty {
                showAlert(message: "check_password".translate())
            } else if password.trimmingCharacters(in: .whitespaces).count < 3 {
                showAlert(message: "check_pass_action".translate())
            } else {
                showLoadingView()
                TozaAPI.shared.authenticateUser(phoneNumber: phoneNumber, password: password) { [weak self] result in
                    guard let self = self else { return }
                    self.dissmissLoadingView()
                    switch result {
                    case .success(let authResponse):
                        print("Authentication successful: \(authResponse)")
                        UD.token = authResponse.token
                        UD.password = password
                        self.setPasswordScreen()
                        UD.isLoginMode = "n"
                    case .failure(let error):
                        self.showAlert(message: "no_such_user".translate())
                        print("Failed to authenticate user: \(error.localizedDescription)")
                    }
                }
            }
        }
    
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    @objc func loginLaterTapped() {
         print("Login later button tapped")
        UD.isLoginMode = "y"
        let newRootViewController = MainTabBarController()
        if let sceneDelegate = SceneDelegate.shared {
            sceneDelegate.window?.rootViewController = newRootViewController
        }
     }
    
    private func initViews() {
        
        let loginLaterButton = UIButton(type: .system)
        loginLaterButton.setTitle("login_later".translate(), for: .normal)
        loginLaterButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium) // Set the text to bold
               loginLaterButton.addTarget(self, action: #selector(loginLaterTapped), for: .touchUpInside)
               
               // Create a UIBarButtonItem with the custom UIButton
               let barButtonItem = UIBarButtonItem(customView: loginLaterButton)
               
               // Set the button to the right side of the navigation bar
               navigationItem.rightBarButtonItem = barButtonItem
        
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

extension LoginViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: LoginTableViewCell.self), for: indexPath) as? LoginTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    
}

extension LoginViewController: LoginTableViewCellDelegate {
    func forgotPassTapped() {
        view.endEditing(true)
        let vc = ForgotPassViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func registerButtonTapped() {
        view.endEditing(true)
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}


import UIKit

extension UIViewController {
    func getBottomSafeAreaHeight() -> CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows.first
            let topPadding = window!.safeAreaInsets.top
            let bottomPadding = window!.safeAreaInsets.bottom
            return bottomPadding
        } else {
            return 0.0
        }
    }
    
    func setNewRootViewController() {
        let newRootViewController = MainTabBarController()
        if let sceneDelegate = SceneDelegate.shared {
            sceneDelegate.window?.rootViewController = newRootViewController
        }
    }
    
    func setPasswordScreen() {
        let newRootViewController = PasswordViewController()
        newRootViewController.pinCodeType = .first
        if let sceneDelegate = SceneDelegate.shared {
            sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: newRootViewController)
        }
    }
}

