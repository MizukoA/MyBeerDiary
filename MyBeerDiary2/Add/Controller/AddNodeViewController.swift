//
//  AddNodeViewController.swift
//  MyBeerDiary2
//
//  Created by Florian LUDOT on 10/13/18.
//  Copyright © 2018 青柳瑞子. All rights reserved.
//

import UIKit

class AddNodeViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        title = "Add"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        
        setupDismissLeftBarButtonItem()
    }
    
    private func setupDismissLeftBarButtonItem() {
        let dismissBarButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissVC))
        self.navigationItem.leftBarButtonItem = dismissBarButton
    }
    
    @objc private func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
