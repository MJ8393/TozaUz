//
//  ForgotPassViewController.swift
//  TozaUz
//
//  Created by Mekhriddin Jumaev on 25/08/24.
//

import UIKit

class ForgotPassViewController: UIViewController {

    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.dataSource = self
        tableView.register(ForgetPassTableViewCell.self, forCellReuseIdentifier: String.init(describing: ForgetPassTableViewCell.self))
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var mainButton: MainButton = {
        let button = MainButton(title: "continue".translate())
//        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "forgot_pass".translate()
        view.backgroundColor = .systemBackground
        initViews()
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tap)
        
        
        mainButton.addPressAnimation() { [weak self] in
            guard let self = self else { return }
            
            if let cell = mainTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ForgetPassTableViewCell {
                self.showLoadingView()
                if let phoneNumber = cell.phoneTextField.text {
                    TozaAPI.shared.forgotPassword(phone: phoneNumber.replacingOccurrences(of: " ", with: "")) { result in
                        self.dissmissLoadingView()
                        switch result {
                        case .success(let string):
                            let vc = RecoverPassViewController()
                            vc.phoneNumber = cell.phoneTextField.text ?? ""
                            self.navigationController?.pushViewController(vc, animated: true)
                        case .failure(let error):
                            self.showAlert(message: "error_alert_action_v3".translate())
                            print("Failed to register user: \(error)")
                        }
                    }
                }
                
            }

            
//            self.loginTapped()
        }
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
    

    private func initViews() {
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
        
    }
}

extension ForgotPassViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: ForgetPassTableViewCell.self), for: indexPath) as? ForgetPassTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
//        cell.delegate = self
        return cell
    }
    
    
}
