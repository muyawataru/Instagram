//
//  TabBarControllerViewController.swift
//  Instagram
//
//  Created by 撫養航 on 2021/03/08.
//

import UIKit
import Firebase

class TabBarControllerViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // タブアイコンの色
        self.tabBar.tintColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        // タブバーの背景色
        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        // UITabBarControllerDelegateプロトコルのメソッドをこのクラスで処理する。
        self.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // currentUserがnilならログインしていない
        if Auth.auth().currentUser == nil {
            // ログイン画面にモーダル画面遷移
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!, animated: true, completion: nil)
        }
    }

    // タブアイコン、タップ時（タブ切り替えして良いか否かを応答）
    // 補足：　引数（viewController）に、切り替え先の画面（viewControllerインスタンス）が入っている
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController is ImageSelectViewController {
            // ImageSelectViewControllerは、タブ切り替えではなくモーダル画面遷移する
            let imageSelectViewController = storyboard!.instantiateViewController(withIdentifier: "ImageSelect")
            present(imageSelectViewController, animated: true)
            // タブ切り替えをしない
            return false
        } else {
            // タブ切り替えをする
            return true
        }
    }
}
