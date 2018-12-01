//
//  FeedViewController.swift
//  MyBeerDiary2
//
//  Created by Florian LUDOT on 10/13/18.
//  Copyright © 2018 青柳瑞子. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    let user: User
    var nodes = [DiaryNode]()

    
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
    
    lazy var addTestButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Insert Automatic Node", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(insertAutomaticNode), for: .touchUpInside)
        return button
    }()
    
    init(user: User = User()) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        title = "Feed"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(feedCollectionView)
        view.addSubview(addTestButton)
        
        feedCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        feedCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        feedCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        feedCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        addTestButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -40).isActive = true
        addTestButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        addTestButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        addTestButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        setupAddBarButtonItem()
//        fireAlertUD()
        
        let longPressReconizer = UILongPressGestureRecognizer(target: self, action: #selector(cellSelected(gesture:)))
        longPressReconizer.delaysTouchesBegan = true
        self.feedCollectionView.addGestureRecognizer(longPressReconizer)
        APIService().fetchDiaryNodes(userId: "F6sb5CTbUCMbqLuLC3Ksrl9uQml2") { [weak self] (nodes) in
            guard let strongSelf = self else { return }
            strongSelf.nodes = nodes
            strongSelf.feedCollectionView.reloadData()
            
        }
    }
    
    @objc func cellSelected(gesture: UILongPressGestureRecognizer) {
        if gesture.state != .began {
            return
        }
        let p = gesture.location(in: self.feedCollectionView)
        
        if let indexPath = self.feedCollectionView.indexPathForItem(at: p) {
            removeNode(at: indexPath)
        } else {
            print("couldn't find index path")
        }
    }
    
    private func removeNode(at indexPath: IndexPath) {
        let node = nodes[indexPath.row]
        APIService().deleteNode(userId: "F6sb5CTbUCMbqLuLC3Ksrl9uQml2", node: node) { [weak self] (removed) in
            guard let strongSelf = self else { return }
            strongSelf.nodes.remove(at: indexPath.row)
            strongSelf.feedCollectionView.deleteItems(at: [indexPath])
        }
    }
    
    private func fireAlertUD() {
        let userToken = user.loginToken ?? "NaN"
        let username = user.username ?? "NaN"
        let isLogged = user.isLogged
        let message = "loginToken: \(userToken)\nusername: \(username)\nisLogged: \(isLogged)"
        let alert = UIAlertController(title: "UserDefaultData", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupAddBarButtonItem() {
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNode))
        self.navigationItem.rightBarButtonItem = addBarButton
    }
    
    @objc private func insertAutomaticNode() {
        let node = DiaryNode(date: "20/12/2018", drink: "Water", pictureUrl: "https://www.water.org.uk/sites/default/files/styles/large/public/images/11138455_m.jpg?itok=vb4Jrz3x", coordinates: Coordinates(latitude: 54.34, longitude: 3.543))
        APIService().addNewNode(userId: "F6sb5CTbUCMbqLuLC3Ksrl9uQml2", node: node) { [weak self] node in
            guard let strongSelf = self else { return }
            strongSelf.nodes.insert(node, at: 0)
            strongSelf.feedCollectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
        }
    }
    
    @objc private func addNode() {
        let addViewController = AddNodeViewController()
        let embedded = UINavigationController(rootViewController: addViewController)
        self.navigationController?.present(embedded, animated: true, completion: nil)
        
    }
    
}

extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier, for: indexPath) as!  FeedCell
        let node = nodes[indexPath.row]
        cell.configure(with: node)
        
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
        let node = nodes[indexPath.row]
        let detailViewController = FeedDetailController(node: node)
        self.navigationController?.pushViewController(detailViewController, animated: true)
        
    }
}
