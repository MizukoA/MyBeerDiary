//
//  AppContrainerViewController.swift
//  MyBeerDiary2
//
//  Created by Florian LUDOT on 11/24/18.
//  Copyright © 2018 青柳瑞子. All rights reserved.
//

import UIKit

protocol AppContainerDelegate: class {
    func didTapImageIcon()
}

class AppContrainerViewController: UIViewController {
    
    var loginViewController: LoginViewController!
    var feedViewController: UINavigationController!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupLoginViewController()
        
    }
    
    private func setupLoginViewController() {
        loginViewController = LoginViewController()
        loginViewController.view.alpha = 0.0
        loginViewController.delegate = self
        self.addChildViewController(loginViewController)
        self.view.addSubview(loginViewController.view)
        loginViewController.didMove(toParentViewController: self)
        loginViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loginViewController.view.alpha = 1.0
        }) {  _ in
            
        }
        
    }
    
    private func hideLoginViewController(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.loginViewController.view.alpha = 0.0
            }) { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.dismissLoginViewController()
            }
        } else {
            dismissLoginViewController()
        }
        
    }
    
    func dismissLoginViewController() {
        self.loginViewController.TwitterAuth = nil
        self.loginViewController.removeFromParentViewController()
        self.loginViewController.view.removeFromSuperview()
        self.loginViewController.didMove(toParentViewController: self)
        self.loginViewController = nil
    }
    
    private func showFeedViewController(animated: Bool) {
        let vc = FeedViewController()
        feedViewController = UINavigationController(rootViewController: vc)
        feedViewController.view.alpha = animated ? 0.0 : 1.0
        self.addChildViewController(feedViewController)
        self.view.addSubview(feedViewController.view)
        feedViewController.didMove(toParentViewController: self)
        feedViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        if animated {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.feedViewController.view.alpha = 1.0
            }) {  _ in
                
            }
        }
    }
    
}

extension AppContrainerViewController: AppContainerDelegate {
    
    func didTapImageIcon() {
        print("Dismiss login")
        hideLoginViewController(animated: true)
        showFeedViewController(animated: true)
    }
    
}
