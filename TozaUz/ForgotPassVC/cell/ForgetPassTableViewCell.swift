//
//  ForgetPassTableViewCell.swift
//  TozaUz
//
//  Created by Mekhriddin Jumaev on 25/08/24.
//

import UIKit

class ForgetPassTableViewCell: UITableViewCell {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    
    lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.text = "phone_number".translate()
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()

    lazy var phoneNumberBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "textFieldColor")
        view.layer.cornerRadius = 40 / 2
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    lazy var phoneTextField: LoginTextFieldForLogin = {
        let textField = LoginTextFieldForLogin()
        textField.withFlag = true
        textField.withExamplePlaceholder = true
        textField.withPrefix = true
        textField.tag = 0
        textField.layer.cornerRadius = 40 / 2
        textField.backgroundColor = UIColor(named: "textFieldColor")
        textField.autocorrectionType = .no
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 2.0
        textField.tintColor = UIColor.label
        textField.delegate = self
        textField.keyboardType = .phonePad
        return textField
    }()
    
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
        
        subView.addSubview(phoneNumberBackgroundView)
        phoneNumberBackgroundView.snp.makeConstraints { make in
            make.left.right.equalTo(phoneLabel)
            make.top.equalTo(phoneLabel.snp.bottom).offset(9)
            make.height.equalTo(60)
        }
        
        subView.addSubview(phoneTextField)
        phoneTextField.snp.makeConstraints { make in
            make.left.equalTo(phoneLabel).offset(20)
            make.right.equalTo(phoneLabel).offset(-2.5)
            make.top.equalTo(phoneLabel.snp.bottom).offset(9 + 2.5)
            make.height.equalTo(55)
            make.bottom.equalToSuperview().offset(-40)
        }
        
    }

}

extension ForgetPassTableViewCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            phoneNumberBackgroundView.layer.borderColor = AppColors.mainColor.cgColor
        } else {
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            phoneNumberBackgroundView.layer.borderColor = UIColor.clear.cgColor
        } else {
        }
        return true
    }

}
