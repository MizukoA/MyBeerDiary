//
//  APIService.swift
//  MyBeerDiary2
//
//  Created by Florian LUDOT on 12/1/18.
//  Copyright © 2018 青柳瑞子. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol APIServiceProtocol {
    //GET
    func fetchDiaryNodes(userId: String, completionHandler: @escaping (_ nodes: [DiaryNode]) -> ())
    
    //POST
    func addNewNode(userId: String, node: DiaryNode, completionHandler: @escaping (_ nodes: DiaryNode) -> ())
    
    //DELETE
    func deleteNode(userId: String, node: DiaryNode, completionHandler: @escaping (_ removed: Bool) -> ())
    
}

class APIService: APIServiceProtocol {
    
    let DB = FirebaseDatabase()
    
    func fetchDiaryNodes(userId: String, completionHandler: @escaping (_ nodes: [DiaryNode]) -> ()) {
        DB.ref.child(FirebaseRootChild.diaryNode).child(userId).observeSingleEvent(of: .value) { snapshot in
            print(snapshot)

            print(snapshot.key)
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                var nodes = [DiaryNode]()
                for snap in snapshots {
                    print(snap)
                    if let dic = snap.value as? [String : AnyObject] {
                        let node = DiaryNode(id: snap.key, data: dic)
                        nodes.append(node)
                    }
                }
                
                completionHandler(nodes)
            }
        }
    }
    
    func addNewNode(userId: String, node: DiaryNode, completionHandler: @escaping (_ nodes: DiaryNode) -> ()) {
        DB.ref.child(FirebaseRootChild.diaryNode).child(userId).childByAutoId().setValue(node.toDictionary()) { (error, ref) in
            guard let nodeId = ref.key else {
                preconditionFailure("The key")
            }
            var node = node
            node.id = nodeId
            completionHandler(node)
        }
    }
    
    func deleteNode(userId: String, node: DiaryNode, completionHandler: @escaping (_ removed: Bool) -> ()) {
        guard let nodeId = node.id else {
            preconditionFailure("no node id")
        }
        DB.ref.child(FirebaseRootChild.diaryNode).child(userId).child(nodeId).removeValue { (error, _) in
            completionHandler(error == nil)
        }
    }
    
}
