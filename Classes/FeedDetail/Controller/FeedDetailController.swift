//
//  FeedDetailController.swift
//  MyBeerDiary2
//
//  Created by Florian LUDOT on 10/13/18.
//  Copyright © 2018 青柳瑞子. All rights reserved.
//

import UIKit

class FeedDetailController: UIViewController {
    
    let node: DiaryNode
    
    let imageView: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = .black
        dateLabel.font = UIFont.boldSystemFont(ofSize: 18)
        dateLabel.numberOfLines = 1
        return dateLabel
    }()
    
    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .black
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.numberOfLines = 1
        return nameLabel
    }()
    
    init(node: DiaryNode) {
        self.node = node
        super.init(nibName: nil, bundle: nil)
        title = "Detail"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        view.addSubview(dateLabel)
        view.addSubview(nameLabel)
        
        imageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20).isActive = true
        let width = UIScreen.main.bounds.width - 20 * 2
        
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: width).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        populateData()

    }
    
    func populateData() {
        
        if let pictureUrl = node.pictureUrl {
            imageView.kf.setImage(with: URL(string: pictureUrl))
        }
        
        if let date = node.date {
            dateLabel.text = "Date: \(date)"

        }
        
        if let drink = node.drink {
            nameLabel.text = "Drink: \(drink)"

        }
        
    }
}
