//
//  HomeTableViewCell.swift
//  TozaUz
//
//  Created by Mekhriddin Jumaev on 03/07/24.
//

import UIKit

protocol HomeTableViewCellDelegate: AnyObject {
    func continueDidTappedd()
}

class HomeTableViewCell: UITableViewCell {
    
    weak var delegate: HomeTableViewCellDelegate?
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var nameXXLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.text = "balanse".translate() + ": 0" + "som".translate()
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    lazy var senderView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 22
        view.backgroundColor = UIColor(named: "ColorTest")
        view.applyShadow()
        return view
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.text = "amount_of_x".translate()
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var amountTextField: AmountTextField = {
        let textField = AmountTextField()
        textField.tag = 1
        textField.layer.cornerRadius = 40 / 2
        textField.backgroundColor = UIColor(named: "textFieldColor")
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                
        textField.rightView = leftView
        textField.rightViewMode = .always
        textField.autocorrectionType = .no
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.leftViewMode = .always
        
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 2.0
        
        let placeholderText = "amount_of_x".translate()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
        textField.tintColor = UIColor.label
        textField.keyboardType = .numberPad
        return textField
    }()
    
    lazy var cardLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.text = "card_number".translate()
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var cardTextField: CardNumberTextField = {
        let textField = CardNumberTextField()
        textField.tag = 1
        textField.layer.cornerRadius = 40 / 2
        textField.backgroundColor = UIColor(named: "textFieldColor")
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                
        textField.rightView = leftView
        textField.rightViewMode = .always
        textField.autocorrectionType = .no
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.leftViewMode = .always
        
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 2.0
        
        let placeholderText = "card_number".translate()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
        textField.tintColor = UIColor.label
        return textField
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.text = "name_seoncd_name".translate()
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.tag = 1
        textField.layer.cornerRadius = 40 / 2
        textField.backgroundColor = UIColor(named: "textFieldColor")
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                
        textField.rightView = leftView
        textField.rightViewMode = .always
        textField.autocorrectionType = .no
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.leftViewMode = .always
        
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 2.0
        
        let placeholderText = "name_seoncd_name".translate()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
        textField.tintColor = UIColor.label
        textField.keyboardType = .default
        return textField
    }()
    
    lazy var continueButton: MainButton = {
        let button = MainButton(title: "send_button".translate())
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
        
        continueButton.addPressAnimation {
            self.delegate?.continueDidTappedd()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews() {
        contentView.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(nameXXLabel)
        nameXXLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.left.right.equalToSuperview()
        }
        
        subView.addSubview(senderView)
        senderView.snp.makeConstraints { make in
            make.top.equalTo(nameXXLabel.snp.bottom).offset(25)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
        
        senderView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        senderView.addSubview(amountTextField)
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).offset(9)
            make.height.equalTo(60)
            make.left.right.equalTo(amountLabel)
        }
        
        senderView.addSubview(cardLabel)
        cardLabel.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        senderView.addSubview(cardTextField)
        cardTextField.snp.makeConstraints { make in
            make.top.equalTo(cardLabel.snp.bottom).offset(9)
            make.height.equalTo(60)
            make.left.right.equalTo(cardLabel)
        }
        
        senderView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(cardTextField.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        senderView.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(9)
            make.height.equalTo(60)
            make.left.right.equalTo(nameLabel)
        }
        
        senderView.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
            make.left.right.equalTo(nameTextField)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
    }
}


class CardNumberTextField: UITextField, UITextFieldDelegate {
    
    // Maximum number of digits in the card number
    private let maxDigits = 16
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.delegate = self
        self.keyboardType = .numberPad
    }
    
    // Function to format card number
    private func formatCardNumber(_ number: String) -> String {
        let trimmedString = number.replacingOccurrences(of: " ", with: "")
        var formattedString = ""
        for (index, character) in trimmedString.enumerated() {
            if index % 4 == 0 && index > 0 {
                formattedString.append(" ")
            }
            formattedString.append(character)
        }
        return formattedString
    }
    
    // UITextFieldDelegate method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let currentText = textField.text as NSString? else { return true }
        let newText = currentText.replacingCharacters(in: range, with: string)
        
        // Remove spaces to count the actual digits
        let digitsOnlyText = newText.replacingOccurrences(of: " ", with: "")
        
        // Ensure the new length does not exceed maxDigits
        if digitsOnlyText.count > maxDigits {
            return false
        }
        
        // Format the new text
        let formattedText = formatCardNumber(digitsOnlyText)
        
        textField.text = formattedText
        return false
    }
}


class AmountTextField: UITextField, UITextFieldDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.delegate = self
        self.keyboardType = .numberPad
    }
    
    // Function to format amount
    private func formatAmount(_ amount: String) -> String {
        let trimmedString = amount.replacingOccurrences(of: " ", with: "")
        var formattedString = ""
        for (index, character) in trimmedString.reversed().enumerated() {
            if index % 3 == 0 && index > 0 {
                formattedString.insert(" ", at: formattedString.startIndex)
            }
            formattedString.insert(character, at: formattedString.startIndex)
        }
        return formattedString
    }
    
    // UITextFieldDelegate method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let currentText = textField.text as NSString? else { return true }
        let newText = currentText.replacingCharacters(in: range, with: string)
        
        // Format the new text
        let formattedText = formatAmount(newText)
        
        textField.text = formattedText
        return false
    }
}
