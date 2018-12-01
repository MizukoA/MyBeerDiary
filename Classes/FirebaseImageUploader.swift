//
//  FirebaseImageUploader.swift
//  MyBeerDiary2
//
//  Created by Florian LUDOT on 11/17/18.
//  Copyright © 2018 青柳瑞子. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

enum FirebaseStorageChildren: String {
    case profilePicture
}

class FirebaseImageUploader {
    
    let ref: StorageReference
    
    init(reference: StorageReference = Storage.storage().reference()) {
        ref = reference
    }
    
    func uploadFromLink(_ url: URL) {
        print("image url: ", url.absoluteString)
        downloadImage(from: url)
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil, let imageData = UIImage(data: data), let jpegData =  UIImageJPEGRepresentation(imageData, 1.0)?.base64EncodedData() else { return }
            print(data)
            
            DispatchQueue.main.async {
                let userId = Auth.auth().currentUser?.uid ?? "nil"
                
                let profileImageRef = self.ref.child(FirebaseStorageChildren.profilePicture.rawValue).child(userId).child("\(UUID().uuidString).jpg")
                
                // Upload the file to the path "images/rivers.jpg"
                let uploadTask = profileImageRef.putData(data, metadata: nil) { (metadata, error) in
                    guard let metadata = metadata else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    // Metadata contains file metadata such as size, content-type.
                    let size = metadata.size
                    // You can also access to download URL after upload.
                    profileImageRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            // Uh-oh, an error occurred!
                            return
                        }
                        print("downloadURL: ", downloadURL)
                    }
                }
            }
            
        }
        
        
    }
    
    
    
}
