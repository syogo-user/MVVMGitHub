//
//  User.swift
//  MVVMGitHub
//
//  Created by 小野寺祥吾 on 2022/01/01.
//

final class User {
    let id: Int
    let login: String
    let avatar_url: String
    let html_url: String
    
    init(attributes: [String:Any]) {
        id = attributes["id"] as! Int
        login = attributes["login"] as! String
        avatar_url = attributes["avatar_url"] as! String
        html_url = attributes["html_url"] as! String
    }
}
