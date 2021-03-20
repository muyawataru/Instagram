//
//  CommentViewController.swift
//  Instagram
//
//  Created by 撫養航 on 2021/03/14.
//

import UIKit
import Firebase
import SVProgressHUD

class CommentViewController: UIViewController {
    
    @IBOutlet weak var txt_comment: UITextField!
    
    var postData: PostData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // コメント送信ボタン - 押下時
    @IBAction func handleCommentButton(_ sender: Any) {
        // コメントデータの保存場所を定義
        let commentRef = Firestore.firestore().collection(Const.CommentPath).document()
        // HUDでコメント送信処理中の表示を開始
        SVProgressHUD.show()
        
        // FireStoreに投稿データを保存する
        let name = Auth.auth().currentUser?.displayName
        let commentDic = [
            "name": name!,
            "comment": self.txt_comment.text!,
            "post_id": postData.id,
            "date": FieldValue.serverTimestamp(),
            ] as [String : Any]
        commentRef.setData(commentDic)
        // HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "コメントを送信しました")
        // 画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    // キャンセルボタン - 押下時
    @IBAction func handleCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
