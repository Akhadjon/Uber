//
//  LoginController.swift
//  Uber
//
//  Created by Akhadjon Abdukhalilov on 11/13/20.
//

import UIKit
import SnapKit
import Firebase

class LoginController: UIViewController {

    //MARK:-Prorperties
    private let titleLabel :UILabel = {
        let label = UILabel()
        label.text = "UBER"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = UIColor(white: 1, alpha: 1)
        return label
    }()
    
    private lazy var  emailContainerView:UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    private lazy var  passwordContainerView:UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private let emailTextField:UITextField = {
        return UITextField().textField(withPlaceholder: "Email", isSecureTextEntry: false)
    }()
    private let passwordTextField:UITextField = {
        return UITextField().textField(withPlaceholder: "Password", isSecureTextEntry: true)
    }()
    
    private let loginButton:AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
   private let dontHaveAccountButton:UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16),NSAttributedString.Key.foregroundColor:UIColor.mainBlueTint]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()

    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
       configureUI()
    }

    
    //MARK: - Actions
    @objc private func handleShowSignUp(){
        let controller = SignUpController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func handleLogin(){
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else{ return }
       
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                print("failed to log user in with \(error.localizedDescription)")
                return
            }
            
            guard let controller = UIApplication.shared.keyWindow?.rootViewController as? HomeController else{ return }
            controller.configureUI()
            self.dismiss(animated: true, completion: nil)
        }
    }
     
    //MARK:-Helper Functions
    private func configureUI(){
        
        configureNaviagtionBar()
        
        view.backgroundColor = .backgroundColor
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.topMargin)
            make.centerX.equalToSuperview()
        }
        let stack = UIStackView(arrangedSubviews: [emailContainerView,passwordContainerView, loginButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 24
        
        view.addSubview(stack)
        stack.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom:view.safeAreaLayoutGuide.bottomAnchor,height: 32)
    }
    
    
    private func configureNaviagtionBar(){
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }

}
