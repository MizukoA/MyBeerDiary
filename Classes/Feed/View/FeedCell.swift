//
//  FeedCell.swift
//  MyBeerDiary2
//
//  Created by 青柳瑞子 on 2018/10/13.
//  Copyright © 2018 青柳瑞子. All rights reserved.
//

import UIKit
import Kingfisher

class FeedCell:UICollectionViewCell{
    static let identifier = "FeedCell"
    
    let borderedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let feedImageView: UIImageView = {
        let feedImageView = UIImageView()
        feedImageView.translatesAutoresizingMaskIntoConstraints = false
        feedImageView.layer.cornerRadius = 4.0
        feedImageView.contentMode = .scaleAspectFill
        feedImageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        feedImageView.layer.masksToBounds = true
        return feedImageView
    }()
    
    let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = .black
        dateLabel.font = UIFont.boldSystemFont(ofSize: 16)
        dateLabel.numberOfLines = 1
        return dateLabel
    }()
    
    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .black
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.numberOfLines = 1
        return nameLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.addSubview(borderedView)
        borderedView.addSubview(feedImageView)
        borderedView.addSubview(dateLabel)
        borderedView.addSubview(nameLabel)
        borderedView.topAnchor.constraint(equalTo: contentView.topAnchor, constant:1) .isActive = true
        borderedView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant:1) .isActive = true
        borderedView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant:-1) .isActive = true
        borderedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant:-1) .isActive = true
        
        
        feedImageView.topAnchor.constraint(equalTo: borderedView.topAnchor, constant:0) .isActive = true
        feedImageView.leftAnchor.constraint(equalTo: borderedView.leftAnchor, constant:0) .isActive = true
        feedImageView.rightAnchor.constraint(equalTo: borderedView.rightAnchor, constant:0) .isActive = true
        feedImageView.heightAnchor.constraint(equalToConstant: 162) .isActive = true
        dateLabel.topAnchor.constraint(equalTo: feedImageView.bottomAnchor, constant:10) .isActive = true
        dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant:20) .isActive = true
        dateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant:-20) .isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20) .isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant:6) .isActive = true
        nameLabel.leftAnchor.constraint(equalTo: dateLabel.leftAnchor, constant:0) .isActive = true
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant:-20) .isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20) .isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: DiaryNode) {
        
        if let date = model.date {
            dateLabel.text = "Date: \(date)"
        }
        
        if let drink = model.drink {
            nameLabel.text = "Drink: \(drink)"
        }
        
        if let pictureURL = model.pictureUrl, let url = URL(string: pictureURL) {
            feedImageView.kf.setImage(with: url)
        }
        
    }
}
