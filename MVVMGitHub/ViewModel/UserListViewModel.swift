//
//  UserListViewModel.swift
//  MVVMGitHub
//
//  Created by 小野寺祥吾 on 2022/01/01.
//

import Foundation
import UIKit
/*
 現在通信中か、通信が成功したのか、通信が失敗したのかの状態をenumで定義
 */
enum ViewModelState {
    case loading
    case finish
    case error(Error)
}


final class  UserListViewModel   {
    /*
     ViewModelStateをClosureとしてpropaetyで保持、
     この変数がViewControllerに対して通知を送る役割を果たす
     */
    var stateDidUpdate: ((ViewModelState) -> Void )?
    
    /*
     userの配列
     */
    private var users = [User]()
    
    /*
     UserCellViewModelの配列
     */
    var cellviewModels = [UserCellViewModel]()
    
    /*
     Model層で定義したAPIクラスを変数として保持
     */
    let api = API()
    
    /*
     Userの配列を取得
     */
    func getUsers() {
        /*
         .loading通知を送る
         */
        stateDidUpdate?(.loading)
        users.removeAll()
        api.getUsers { (users) in
            self.users.append(contentsOf: users)
            for user in users {
                /*
                 UserCellViewModelの配列を作成
                 */
                let cellViewModel = UserCellViewModel(user:user)
                self.cellviewModels.append(cellViewModel)
                
                /*
                 通信が成功したので、.finish通知を送る
                 */
                self.stateDidUpdate?(.finish)
                print("通信成功")
            }
        } failure: { (error) in
            /*
             通信が失敗したので、.error通知を送る
             */
            self.stateDidUpdate?(.error(error))
            print("通信失敗")
        }
    }
    /*
     tableviewを表示させるために必要なアウトプット
     userListViewModelはtableview全体に対するアウトプットなので
     tableViewのcountに必要なusers.countがアウトプット
     tableViewCellに対するアウトプットはUserCellViewModelが担当
     */
    func usersCount() -> Int {
        return users.count
    }
}
