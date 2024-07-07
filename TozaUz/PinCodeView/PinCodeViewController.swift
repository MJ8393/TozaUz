//
//  PinCodeViewController.swift
//  TozaUz
//
//  Created by Mekhriddin Jumaev on 06/07/24.
//

import UIKit

class PasswordViewController: UIViewController {
    
    var pinCodeType: PinCodeType = .regular
    
    var firstPass: String = ""
    var secondPass: String = ""
    
    var passwordStackView: UIStackView!
    var passwordDots: [UIView] = []
    var enteredPassword: String = ""
    let passwordLength = 4

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
         
        if pinCodeType == .regular {
            let buttonImage = UIImage(systemName: "rectangle.portrait.and.arrow.right") // Replace "bell" with the desired system image name
               
               // Set up the right bar button item with the system image
               let rightButton = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(rightButtonTapped))
               
               // Set the button's image color to white
               rightButton.tintColor = .label
               
               // Add the button to the navigation bar
               self.navigationItem.rightBarButtonItem = rightButton
               
               // Optional: Set the navigation bar's background color to make the button stand out

        }
    }
    
    @objc func rightButtonTapped() {
        
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enteredPassword = ""
        updatePasswordDots()
        self.navigationItem.setHidesBackButton(true, animated: true)
        if UD.mode == "system" {
            UD.mode = "block"
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if UD.mode == "block" {
            UD.mode = "system"
        }
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(named: "Color_login")
        
        // Set up the number pad
        let numberPadStackView = UIStackView()
        numberPadStackView.axis = .vertical
        numberPadStackView.distribution = .fillEqually
        numberPadStackView.alignment = .fill
        numberPadStackView.spacing = 20.rv
        numberPadStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(numberPadStackView)
        
        for i in 0..<4 {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.distribution = .fillEqually
            rowStackView.alignment = .fill
            rowStackView.spacing = 20.rv
            numberPadStackView.addArrangedSubview(rowStackView)
            
            for j in 0..<3 {
                let button = UIButton(type: .system)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
                button.setTitleColor(.label, for: .normal)
                button.layer.cornerRadius = 80.rv / 2.0
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.systemGray5.cgColor
                
                let number = i * 3 + j + 1
                if i == 3 && j == 0 {
                    button.isUserInteractionEnabled = false
                    button.alpha = 0.0
                }
                if i == 3 && j == 1 {
                    button.setTitle("0", for: .normal)
                    button.tag = 0
                } else {
                    if i == 3 && j == 2 {
                        button.setImage(UIImage(systemName: "delete.backward")?.withRenderingMode(.alwaysOriginal).withTintColor(.label), for: .normal)
                        button.layer.borderColor = UIColor.clear.cgColor
                        button.tag = 11
                    } else {
                        button.setTitle("\(number % 10)", for: .normal)
                        button.tag = number % 10
                    }
                }
                button.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
                
                button.widthAnchor.constraint(equalToConstant: 80.rv).isActive = true
                button.heightAnchor.constraint(equalToConstant: 80.rv).isActive = true
                
                rowStackView.addArrangedSubview(button)
            }
        }
                
        // Set up the version label
        let versionLabel = UILabel()
        versionLabel.text = "version".translate() + " 1.0"
        versionLabel.font = UIFont.systemFont(ofSize: 14)
        versionLabel.textColor = .lightGray
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(versionLabel)
        
        NSLayoutConstraint.activate([
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            versionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        // Set up the title
        let titleLabel = UILabel()
        switch pinCodeType {
        case .first:
            titleLabel.text =  "pin_code_rememeber".translate()
        case .second:
            titleLabel.text = "pastor_pin".translate()
        case .regular:
            titleLabel.text =  "enter_pass_tg".translate()
        }
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        if UIScreen.main.bounds.height <= 700 {
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(UIScreen.main.bounds.width / 12)
            }
        } else {
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(UIScreen.main.bounds.width / 10)
            }        }
        
        // Set up the password dots
        passwordStackView = UIStackView()
        passwordStackView.axis = .horizontal
        passwordStackView.distribution = .equalSpacing
        passwordStackView.alignment = .center
        passwordStackView.spacing = 20
        passwordStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordStackView)
        
        for _ in 0..<passwordLength {
            let dotView = UIView()
            dotView.backgroundColor = .systemGray5
            dotView.layer.cornerRadius = 10
            dotView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            dotView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            passwordStackView.addArrangedSubview(dotView)
            passwordDots.append(dotView)
        }
        
        NSLayoutConstraint.activate([
            passwordStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50)
        ])
        
        numberPadStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            if UIScreen.main.bounds.height <= 700 {
                make.top.equalTo(passwordStackView.snp.bottom).offset(UIScreen.main.bounds.width / 5)
            } else {
                make.top.equalTo(passwordStackView.snp.bottom).offset(UIScreen.main.bounds.width / 4)
            }
        }
    }
    
    @objc func numberButtonTapped(_ sender: UIButton) {
        Vibration.medium.vibrate()
        guard enteredPassword.count < passwordLength else { return }
        let number = sender.tag

        if number == 11 {
            enteredPassword = String(enteredPassword.dropLast())
            updatePasswordDots()
        } else {
            enteredPassword.append("\(number)")
            updatePasswordDots()
            
            
            if enteredPassword.count == passwordLength {
                
                let seconds = 0.1
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak self] in
                    guard let self = self else { return }
                    // Put your code which should be executed with a delay here
                    // Handle password entered
                    if pinCodeType == .first {
                        let vc = PasswordViewController()
                        vc.pinCodeType = .second
                        vc.firstPass = enteredPassword
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else if pinCodeType == .second {
                        if firstPass == enteredPassword {
                            UD.pinCode = enteredPassword
                            self.setNewRootViewController()
                        } else {
                            let alertController = UIAlertController(title: "failure".translate(), message: "password_wrong".translate(), preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "ok".translate(), style: .default, handler: {[weak self] _ in
                                guard let self = self else { return }
                                navigationController?.popViewController(animated: false)
                                self.firstPass = ""
                                self.enteredPassword = ""
                            })
                            alertController.addAction(defaultAction)
                            present(alertController, animated: true, completion: nil)
                        }
                    } else {
                        if UD.pinCode == enteredPassword {
                            self.setNewRootViewController()
                        } else {
                            updatePasswordDots()
                            let alertController = UIAlertController(title: "failure".translate(), message: "pin_code_wring".translate(), preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "ok".translate(), style: .default, handler: {[weak self] _ in
                                guard let self = self else { return }
                                self.enteredPassword = ""
                                updatePasswordDots()
                            })
                            alertController.addAction(defaultAction)
                            present(alertController, animated: true, completion: nil)
                        }
                    }
                }
               
                print("Entered Password: \(enteredPassword)")
            }
        }
    }
    
    @objc func exitButtonTapped() {
        // Handle exit action
    }
    
    func updatePasswordDots() {
        for (index, dot) in passwordDots.enumerated() {
            if index < enteredPassword.count {
                dot.backgroundColor = AppColors.mainColor
            } else {
                dot.backgroundColor = .systemGray5
            }
        }
    }
}


extension Double {
        
    var rv: Double {
        Ratio.compute(self, accordingTo: .height)
    }
    
    var rh: Double {
        Ratio.compute(self, accordingTo: .width)
    }
}


public class Ratio {
    
    /// Block init
    private init() {}
    
    public enum RatioSide {
        case width
        case height
    }
    
    
    // MARK: - METHODS
    
    @nonobjc public class func font(ofSize size: CGFloat) -> CGFloat {
        return compute(size, accordingTo: .width)
    }
    
    @nonobjc public class func compute(_ size: CGFloat, accordingTo side: RatioSide) -> CGFloat {
        switch side {
        case .height:
            return round(size * Estimate.heightRatio)
            
        case .width:
            return round(size * Estimate.widthRatio)
        }
    }
    
    @nonobjc public class func computeNew(_ size: CGFloat, accordingTo side: RatioSide) -> CGFloat {
        switch side {
        case .height:
            return round(size * Estimate.heightRatioNew)
            
        case .width:
            return round(size * Estimate.widthRatioNew)
        }
    }
    
    @nonobjc public class func compute(percentage: CGFloat, accordingTo side: RatioSide) -> CGFloat {
        let actualSize: CGSize = UIScreen.main.bounds.size
        switch side {
        case .height:
            return actualSize.height * percentage
            
        case .width:
            return actualSize.width * percentage
        }
    }
    
    /**
        Recalculates width and height
     
        Recalculates width according to device width and height according to device height
    */
    @nonobjc public class func compute(_ width: CGFloat, _ height: CGFloat) -> CGSize {
        let scaledWidth: CGFloat = compute(width, accordingTo: .width)
        let scaledHeight: CGFloat = compute(height, accordingTo: .height)
        return CGSize(width: scaledWidth, height: scaledHeight)
    }
    
}


fileprivate struct Estimate {
    private static let _designedSize = CGSize(width: 375, height: 812)
    private static let _actualSize = UIScreen.main.bounds.size
    
    static var heightRatio: CGFloat { _actualSize.height/_designedSize.height }
    static var widthRatio: CGFloat { _actualSize.width/_designedSize.width }
    
    static var heightRatioNew: CGFloat { _actualSize.height/newDesignedSize.height }
    static var widthRatioNew: CGFloat { _actualSize.width/newDesignedSize.width }
    
    private static let newDesignedSize = CGSize(width: 375, height: 812)
}

enum PinCodeType {
    case first
    case second
    case regular
}
