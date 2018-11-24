//
//  LoginViewController.swift
//  MyBeerDiary2
//
//  Created by Florian LUDOT on 10/13/18.
//  Copyright © 2018 青柳瑞子. All rights reserved.
//

import UIKit
import TwitterKit
import Firebase

class LoginViewController: UIViewController {
   
    let database: FirebaseDatabase
    
    init(firebaseDatabase: FirebaseDatabase = FirebaseDatabase()) {
        self.database = firebaseDatabase
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
        
        database.insertUser(id: "flo", email: "flo@", username: "@flo")
    }
    
    private func configureTwitterButton() {
        
        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            guard let strongSession = session else {
                guard let strongError = error else {
                    print("error: Default");
                    return
                }
                print("error: \(strongError.localizedDescription)");
                return
            }

            print("signed in as \(strongSession.userName)");
            let credential = TwitterAuthProvider.credential(withToken: strongSession.authToken, secret: strongSession.authTokenSecret)
            print(strongSession.authToken)
            print(strongSession.authTokenSecret)
            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                guard let strongAuthResult = authResult else {
                    guard let strongError = error else {
                        print("error: Default");
                        return
                    }
                    print("error: \(strongError.localizedDescription)");
                    return
                }
                
                let client = TWTRAPIClient.withCurrentUser()
                
                client.requestEmail { email, error in
                    guard let email = email else {
                        guard let strongError = error else {
                            print("error: Default");
                            return
                        }
                        print("error: \(strongError.localizedDescription)");
                        return
                    }
                    Auth.auth().currentUser?.updateEmail(to: email) { [weak self](error) in
                        guard let strongSelf = self else { return }
                        guard let userId = Auth.auth().currentUser?.uid else {
                            fatalError("no user id")
                        }
                        strongSelf.getUserInfo(completionHandler: { [weak self] (user) in
                            guard let user = user else {
                                preconditionFailure("no user")
                            }
                            let twitterUser = TwitterUser(userId: userId, username: user.name, email: email)
                            strongSelf.database.insertTwitterUser(ofId: userId, data: twitterUser.firebaseObject())
                            
                        })
//
                    }
                }
                

            }
            
        })
        
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logInButton)
        
        logInButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20).isActive = true
        logInButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        logInButton.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor, constant: -20).isActive = true
        logInButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        
    }
    
    func getUserInfo(completionHandler: @escaping (TWTRUser?)->()){
        let client = TWTRAPIClient()
        
        guard let twitterId = TWTRAPIClient.withCurrentUser().userID else {
            fatalError("error")
        }
        
        client.loadUser(withID: twitterId) { (user, error) -> Void in
            // handle the response or error
            guard error == nil else {
                fatalError("error")
            }
            
            completionHandler(user)
        }
    }
    
}
