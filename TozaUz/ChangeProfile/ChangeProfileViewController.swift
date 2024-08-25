//
//  ChangeProfileViewController.swift
//  TozaUz
//
//  Created by Mekhriddin Jumaev on 25/08/24.
//

import UIKit

protocol ChangeProfileViewControllerDelegate: AnyObject {
    func profileViewDataChanged()
}

class ChangeProfileViewController: UIViewController {
    
    var phoneNumber: String = ""
    
    weak var delegate: ChangeProfileViewControllerDelegate?

    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.dataSource = self
        tableView.register(ChangeProfileCell.self, forCellReuseIdentifier: String.init(describing: ChangeProfileCell.self))
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var mainButton: MainButton = {
        let button = MainButton(title: "save".translate())
//        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "profile_change_info".translate()
        view.backgroundColor = .systemBackground
        initViews()
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tap)
        
        
        mainButton.addPressAnimation() { [weak self] in
            guard let self = self else { return }
            view.endEditing(true)
            if let cell = mainTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ChangeProfileCell {
                
                TozaAPI.shared.updateProfile(firstName: cell.smsTextField.text ?? "", lastName: cell.passwordTextField.text ?? "") { result in
                    switch result {
                    case .success(_):
                        UD.firstName =  cell.smsTextField.text ?? ""
                        UD.lastName =  cell.passwordTextField.text ?? ""
                        self.delegate?.profileViewDataChanged()
                        let alertController = UIAlertController(title: "sucessful".translate(), message: "changel_profile_data".translate(), preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "ok".translate(), style: .default, handler: { _ in
                            self.navigationController?.popViewController(animated: true)
                        })
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true) {
                        }
                    case .failure(let error):
                        print("Erroro onsd sgdsfgd")
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

extension ChangeProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: ChangeProfileCell.self), for: indexPath) as? ChangeProfileCell else { return UITableViewCell() }
        cell.selectionStyle = .none
//        cell.delegate = self
        return cell
    }
    
    
}
