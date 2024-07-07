//
//  LanguageViewController.swift
//  TozaUz
//
//  Created by Mekhriddin Jumaev on 29/06/24.
//

import UIKit
import SnapKit

class LanguageViewController: UIViewController {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var centerView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var langaugeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.text = "Tilni tanlang"
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    lazy var langaugeLabel2: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.text = "Выберите язык"
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    lazy var uzbekButton: LanguageButton = {
        let button = LanguageButton()
        button.setLanguage(text: "O'zbek", image: UIImage(named: "UZ")!)
        return button
    }()
    
    lazy var russianButton: LanguageButton = {
        let button = LanguageButton()
        button.setLanguage(text: "Русский", image: UIImage(named: "RU")!)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
               
        self.navigationController?.navigationBar.tintColor = UIColor.label
    }
    
    private func initViews() {
        view.backgroundColor = .white
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.backgroundColor = AppColors.mainColor
        subView.addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        centerView.addSubview(langaugeLabel)
        langaugeLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        centerView.addSubview(uzbekButton)
        uzbekButton.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left).offset(25)
            make.right.equalTo(view.snp.centerX).offset(-10)
            make.top.equalTo(langaugeLabel.snp.bottom).offset(30)
            make.height.equalTo(60)

        }
        
        centerView.addSubview(russianButton)
        russianButton.snp.makeConstraints { make in
            make.right.equalTo(view.snp.right).offset(-25)
            make.left.equalTo(view.snp.centerX).offset(10)
            make.top.equalTo(langaugeLabel.snp.bottom).offset(30)
            make.height.equalTo(60)
        }
        
        russianButton.addPressAnimation { [weak self] in
            guard let self = self else { return }
            Vibration.light.vibrate()
            self.pushToLoginScreen()
            LanguageManager.setApplLang(.English)
        }
        
        uzbekButton.addPressAnimation { [weak self] in
            guard let self = self else { return }
            Vibration.light.vibrate()
            self.pushToLoginScreen()
            LanguageManager.setApplLang(.Uzbek)

        }
        
        centerView.addSubview(langaugeLabel2)
        langaugeLabel2.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(uzbekButton.snp.bottom).offset(30)
            make.bottom.equalToSuperview()
        }
    }

    func pushToLoginScreen() {
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

class LanguageButton: UIButton {
    
    lazy var subView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18
        view.backgroundColor = .white
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "UZ")!
        return imageView
    }()
    
    lazy var langaugeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.text = "O'zbek"
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLanguage(text: String, image: UIImage) {
        langaugeLabel.text = text
        iconView.image = image
    }
    
    private func initViews() {
        self.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(containerView)
        containerView.backgroundColor = .clear
        containerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        containerView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(30)
        }
        containerView.addSubview(langaugeLabel)
        langaugeLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(8)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        
    }
    
    
}


extension UIView {
    
    func addPressAnimation(completion: (() -> Void)? = nil) {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handlePressAnimation(_:)))
        longPressRecognizer.minimumPressDuration = 0
        self.addGestureRecognizer(longPressRecognizer)
        self.isUserInteractionEnabled = true
        self.pressAnimationCompletion = completion
    }
    
    @objc private func handlePressAnimation(_ gestureRecognizer: UILongPressGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            animateScaleDown()
        case .ended, .cancelled, .failed:
            animateScaleUp()
        default:
            break
        }
    }
    
    private func animateScaleDown() {
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: .curveLinear,
            animations: { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            },
            completion: nil
        )
    }
    
    private func animateScaleUp() {
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: .curveLinear,
            animations: { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 1, y: 1)
            },
            completion: { [weak self] _ in
                self?.isUserInteractionEnabled = true
                self?.pressAnimationCompletion?()
            }
        )
    }
    
    private struct AssociatedKeys {
        static var completionBlockKey = "pressAnimationCompletion"
    }
    
    private var pressAnimationCompletion: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.completionBlockKey) as? (() -> Void)
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.completionBlockKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}


