//
//  CommentTableViewCell.swift
//  Instagram
//
//  Created by 撫養航 on 2021/03/15.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbl_comment: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    // CommentDataの内容をセルに表示
    func setCommentData(_ commentData: CommentData) {
        
        // キャプションの表示
        self.lbl_comment.text = "\(commentData.name!) : \(commentData.message!)"
        
    }
    
}
