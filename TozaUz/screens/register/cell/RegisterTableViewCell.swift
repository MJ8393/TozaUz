//
//  File.swift
//  TozaUz
//
//  Created by Mekhriddin Jumaev on 29/06/24.
//

import UIKit
import PhoneNumberKit

class RegisterTableViewCell: UITableViewCell {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.text = "name".translate()
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var searchIconImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 20, y: 20, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "phone.fill")
        return imageView
    }()
    
    lazy var searchIconImageView2: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 20, y: 20, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "eye.slash.fill")
        return imageView
    }()
    
    lazy var phoneTextField: UITextField = {
        let textField = UITextField()
        textField.tag = 0
        textField.layer.cornerRadius = 40 / 2
        textField.backgroundColor = UIColor(named: "textFieldColor")
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        leftView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(eyeButtonTapped)))
        leftView.isUserInteractionEnabled = true
        
        textField.rightView = leftView
        textField.rightViewMode = .always
        textField.autocorrectionType = .no
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.leftViewMode = .always
        
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 2.0
        
        let placeholderText = "name".translate()
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
        label.text = "second_name".translate()
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
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        leftView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(eyeButtonTapped)))
        leftView.isUserInteractionEnabled = true
        
        textField.rightView = leftView
        textField.rightViewMode = .always
        textField.autocorrectionType = .no
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.leftViewMode = .always
        
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 2.0
        
        let placeholderText = "second_name".translate()
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
    
    lazy var passwordLabel2: UILabel = {
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
        view.layer.borderWidth = 2.0
        return view
    }()
    
    lazy var passwordTextField2: LoginTextFieldForLogin = {
        let textField = LoginTextFieldForLogin()
        textField.withFlag = true
        textField.withExamplePlaceholder = true
        textField.withPrefix = true
        textField.tag = 2
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
    
    lazy var passwordLabel3: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.text = "password".translate()
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var passwordTextField3: UITextField = {
        let textField = UITextField()
        textField.tag = 3
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
        
        let placeholderText = "password".translate()
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.left.equalToSuperview().offset(30)
        }
        
        subView.addSubview(phoneTextField)
        phoneTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(phoneLabel.snp.bottom).offset(10)
            make.height.equalTo(60)
        }
        
        subView.addSubview(passwordLabel)
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(30)
        }
        
        subView.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(passwordLabel.snp.bottom).offset(10)
            make.height.equalTo(60)
        }
        
        subView.addSubview(passwordLabel2)
        passwordLabel2.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(30)
        }
        
        subView.addSubview(phoneNumberBackgroundView)
        phoneNumberBackgroundView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(passwordLabel2.snp.bottom).offset(10)
            make.height.equalTo(60)
        }
        
        subView.addSubview(passwordTextField2)
        passwordTextField2.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-20 - 2.5)
            make.top.equalTo(passwordLabel2.snp.bottom).offset(10 + 2.5)
            make.height.equalTo(60 - 5)
        }
        
        subView.addSubview(passwordLabel3)
        passwordLabel3.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField2.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(30)
        }
        
        subView.addSubview(passwordTextField3)
        passwordTextField3.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(passwordLabel3.snp.bottom).offset(10)
            make.height.equalTo(60)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func eyeButtonTapped() {
        if passwordTextField3.isSecureTextEntry {
            passwordTextField3.isSecureTextEntry = false
            searchIconImageView2.image = UIImage(systemName: "eye.fill")
        } else {
            passwordTextField3.isSecureTextEntry = true
            searchIconImageView2.image = UIImage(systemName: "eye.slash.fill")
        }
    }
}

extension RegisterTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


class LoginTextFieldForLogin: PhoneNumberTextField {
    
    override var defaultRegion: String {
            get {
                return "UZ"
            }
            set {} // exists for backward compatibility
        }

    let padding = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 20)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}


extension UIColor {
    static let mainColor = AppColors.mainColor
    static let grayColor = UIColor.systemGray5
}

extension UIColor {
    class func short(red: Int, green: Int, blue: Int, alpha: Double = 1) -> UIColor {
        let r = CGFloat(red) / 255.0
        let g = CGFloat(green) / 255.0
        let b = CGFloat(blue) / 255.0
        let a = CGFloat(alpha)
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    convenience init(hex hexFromString: String, alpha: CGFloat = 1.0) {
        var cString: String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue: UInt32 = 10066329 //color #999999 if string has wrong format
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count == 6 {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

extension RegisterTableViewCell {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            phoneTextField.layer.borderColor = AppColors.mainColor.cgColor
        } else if textField.tag == 1 {
            passwordTextField.layer.borderColor = AppColors.mainColor.cgColor
        } else if textField.tag == 2 {
            phoneNumberBackgroundView.layer.borderColor = AppColors.mainColor.cgColor
        } else if textField.tag == 3 {
            passwordTextField3.layer.borderColor = AppColors.mainColor.cgColor
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            phoneTextField.layer.borderColor = UIColor.clear.cgColor
        } else if textField.tag == 1 {
            passwordTextField.layer.borderColor = UIColor.clear.cgColor
        } else if textField.tag == 2 {
            phoneNumberBackgroundView.layer.borderColor = UIColor.clear.cgColor
        } else if textField.tag == 3 {
            passwordTextField3.layer.borderColor = UIColor.clear.cgColor
        }
        return true
    }

}
