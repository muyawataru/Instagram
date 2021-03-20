//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 撫養航 on 2021/03/14.
//

import UIKit
import Firebase
import FirebaseUI

class PostTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var img_view: UIImageView!
    @IBOutlet weak var btn_like: UIButton!
    @IBOutlet weak var lbl_like: UILabel!
    @IBOutlet weak var btn_comment: UIButton!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_caption: UILabel!
    @IBOutlet weak var tbl_comment: UITableView!
    
    // コメントデータを格納する配列
    var commentArray: [CommentData] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    // PostDataの内容をセルに表示
    func setPostData(_ postData: PostData) {
        // 画像の表示
        img_view.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        img_view.sd_setImage(with: imageRef)
        
        // キャプションの表示
        self.lbl_caption.text = "\(postData.name!) : \(postData.caption!)"

        // 日時の表示
        self.lbl_date.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            self.lbl_date.text = dateString
        }

        // いいね数の表示
        let likeNumber = postData.likes.count
        lbl_like.text = "\(likeNumber)"

        // いいねボタンの表示
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.btn_like.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.btn_like.setImage(buttonImage, for: .normal)
        }
    }
    
    // ---------- tableViewプロトコル ---------- //
    
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }

    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(commentArray[indexPath.row])
        
        return cell
    }
    
}
