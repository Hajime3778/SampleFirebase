//
//  UserListViewController.swift
//  SampleFirebase
//
//  Created by Hajime Takeuchi on 2019/12/03.
//  Copyright © 2019 Hajime Takeuchi. All rights reserved.
//

import UIKit
import Firebase

class UsersListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var usersTableView: UITableView!
    var keys: [String]!
    var users: [User]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersTableView.dataSource = self
        usersTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let ref = Database.database().reference()
        
        ref.child("Users").observe(.value) { (snapshot) in
            // 初期化
            self.keys = []
            self.users = []
            
            for data in snapshot.children {
                let snapData = data as! DataSnapshot
                let dictionarySnapData = snapData.value as! [String: Any]
                
                // Keyを取得して格納する
                let key: String = (data as AnyObject).key
                self.keys.append(key)
                
                // 取得した内容をユーザー型にセット
                var user = User()
                user.setFromDictionary(dictionarySnapData)
                
                // ユーザーリストに追加
                self.users.append(user)
            }
            
            // すべてユーザーリストに格納したら、TableViewを更新する。
            self.usersTableView.reloadData()
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let sb: UIStoryboard = self.storyboard!
        let vc = sb.instantiateViewController(withIdentifier: "UsersEditViewController") as! UsersEditViewController
        vc.displayMode = .insert
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - TableViewFunctions
    // セルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _users = users else { return 0 }
        return _users.count
    }
    // セルに値をセット
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = usersTableView.dequeueReusableCell(withIdentifier: "UserTableCell", for: indexPath)
        
        let user = users[indexPath.row]
        
        let nameLabel = cell.viewWithTag(1) as! UILabel
        nameLabel.text = user.name
        
        let ageLabel = cell.viewWithTag(2) as! UILabel
        ageLabel.text = String(user.age)
        
        let favoriteLabel = cell.viewWithTag(3) as! UILabel
        favoriteLabel.text = user.favoriteFood
        
        return cell
    }
    // セルタップ時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let sb: UIStoryboard = self.storyboard!
        let vc = sb.instantiateViewController(withIdentifier: "UsersEditViewController") as! UsersEditViewController
        
        vc.key = keys[indexPath.row]
        vc.user = users[indexPath.row]
        vc.displayMode = .update
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // セルスワイプ時(削除)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "削除") {
            (action, sourceView, completionHandler) in completionHandler(true)
            
            let ref = Database.database().reference()
            ref.child("Users").child(self.keys[indexPath.row]).removeValue()
        }
        let swipeAction = UISwipeActionsConfiguration(actions: [delete])
        swipeAction.performsFirstActionWithFullSwipe = true
        return swipeAction
    }
    
}
