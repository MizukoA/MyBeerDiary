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
    
    weak var delegate: AppContainerDelegate?
    var TwitterAuth: Void?
   
    let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = true
        iv.image = #imageLiteral(resourceName: "background")
        return iv
    }()
    
    let opacityView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0.6
        return view
    }()
    
    lazy var appLogo: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "launchlogo")
        iv.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(iconClicked))
        iv.addGestureRecognizer(tapGestureRecognizer)
        return iv
    }()
    
    let appCatch: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = NSLocalizedString("Never forget where your favorite beers are.", comment: "")
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    let termsConditionsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let buttonAS = NSAttributedString(string: NSLocalizedString("Terms and Conditions", comment: ""), attributes: [NSAttributedString.Key.underlineStyle : 1, .font : UIFont.systemFont(ofSize: 11), .foregroundColor : UIColor.white])
        button.setAttributedTitle(buttonAS, for: .normal)
        return button
    }()
    
    var twitterButton: TWTRLogInButton!
    
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
        
        view.addSubview(backgroundImageView)
        view.addSubview(opacityView)
        view.addSubview(appLogo)
        view.addSubview(appCatch)
        view.addSubview(termsConditionsButton)
        view.addSubview(twitterButton)
        
        
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        opacityView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 0).isActive = true
        opacityView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 0).isActive = true
        opacityView.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor, constant: 0).isActive = true
        opacityView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 0).isActive = true
        
        appLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        if #available(iOS 11.0, *) {
            appLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 180).isActive = true
        } else {
            appLogo.topAnchor.constraint(equalTo: view.topAnchor, constant: 180).isActive = true
        }
        appLogo.widthAnchor.constraint(equalToConstant: 80).isActive = true
        appLogo.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        appCatch.topAnchor.constraint(equalTo: appLogo.bottomAnchor, constant: 20).isActive = true
        appCatch.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        appCatch.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        
        
        if #available(iOS 11.0, *) {
            termsConditionsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        } else {
            termsConditionsButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        }
        
        termsConditionsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        twitterButton.translatesAutoresizingMaskIntoConstraints = false

        twitterButton.bottomAnchor.constraint(equalTo: termsConditionsButton.topAnchor, constant: -40).isActive = true
        twitterButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        twitterButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        twitterButton.heightAnchor.constraint(equalToConstant: 45).isActive = true

        
    }
    
    private func configureTwitterButton() {
        
        twitterButton = TWTRLogInButton(logInCompletion: { [weak self] session, error in
            guard let strongSelf = self else { return }
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
            strongSelf.TwitterAuth = Auth.auth().signInAndRetrieveData(with: credential) { [weak self] (authResult, error) in
                guard let strongAuthResult = authResult else {
                    guard let strongError = error else {
                        print("error: Default");
                        return
                    }
                    print("error: \(strongError.localizedDescription)")
                    return
                }

                let client = TWTRAPIClient.withCurrentUser()

                client.requestEmail { email, error in
                    guard let email = email else {
                        guard let strongError = error else {
                            print("error: Default");
                            return
                        }
                        print("error: \(strongError.localizedDescription)")
                        return
                    }
                    Auth.auth().currentUser?.updateEmail(to: email) { [weak self] (error) in
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
                    }
                }


            }

        })
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
    
    @objc func iconClicked() {
        delegate?.didTapImageIcon()
    }
    
    deinit {
        print("deinit LoginViewController")
    }
    
}
