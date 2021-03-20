//
//  commentData.swift
//  Instagram
//
//  Created by 撫養航 on 2021/03/14.
//

import UIKit
import Firebase

class CommentData: NSObject {
    
    var id: String
    var date: Date?
    var name: String?
    var comment: String?
    var post_id: String?

    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID

        let commentDic = document.data()

        self.name = commentDic["name"] as? String

        self.comment = commentDic["comment"] as? String
        
        let timestamp = commentDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        
        self.post_id = commentDic["post_id"] as? String
    }
}
