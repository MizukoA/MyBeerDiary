//
//  LoginViewController.swift
//  MyBeerDiary2
//
//  Created by Florian LUDOT on 10/13/18.
//  Copyright © 2018 青柳瑞子. All rights reserved.
//

import UIKit
import TwitterKit

class LoginViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        title = "Login"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureTwitterButton()
    }
    
    private func configureTwitterButton() {
        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                print("signed in as \(session!.userName)");
            } else {
                print("error: \(error!.localizedDescription)");
            }
        })
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logInButton)
        
        logInButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20).isActive = true
        logInButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        logInButton.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor, constant: -20).isActive = true
        logInButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
}
