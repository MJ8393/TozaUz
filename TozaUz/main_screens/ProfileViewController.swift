//
//  ProfileViewController.swift
//  TozaUz
//
//  Created by Mekhriddin Jumaev on 01/07/24.
//

import UIKit

class ProfileViewController: UIViewController, ChangeProfileViewControllerDelegate {
    func profileViewDataChanged() {
        DispatchQueue.main.async {
            if let cell = self.mainTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileTableViewCell {
                cell.nameLabel.text =  "\(UD.firstName ?? "") \(UD.lastName ?? "")"
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
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: String.init(describing: ProfileTableViewCell.self))
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "profile".translate()
        navigationController?.navigationBar.tintColor = .label
        view.backgroundColor = .systemBackground
        initViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
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

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: ProfileTableViewCell.self), for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
}

extension ProfileViewController: ProfileTableViewCellDelegate {
    func gotoJarima() {
        let vc = JarimaViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func changeProfile() {
        let vc = ChangeProfileViewController()
        vc.delegate = self
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func logout() {
        
        if UD.isLoginMode == "y" {
            self.goLoginPage()
            UD.token = ""
        } else {
            let alertController = UIAlertController(title: "attention".translate(), message: "are_you_sure_log_out".translate(), preferredStyle: .alert)
            let logoutAction = UIAlertAction(title: "go_out_guck".translate(), style: .destructive) { (action) in
                self.goLoginPage()
                UD.token = ""
            }
            let cancelAction = UIAlertAction(title: "cancel".translate(), style: .cancel, handler: nil)
            alertController.addAction(logoutAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        }
        
    }
    
    func delete() {
        let alertController = UIAlertController(title: "attention".translate(), message: "are_you_sure_delete".translate(), preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: "delete".translate(), style: .destructive) { (action) in
            TozaAPI.shared.deleteUser(phoneNumber: UD.phoneNum ?? "", password: UD.password ?? "") { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let _):
                    self.goLoginPage()
                    UD.token = ""
                    UD.phoneNum = ""
                    UD.password = ""
                case .failure(let error):
                    print("xxx", error.localizedDescription)
                    self.goLoginPage()
                    UD.token = ""
                    UD.phoneNum = ""
                    UD.password = ""
                }
            }
//            let vc = CalendarViewController()
//            self.navigationController?.presentPanModal(vc)
        }
        let cancelAction = UIAlertAction(title: "cancel".translate(), style: .cancel, handler: nil)
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func passwordChange() {
        let vc = ChancePassViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func languageChange() {
        let vc = ChangeLanguage()
        vc.isModeChange = false
        navigationController?.presentPanModal(vc)
    }
    
    func modeChange() {
        let vc = ChangeLanguage()
        vc.isModeChange = true
        navigationController?.presentPanModal(vc)
    }
    
    func historyChange() {
        let vc = PayoutHistoryViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func gototelegra() {
        guard let url = URL(string: "https://t.me/tozauzmarket") else {
          return //be safe
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}


class JarimaViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        title = "Penalties".translate()
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "nopenalties".translate()
        label.textColor = .label
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        showLoadingView()
        label.isHidden = true
        let seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.dissmissLoadingView()
            label.isHidden = false
        }
        
      
    }
}
