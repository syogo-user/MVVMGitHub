//
//  User.swift
//  MVVMGitHub
//
//  Created by 小野寺祥吾 on 2022/01/01.
//

final class User {
    let id: Int
    let name: String
    let iconUrl: String
    let webURL: String
    
    init(attributes: [String:Any]) {
        id = attributes["id"] as! Int
        name = attributes["name"] as! String
        iconUrl = attributes["iconUrl"] as! String
        webURL = attributes["webURL"] as! String
    }
}
