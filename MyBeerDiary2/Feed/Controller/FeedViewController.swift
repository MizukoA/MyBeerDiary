//
//  FeedViewController.swift
//  MyBeerDiary2
//
//  Created by Florian LUDOT on 10/13/18.
//  Copyright © 2018 青柳瑞子. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    lazy var diary: Diary = {
        let node0 = DiaryNode(date: "2018/02/10", drink: "Beer", place: "Here", image: UIImage(named: "beer")!)
        let node1 = DiaryNode(date: "2018/02/10", drink: "Wine", place: "hey", image: UIImage(named: "beer1")!)
        let diary = Diary(nodes: [node0, node1])
        return diary
    }()
    
    lazy var feedCollectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        return collectionView
        
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        title = "Feed"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(feedCollectionView)
        feedCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        feedCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        feedCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        feedCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
}

extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let nodes = diary.nodes else { return 0}
        return nodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier, for: indexPath) as!  FeedCell
        if let nodes = diary.nodes {
            let node = nodes[indexPath.row]
            cell.configure(with: node)
        }
        
        return cell
    }
    
    
}

extension FeedViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 339, height: 230)
        
    }
}

extension FeedViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let nodes = diary.nodes else { return }
        let node = nodes[indexPath.row]
        let detailViewController = FeedDetailController(node: node)
        self.navigationController?.pushViewController(detailViewController, animated: true)
        
    }
}
