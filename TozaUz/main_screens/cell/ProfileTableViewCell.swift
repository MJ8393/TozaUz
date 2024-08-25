//
//  ProfileTableViewCell.swift
//  TozaUz
//
//  Created by Mekhriddin Jumaev on 01/07/24.
//

import UIKit

protocol ProfileTableViewCellDelegate: AnyObject {
    func passwordChange()
    func languageChange()
    func modeChange()
    func historyChange()
    func logout()
    func delete()
    func gototelegra()
    func changeProfile()
    func gotoJarima()
}

class ProfileTableViewCell: UITableViewCell {
    
    weak var delegate: ProfileTableViewCellDelegate?
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var accountView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 22
        view.backgroundColor = UIColor(named: "ProfileColor")
        view.applyShadow()
        return view
    }()
    
    lazy var accountView2: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Group 60868")!
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        return view
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.text = "\(UD.firstName ?? "") \(UD.lastName ?? "")"
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.text = "\(UD.phoneNum ?? "")"
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var cellView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 22
        view.backgroundColor = UIColor(named: "ProfileColor")
        view.applyShadow()
        return view
    }()
    
    lazy var profileCell: CellView = {
        let cell = CellView(image: UIImage(systemName: "person.badge.key")!, name: "profile_change_info".translate())
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeProfileCellTapped)))
        return cell
    }()
    
    @objc func changeProfileCellTapped() {
        delegate?.changeProfile()
    }
    
    lazy var changePasswordCell: CellView = {
        let cell = CellView(image: UIImage(systemName: "lock.rotation")!, name: "changePAssword".translate())
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changePasswordCellTapped)))
        return cell
    }()
    
    @objc func changePasswordCellTapped() {
        delegate?.passwordChange()
    }
    
    lazy var changeLanguageCell: CellView = {
        let cell = CellView(image: UIImage(systemName: "globe")!, name: "choose_Lang".translate())
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changePchangeLanguageCell)))
        return cell
    }()
    
    @objc func changePchangeLanguageCell() {
        delegate?.languageChange()
    }
    
    lazy var setModeCell: CellView = {
        let cell = CellView(image: UIImage(systemName: "moon.stars"), name: "change_design".translate())
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changePsetModeCelleCell)))
        return cell
    }()
    
    @objc func changePsetModeCelleCell() {
        delegate?.modeChange()

    }
    
    lazy var historyCell: CellView = {
        let cell = CellView(image: (UIImage(systemName: "doc.badge.clock") == nil) ? UIImage(systemName: "clock.arrow.circlepath") : UIImage(systemName: "doc.badge.clock"), name: "history_profile".translate())
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changePshistoryCelllleCell)))
        return cell
    }()
    
    @objc func changePshistoryCelllleCell() {
        delegate?.historyChange()

    }
    
    lazy var telegramCell: CellView = {
        let cell = CellView(image: UIImage(systemName: "paperplane.circle"), name: "telegram".translate())
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoTelegram)))
        return cell
    }()
    
    @objc func gotoTelegram() {
        delegate?.gototelegra()

    }
    
    lazy var jarimaCell: CellView = {
        let cell = CellView(image: UIImage(systemName: "exclamationmark.shield"), name: "Penalties".translate())
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoJarima)))
        return cell
    }()
    
    @objc func gotoJarima() {
        delegate?.gotoJarima()
    }
    
    lazy var deeleteView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 22
        view.backgroundColor = UIColor(named: "ProfileColor")
        view.applyShadow()
        return view
    }()
    
    lazy var logOutCell: CellView = {
        let cell = CellView(image: UIImage(systemName: "rectangle.portrait.and.arrow.forward") == nil ? UIImage(systemName: "rectangle.portrait.and.arrow.right") : UIImage(systemName: "rectangle.portrait.and.arrow.forward"), name: "goOut".translate())
        cell.iconImageView.tintColor = .red
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logOut)))
        return cell
    }()
    
    @objc func logOut() {
        self.delegate?.logout()
    }
    
    lazy var deleteCell: CellView = {
        let cell = CellView(image: UIImage(systemName: "trash")!, name: "deleteAccount".translate())
        cell.iconImageView.tintColor = .red
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteX)))
        return cell
    }()
    
    @objc func deleteX() {
        delegate?.delete()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews() {
        if UD.isLoginMode == "y" {
            contentView.addSubview(subView)
            subView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            subView.addSubview(cellView)
            cellView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(20)
                make.top.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
   
            cellView.addSubview(changeLanguageCell)
            changeLanguageCell.snp.makeConstraints { make in
                make.left.right.equalToSuperview().offset(0)
                make.top.equalToSuperview().offset(10)
            }
            
            cellView.addSubview(setModeCell)
            setModeCell.snp.makeConstraints { make in
                make.left.right.equalToSuperview().offset(0)
                make.top.equalTo(changeLanguageCell.snp.bottom).offset(0)
            }
            
            cellView.addSubview(telegramCell)
            telegramCell.snp.makeConstraints { make in
                make.left.right.equalToSuperview().offset(0)
                make.top.equalTo(setModeCell.snp.bottom).offset(0)
                make.bottom.equalToSuperview().offset(-10)
            }
            
        
            subView.addSubview(deeleteView)
            deeleteView.snp.makeConstraints { make in
                make.left.right.equalTo(cellView)
                make.top.equalTo(cellView.snp.bottom).offset(30)
                make.bottom.equalToSuperview().offset(-20)
            }
            
            logOutCell.phoneLabel.text = "login".translate()
            logOutCell.iconImageView.tintColor = AppColors.mainColor
            deeleteView.addSubview(logOutCell)
            logOutCell.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.left.right.equalToSuperview().offset(0)
                make.bottom.equalToSuperview().offset(-10)
            }
        } else {
            contentView.addSubview(subView)
            subView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            subView.addSubview(accountView)
            accountView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(20)
                make.top.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
            
            accountView.addSubview(accountView2)
            accountView2.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(20)
                make.top.equalToSuperview().offset(20)
                make.bottom.equalToSuperview().offset(-20)
                make.height.width.equalTo(50)
            }
            
            accountView.addSubview(nameLabel)
            nameLabel.snp.makeConstraints { make in
                make.left.equalTo(accountView2.snp.right).offset(20)
                make.right.equalToSuperview().offset(-20)
                make.bottom.equalTo(accountView.snp.centerY).offset(-3.5)
            }
            
            accountView.addSubview(phoneLabel)
            phoneLabel.snp.makeConstraints { make in
                make.left.equalTo(accountView2.snp.right).offset(20)
                make.right.equalToSuperview().offset(-20)
                make.top.equalTo(accountView.snp.centerY).offset(3.5)
            }
            
            subView.addSubview(cellView)
            cellView.snp.makeConstraints { make in
                make.left.right.equalTo(accountView)
                make.top.equalTo(accountView.snp.bottom).offset(30)
            }
            
            cellView.addSubview(profileCell)
            profileCell.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.left.right.equalToSuperview().offset(0)
            }
            
            cellView.addSubview(changePasswordCell)
            changePasswordCell.snp.makeConstraints { make in
                make.top.equalTo(profileCell.snp.bottom).offset(0)
                make.left.right.equalToSuperview().offset(0)
            }
            
            cellView.addSubview(changeLanguageCell)
            changeLanguageCell.snp.makeConstraints { make in
                make.left.right.equalToSuperview().offset(0)
                make.top.equalTo(changePasswordCell.snp.bottom).offset(0)
            }
            
            cellView.addSubview(setModeCell)
            setModeCell.snp.makeConstraints { make in
                make.left.right.equalToSuperview().offset(0)
                make.top.equalTo(changeLanguageCell.snp.bottom).offset(0)
            }
            
            cellView.addSubview(historyCell)
            historyCell.snp.makeConstraints { make in
                make.left.right.equalToSuperview().offset(0)
                make.top.equalTo(setModeCell.snp.bottom).offset(0)
            }
            
            cellView.addSubview(telegramCell)
            telegramCell.snp.makeConstraints { make in
                make.left.right.equalToSuperview().offset(0)
                make.top.equalTo(historyCell.snp.bottom).offset(0)
            }
            
            cellView.addSubview(jarimaCell)
            jarimaCell.snp.makeConstraints { make in
                make.left.right.equalToSuperview().offset(0)
                make.top.equalTo(telegramCell.snp.bottom).offset(0)
                make.bottom.equalToSuperview().offset(-10)
            }
//
            
            subView.addSubview(deeleteView)
            deeleteView.snp.makeConstraints { make in
                make.left.right.equalTo(accountView)
                make.top.equalTo(cellView.snp.bottom).offset(30)
                make.bottom.equalToSuperview().offset(-20)
            }
            
            deeleteView.addSubview(logOutCell)
            logOutCell.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.left.right.equalToSuperview().offset(0)
            }
            
            deeleteView.addSubview(deleteCell)
            deleteCell.snp.makeConstraints { make in
                make.top.equalTo(logOutCell.snp.bottom).offset(0)
                make.bottom.equalToSuperview().offset(-10)
                make.left.right.equalToSuperview().offset(0)
            }
        }
    }

}

extension UIView {
    func applyShadow() {
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 18
        self.layer.masksToBounds = false
        
        // Spread adjustment
        let spread: CGFloat = 0
        if spread == 0 {
            self.layer.shadowPath = nil
        } else {
            let dx = -spread
            let rect = self.bounds.insetBy(dx: dx, dy: dx)
            self.layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

class CellView: UIView {
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage()
        imageView.tintColor = AppColors.mainColor
        return imageView
    }()
    
    lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.text = "Test"
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    init(image: UIImage?, name: String) {
        super.init(frame: .zero)
        iconImageView.image = image
        
        phoneLabel.text = name
        self.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.height.width.equalTo(26)
        }
        
        self.addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImageView.snp.right).offset(15)
            make.right.equalToSuperview().offset(-20)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
