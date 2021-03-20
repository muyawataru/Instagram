//
//  HomeViewController.swift
//  Instagram
//
//  Created by 撫養航 on 2021/03/08.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tbl_view: UITableView!
    
    // クラスデータを格納する配列
    var postArray: [PostData] = []
    var commentArray: [CommentData] = []
    
    // Firestoreのリスナー
    var listener: ListenerRegistration?

    override func viewDidLoad() {
        super.viewDidLoad()

        tbl_view.delegate = self
        tbl_view.dataSource = self

        // カスタムセルを登録する
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tbl_view.register(nib, forCellReuseIdentifier: "Cell")
    }
    
    // 画面表示前
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        // ログイン済みか確認
        if Auth.auth().currentUser != nil {
            let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
            let commentsRef = Firestore.firestore().collection(Const.CommentPath).order(by: "date", descending: false)
            // 投稿データの追加や更新を監視
            listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                if error != nil {
                    print("DEBUG_PRINT: 投稿データ - snapshotの取得が失敗しました")
                    return
                }
                // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                self.postArray = querySnapshot!.documents.map { document in
                    print("DEBUG_PRINT: 投稿データ - document取得 \(document.documentID)")
                    let postData = PostData(document: document)
                    return postData
                }
                // TableViewの表示を更新する
                self.tbl_view.reloadData()
            }
            // コメントデータの追加や更新を監視
            listener = commentsRef.addSnapshotListener() { (querySnapshot, error) in
                if error != nil {
                    print("DEBUG_PRINT: コメントデータ - snapshotの取得が失敗しました")
                    return
                }
                // 取得したdocumentをもとにCommentDataを作成し、commentArrayの配列にする。
                self.commentArray = querySnapshot!.documents.map { document in
                    print("DEBUG_PRINT: コメントデータ - document取得 \(document.documentID)")
                    let commentData = CommentData(document: document)
                    return commentData
                }
                // TableViewの表示を更新する
                self.tbl_view.reloadData()
            }
        }
    }
    
    // 画面が消える前
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("DEBUG_PRINT: viewWillDisappear")
        // listenerを削除して監視を停止する
        listener?.remove()
    }
    
    // ---------- tableViewプロトコル ---------- //
    
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }

    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row], commentArray)
        
        // セル内のボタンのアクションをソースコードで設定する
        cell.btn_like.addTarget(self, action:#selector(handleLikeButton(_:forEvent:)), for: .touchUpInside)
        cell.btn_comment.addTarget(self, action:#selector(handleCommentButton(_:forEvent:)), for: .touchUpInside)
        
        return cell
    }
    
    // ---------- オリジナル ---------- //
    
    // いいねボタン - 押下時
    @objc func handleLikeButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: いいねボタンがタップされました。")

        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tbl_view)
        let indexPath = tbl_view.indexPathForRow(at: point)

        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]

        // likesを更新する
        if let myid = Auth.auth().currentUser?.uid {
            // 更新データを作成する
            var updateValue: FieldValue
            if postData.isLiked {
                // すでにいいねをしている場合は、いいね解除のためmyidを取り除く更新データを作成
                updateValue = FieldValue.arrayRemove([myid])
            } else {
                // 今回新たにいいねを押した場合は、myidを追加する更新データを作成
                updateValue = FieldValue.arrayUnion([myid])
            }
            // likesに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["likes": updateValue])
        }
    }
    
    //  コメントボタン - 押下時
    @objc func handleCommentButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: コメントボタンがタップされました。")
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tbl_view)
        let indexPath = tbl_view.indexPathForRow(at: point)

        // 配列からタップされたインデックスのデータをコメント画面へ渡す
        // self.postData = postArray[indexPath!.row]
        let post: PostData!
        let commentViewController = storyboard!.instantiateViewController(withIdentifier: "Comment") as! CommentViewController
        post = postArray[indexPath!.row]
        commentViewController.postData = post
        
        // モーダル画面遷移
        present(commentViewController, animated: true)
    }

}
