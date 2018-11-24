//
//  AddNodeViewController.swift
//  MyBeerDiary2
//
//  Created by Florian LUDOT on 10/13/18.
//  Copyright © 2018 青柳瑞子. All rights reserved.
//

import UIKit

class AddNodeViewController: UIViewController {
    // 写真を表示する
    lazy var addImageView: UIImageView = {
        let aiv = UIImageView()
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.contentMode = .scaleAspectFit
        aiv.backgroundColor = .green
        aiv.layer.masksToBounds = true
        aiv.isUserInteractionEnabled = true
        aiv.image = #imageLiteral(resourceName: "launchlogo")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTouchCameraButton(_:)))
        aiv.addGestureRecognizer(tapGesture)
        return aiv
    }()
    
    // 日付を記録する
    let tf: DatePickerTextField = {
        let tf = DatePickerTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.contentMode = .scaleAspectFit
        tf.backgroundColor = .red
        tf.layer.masksToBounds = true
        return tf
    }()
    

    // ビールの名前や場所を記録する
    lazy var nametf: UITextField = {
        let nametf = UITextField()
        nametf.translatesAutoresizingMaskIntoConstraints = false
        nametf.textColor = .black
        nametf.font = UIFont.boldSystemFont(ofSize: 16)
        nametf.backgroundColor = .yellow
        nametf.delegate = self
        return nametf
    }()
    
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        title = "Add"
        manageKeyboard()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.backgroundColor = .white
        // UIパーツのサイズ on addSubView
        // for ImagreView
        view.addSubview(addImageView)
        addImageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20).isActive = true
        addImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        addImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        addImageView.heightAnchor.constraint(equalToConstant: 280).isActive = true
        // for textField_1 datePicker
        view.addSubview(tf)
        tf.topAnchor.constraint(equalTo: addImageView.bottomAnchor, constant: 20).isActive = true
        tf.leftAnchor.constraint(equalTo: addImageView.leftAnchor, constant: 0).isActive = true
        tf.rightAnchor.constraint(equalTo: addImageView.rightAnchor, constant: 0).isActive = true
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        // for textField_2 note beer name, drinking place and so on
        view.addSubview(nametf)
        nametf.topAnchor.constraint(equalTo: tf.bottomAnchor, constant: 20).isActive = true
        nametf.leftAnchor.constraint(equalTo: addImageView.leftAnchor, constant: 0).isActive = true
        nametf.rightAnchor.constraint(equalTo: addImageView.rightAnchor, constant: 0).isActive = true
        nametf.heightAnchor.constraint(equalToConstant: 50).isActive = true
       
        //  shareButton edit on addSubview
        
        let shareBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTouchShareButton))
        navigationItem.rightBarButtonItem = shareBarButton
        
        setupDismissLeftBarButtonItem()
    }
    
    // close AddNodeViewController
    private func setupDismissLeftBarButtonItem() {
        let dismissBarButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissVC))
        self.navigationItem.leftBarButtonItem = dismissBarButton
    }
    
    @objc private func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTouchShareButton() {
        guard let addImageView = addImageView.image else {
            print("撮影した写真が設定されていません")
            return
        }
        let shareText = "#MyBeerDiaryApp"
        let items = [shareText, addImageView] as [Any]
        
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    // カメラ起動
    @objc func didTouchCameraButton(_ sender: UIImageView) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let alert = UIAlertController(title: "Title", message: "Message", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { (alert) in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                print ("カメラへのアクセスができません")
                return
            }
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true)
        }
        
        let gallery = UIAlertAction(title: "Gallery", style: .default) { (alert) in
            print("Gallery")
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                print ("フォトライブラリへのアクセスができません")
                return
            }
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    private func manageKeyboard() {
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil) { [weak self] notification in
            guard let strongSelf = self else { return }
            strongSelf.showKeyboard(true, withNotification: notification)
            print("keyboardWillShowNotification")
            
            
            
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil) { [weak self] notification in
            guard let strongSelf = self else { return }
            strongSelf.showKeyboard(false, withNotification: notification)
            print("keyboardWillHideNotification")
        }
        
    }
    
    func showKeyboard(_ show: Bool, withNotification notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            let curve = (notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey]! as AnyObject).uint32Value
            let options = UIView.AnimationOptions(rawValue: UInt(curve!) << 16 | UIView.AnimationOptions.beginFromCurrentState.rawValue)
            let duration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSValue as AnyObject).doubleValue
            UIView.animate(
                withDuration: duration!,
                delay: 0,
                options: options,
                animations: {
                    self.view.frame.origin.y = show ? -100 : 0
            },
                completion: { bool in
                    
            })
            
        }
    }
    
    
}

extension AddNodeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // フォトライブラリから読み出す
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            addImageView.image = image
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddNodeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return")
        textField.resignFirstResponder()
        return true
    }
    
    
}


