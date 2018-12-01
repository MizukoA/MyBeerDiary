//
//  ViewController.swift
//  MyBeerDiary2
//
//  Created by 青柳瑞子 on 2018/08/11.
//  Copyright © 2018年 青柳瑞子. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    var data: DiaryNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // PickerViewでDateのdelegate通知先はどこ?
        
        // text field PlaceとDrinkのdelegate通知先を設定
//        inputTextPlace.delegate = self
//        inputTextDrink.delegate = self
        
        inputTextPlace.addTarget(self, action: #selector(placeLabelChanged(sender:)), for: .editingChanged)
        inputTextDrink.addTarget(self, action: #selector(drinkLabelChanged(sender:)), for: .editingChanged)
        
        populateData()
        
    }
    
    private func populateData() {
        guard let _data = data else {
            return
        }
        
        self.myDrink = _data.drink!
            self.inputTextDrink.text = _data.drink
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func drinkLabelChanged(sender: UITextField) {
        guard let text = sender.text else { return }
        print(text)
        self.myDrink = text
    }
    
    @objc func placeLabelChanged(sender: UITextField) {
        guard let text = sender.text else { return }
        print(text)
        self.myPlace = text
    }

    // cameraまわり
    @IBAction func didTouchCameraButton(_ sender: Any) {
        
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
        
        alert.addAction(camera)
        alert.addAction(gallery)
        self.present(alert, animated: true) {
            ()
        }
    
    }
    
    
    @IBAction func didTouchShareButton(_ sender: Any) {
        guard let image = imageView.image else {
            print("撮影した写真が設定されていません")
            return
        }
        let shareText = "#MyBeerDiaryApp"
        
        // 画像サイズが大きいとシェアができない場合があるため、表示サイズにリサイズする
        let resized = image.resizedImage(size: imageView.frame.size)
        
        let activityItems: [Any] = [shareText, resized]
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        self.present(activityController, animated: true)
        
        print("シェアボタンをタッチしました")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        picker.dismiss(animated: true, completion: nil)
    }

        // datePickerを閉じる
    
    @IBOutlet weak var inputTextPlace: UITextField!
    
    @IBOutlet weak var inputTextDrink: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // keyboardを閉じる
        textField.resignFirstResponder()
        return true
    }
    var myDate: Date = Date()
    var myPlace: String = "" // TODO: 空文字じゃなく、場所　などにする
    var myDrink: String = "" // TODO: 空文字
    
    @IBAction func pushedSaveButton(_ sender: Any) {
        print(myDate, myPlace, myDrink)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        let myDateString = dateFormatter.string(from: myDate)
        
        let diarySet = UserDefaults.standard.array(forKey: "diary") as? [[String: String]]
        
            if var diarySet = diarySet {
                let currentDiary = ["myDate" : myDateString, "myDrink" : myDrink, "myPlace" : myPlace]
                    diarySet.append(currentDiary)
                    UserDefaults.standard.set(diarySet, forKey: "diary")
                
            
            
        } else {
            let currentDiaries = [["myDate" : myDateString, "myDrink" : myDrink, "myPlace" : myPlace]]
                UserDefaults.standard.set(currentDiaries, forKey: "diary")
        }
//        // 値を保存する
//        UserDefaults.standard.set(myDate, forKey: "date")
//        UserDefaults.standard.set(myPlace, forKey: "place")
//        UserDefaults.standard.set(myDrink, forKey: "drink")
        
//        // 保存した値を読み込む
//        UserDefaults.standard.integer(forKey: "integerMyDate")
//        UserDefaults.standard.integer(forKey: "integerTextPlace")
//        UserDefaults.standard.integer(forKey: "integerTextDrink")
//        // 値が保存されたか、存在をチェック
//        if UserDefaults.standard.object(forKey: "integerMyDate") != nil { }
//        if UserDefaults.standard.object(forKey: "integerTextPlace") != nil { }
//        if UserDefaults.standard.object(forKey: "integerMyDrink") != nil { }
//        
//        // シンクロナイズする必要あるのかな？ iOS11から非推奨になってるはず
//        UserDefaults.standard.synchronize()
        
        // 戻るし、保存した
        // saveボタンが押されたら、navigation画面まで戻る
        navigationController?.popToRootViewController(animated: true)
    }
    
  // 後で消すかも。senderをUITextFieldで受けるかどうするか

    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        print(sender.date)
       myDate = sender.date
       //  print(sender, "poppopo")
    }


}

extension UIImage {
    func resizedImage(size _size: CGSize) -> UIImage {
        // アスペクト比を考慮し、変更後のサイズを計算する
        let wRatio = _size.width / size.width
        let hRatio = _size.height / size.height
        let ratio = wRatio < hRatio ? wRatio : hRatio
        let resized = CGSize(
            width: size.width * ratio,
            height: size.height * ratio
        )
        // サイズ変更
        UIGraphicsBeginImageContextWithOptions(resized, false, scale)
        draw(in: CGRect(origin: .zero, size: resized))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
    
}



