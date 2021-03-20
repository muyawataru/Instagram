//
//  Const.swift
//  Instagram
//
//  Created by 撫養航 on 2021/03/14.
//

import Foundation

struct Const {
    
    // Storage内の画像ファイルの保存場所
    static let ImagePath = "images"
    // Firestore内の投稿データ（投稿者名、キャプション、投稿日時等）の保存場所
    static let PostPath = "posts"
    // Firestore内の投稿データ（返信者名、コメント）の保存場所
    static let CommentPath = "comments"
}
