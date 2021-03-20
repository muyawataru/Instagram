//
//  PostViewController.swift
//  Instagram
//
//  Created by 撫養航 on 2021/03/08.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController {
    
    var image: UIImage!
    
    @IBOutlet weak var img_view: UIImageView!
    @IBOutlet var txt_name: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 受け取った画像を画面に設定する
        img_view.image = image
    }
    
    // 投稿ボタン - 押下時
    @IBAction func handlePostButton(_ sender: Any) {
        // 画像をJPEG形式に変換
        let imageData = image.jpegData(compressionQuality: 0.75)
        // 画像と投稿データの保存場所を定義
        let postRef = Firestore.firestore().collection(Const.PostPath).document()
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")
        // HUDで投稿処理中の表示を開始
        SVProgressHUD.show()
        // Storageに画像をアップロードする
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(imageData!, metadata: metadata) { (metadata, error) in
            if error != nil {
                // 画像のアップロード失敗
                print(error!)
                SVProgressHUD.showError(withStatus: "画像のアップロードが失敗しました")
                // 投稿処理をキャンセルし、先頭画面に戻る
                UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                return
            }
            // FireStoreに投稿データを保存する
            let name = Auth.auth().currentUser?.displayName
            let postDic = [
                "name": name!,
                "caption": self.txt_name.text!,
                "date": FieldValue.serverTimestamp(),
                ] as [String : Any]
            postRef.setData(postDic)
            // HUDで投稿完了を表示する
            SVProgressHUD.showSuccess(withStatus: "投稿しました")
            // 投稿処理が完了したので先頭画面に戻る
            UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    // キャンセルボタン - 押下時
    @IBAction func handleCancelButton(_ sender: Any) {
        // 加工画面に戻る
        self.dismiss(animated: true, completion: nil)
    }
    
}
