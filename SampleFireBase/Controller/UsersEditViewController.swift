//
//  UsersEditViewController.swift
//  SampleFirebase
//
//  Created by Hajime Takeuchi on 2019/12/04.
//  Copyright © 2019 Hajime Takeuchi. All rights reserved.
//

import UIKit
import Firebase

class UsersEditViewController: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var favoriteFoodText: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var user: User!
    var key: String!
    var displayMode: DisplayMode = .insert
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayInit(displayMode)
    }
    
    // MARK: - EventFunctions
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        
        let ref = Database.database().reference()
        
        // 入力内容をUserインスタンスに入れる
        var newUser = User()
        newUser.name = nameText.text!
        newUser.age = Int(ageText.text!) ?? 0
        newUser.favoriteFood = favoriteFoodText.text!
        
        if(displayMode == .insert) {
            // データを登録
            ref.child("Users").childByAutoId().setValue(newUser.toDictionary)
        } else {
            // データを更新
            ref.child("Users").child(key).setValue(newUser.toDictionary)
        }
        
        // 処理終了後 前画面に戻る
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - PrivateFunctions
    private func displayInit(_ displayMode: DisplayMode) {
        
        switch displayMode {
        case .insert:
            submitButton.setTitle("登録する", for: .normal)
            
        case .update:
            submitButton.setTitle("更新する", for: .normal)
            nameText.text = user.name
            ageText.text = String(user.age)
            favoriteFoodText.text = user.favoriteFood
            
        }
    }
}
