//
//  MainButton.swift
//  TozaUz
//
//  Created by Mekhriddin Jumaev on 29/06/24.
//

import UIKit

class MainButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = AppColors.mainColor
        self.layer.cornerRadius = 18
    }
    
    init(title: String) {
        super.init(frame: .zero)
        self.backgroundColor = AppColors.mainColor
        self.layer.cornerRadius = 18
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
