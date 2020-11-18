//
//  SignUpController.swift
//  Uber
//
//  Created by Akhadjon Abdukhalilov on 11/15/20.
//

import UIKit
import Firebase

class SignUpController: UIViewController {

    //MARK:-Properties
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
    private lazy var  fullnameContainerView:UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: fullnameTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    private lazy var  passwordContainerView:UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    private lazy var  accountTypeContainerView:UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_account_box_white_2x"),segmentedControl: accountTypeSegmentedControl)
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return view
    }()
    
    private let emailTextField:UITextField = {
        return UITextField().textField(withPlaceholder: "Email", isSecureTextEntry: false)
    }()
    private let fullnameTextField:UITextField = {
        return UITextField().textField(withPlaceholder: "fullname", isSecureTextEntry: false)
    }()
    private let passwordTextField:UITextField = {
        return UITextField().textField(withPlaceholder: "Password", isSecureTextEntry: true)
    }()
    
    private let accountTypeSegmentedControl:UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Rider","Driver"])
        sc.backgroundColor = .backgroundColor
        sc.tintColor = UIColor(white: 1, alpha: 0.87)
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    private let signUpButton:AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("SignUp", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAccountButton:UIButton = {
         let button = UIButton(type: .system)
         let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor:UIColor.lightGray])
         attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16),NSAttributedString.Key.foregroundColor:UIColor.mainBlueTint]))
         button.setAttributedTitle(attributedTitle, for: .normal)
         button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
         return button
     }()

    
    //MARK:-LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }

    //MARK:-Actions
    
    @objc private func handleSignUp(){
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else{ return }
        guard let fullname = fullnameTextField.text else{return}
        let accountTypeIndex = accountTypeSegmentedControl.selectedSegmentIndex
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error{
                print("Failed to register to user with error \(error.localizedDescription)")
                return
            }
            
            guard let uid = result?.user.uid else {return}
            let values = ["email":email,"fullname":fullname,"accountType":accountTypeIndex] as [String : Any]
            
            Database.database().reference().child("users").child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                
                guard let controller = UIApplication.shared.keyWindow?.rootViewController as? HomeController else{ return }
                controller.configureUI()
                self.dismiss(animated: true, completion: nil)
                
            })
        }
    }
    
    @objc private func handleShowLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    //MARK:-Helper Functions
    
    private func configureUI(){
        
        view.backgroundColor = .backgroundColor
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.topMargin)
            make.centerX.equalToSuperview()
        }
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,fullnameContainerView,passwordContainerView,accountTypeContainerView,signUpButton])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 24
        
        view.addSubview(stack)
        stack.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom:view.safeAreaLayoutGuide.bottomAnchor,height: 32)
    
    }
    
    
}
