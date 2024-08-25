//
//  RecoverPassViewController.swift
//  TozaUz
//
//  Created by Mekhriddin Jumaev on 25/08/24.
//

import UIKit

class RecoverPassViewController: UIViewController {
    
    var phoneNumber: String = ""

    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.dataSource = self
        tableView.register(RecoverPassCell.self, forCellReuseIdentifier: String.init(describing: RecoverPassCell.self))
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
        
        title = "Recover_Password_title".translate()
        view.backgroundColor = .systemBackground
        initViews()
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tap)
        
        
        mainButton.addPressAnimation() { [weak self] in
            guard let self = self else { return }
            if let cell = mainTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? RecoverPassCell {
                
                TozaAPI.shared.verifyForgotPassword(phone: phoneNumber.replacingOccurrences(of: " ", with: ""), otp: cell.smsTextField.text ?? "", newPassword: cell.passwordTextField.text ?? "") { result in
                    switch result {
                    case .success(let string):
                        let alertController = UIAlertController(title: "sucessful".translate(), message: "register_action_srfdf".translate(), preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "ok".translate(), style: .default, handler: { _ in
                            self.navigationController?.popViewController(animated: true)
                            self.navigationController?.popViewController(animated: true)
                        })
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true) {
                        }
                    case .failure(let error):
                        self.showAlert(message: "failure".translate())
                        print("Failed to register user: \(error)")
                    }
                }
            }
       
//            let vc = RecoverPassViewController()
//            navigationController?.pushViewController(vc, animated: true)
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

extension RecoverPassViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: RecoverPassCell.self), for: indexPath) as? RecoverPassCell else { return UITableViewCell() }
        cell.selectionStyle = .none
//        cell.delegate = self
        return cell
    }
    
    
}
