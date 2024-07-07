//
//  PayoutTableViewCell.swift
//  TozaUz
//
//  Created by Mekhriddin Jumaev on 03/07/24.
//

import UIKit

class PayoutTableViewCell: UITableViewCell {

    lazy var subView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 22
        view.backgroundColor = UIColor(named: "ProfileColor")
        view.applyShadow()
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.text = "Admin: "
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var nameDesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.text = "John Doe"
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var amountDesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.text = "1000 so'm"
        label.textColor = AppColors.mainColor
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var dateDesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "2002 2000123"
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var cardDesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "2002 2000123"
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
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
        
        subView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(7.5)
            make.bottom.equalToSuperview().offset(-7.5)
        }
        
        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(50)
        }
        
        containerView.addSubview(nameDesLabel)
        nameDesLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.right).offset(5)
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(nameLabel)
        
        }
        
        containerView.addSubview(amountDesLabel)
        amountDesLabel.snp.makeConstraints { make in
            make.top.equalTo(nameDesLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        containerView.addSubview(cardDesLabel)
        cardDesLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(amountDesLabel)
        }
        
        containerView.addSubview(dateDesLabel)
        dateDesLabel.snp.makeConstraints { make in
            make.right.equalTo(cardDesLabel)
            make.centerY.equalTo(nameLabel)
        }
    }

}
