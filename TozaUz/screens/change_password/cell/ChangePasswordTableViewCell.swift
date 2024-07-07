//
//  ChangePasswordCell.swift
//  TozaUz
//
//  Created by Mekhriddin Jumaev on 03/07/24.
//

import Foundation

import UIKit

class ChangePasswordTableViewCell: UITableViewCell {
        
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.text = "old_pass".translate()
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var searchIconImageView2: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 20, y: 20, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "eye.slash.fill")
        return imageView
    }()
    
    lazy var searchIconImageView1: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 20, y: 20, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "eye.slash.fill")
        return imageView
    }()
    
    lazy var passwordTextField1: UITextField = {
        let textField = UITextField()
        textField.tag = 0
        textField.layer.cornerRadius = 40 / 2
        textField.backgroundColor = UIColor(named: "textFieldColor")
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        leftView.addSubview(searchIconImageView1)
        
        leftView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(eyeButtonTapped1)))
        leftView.isUserInteractionEnabled = true
        
        textField.rightView = leftView
        textField.rightViewMode = .always
        textField.autocorrectionType = .no
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.leftViewMode = .always
        
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 2.0
        textField.isSecureTextEntry = true
        
        let placeholderText = "old_pass".translate()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
        textField.tintColor = UIColor.label
        textField.delegate = self
        return textField
    }()
    
    
    
    lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.text = "new_pass".translate()
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.tag = 1
        textField.layer.cornerRadius = 40 / 2
        textField.backgroundColor = UIColor(named: "textFieldColor")
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        leftView.addSubview(searchIconImageView2)
        
        leftView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(eyeButtonTapped)))
        leftView.isUserInteractionEnabled = true
        
        textField.rightView = leftView
        textField.rightViewMode = .always
        textField.autocorrectionType = .no
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.leftViewMode = .always
        
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 2.0
        textField.isSecureTextEntry = true
        
        let placeholderText = "new_pass".translate()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
        textField.tintColor = UIColor.label
        textField.delegate = self
        return textField
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "change_pass_title".translate()
        label.textColor = .gray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()

    
    @objc func eyeButtonTapped1() {
        if passwordTextField1.isSecureTextEntry {
            passwordTextField1.isSecureTextEntry = false
            searchIconImageView1.image = UIImage(systemName: "eye.fill")
        } else {
            passwordTextField1.isSecureTextEntry = true
            searchIconImageView1.image = UIImage(systemName: "eye.slash.fill")
        }
    }
    
    @objc func eyeButtonTapped() {
        if passwordTextField.isSecureTextEntry {
            passwordTextField.isSecureTextEntry = false
            searchIconImageView2.image = UIImage(systemName: "eye.fill")
        } else {
            passwordTextField.isSecureTextEntry = true
            searchIconImageView2.image = UIImage(systemName: "eye.slash.fill")
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initViews() {
        contentView.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
        }
        
        subView.addSubview(passwordTextField1)
        passwordTextField1.snp.makeConstraints { make in
            make.left.right.equalTo(phoneLabel)
            make.top.equalTo(phoneLabel.snp.bottom).offset(9)
            make.height.equalTo(60)
        }
        
        subView.addSubview(passwordLabel)
        passwordLabel.snp.makeConstraints { make in
            make.left.right.equalTo(phoneLabel)
            make.top.equalTo(passwordTextField1.snp.bottom).offset(20)
        }
        
        subView.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.left.right.equalTo(passwordLabel)
            make.top.equalTo(passwordLabel.snp.bottom).offset(9)
            make.height.equalTo(60)
        }
        
        subView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(80)
            make.right.equalToSuperview().offset(-80)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
}

extension ChangePasswordTableViewCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            passwordTextField1.layer.borderColor = AppColors.mainColor.cgColor
        } else {
            passwordTextField.layer.borderColor = AppColors.mainColor.cgColor
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            passwordTextField1.layer.borderColor = UIColor.clear.cgColor
        } else {
            passwordTextField.layer.borderColor = UIColor.clear.cgColor
        }
        return true
    }

}
