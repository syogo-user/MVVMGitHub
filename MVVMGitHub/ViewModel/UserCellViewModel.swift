//
//  UserCellViewModel.swift
//  MVVMGitHub
//
//  Created by 小野寺祥吾 on 2022/01/01.
//

import Foundation
import UIKit

/*
現在ダウンロード中華、ダウンロード終了化、エラー家の状態をenumで定義
 */
enum ImageDownloadProgress {
    case loading(UIImage)
    case finish(UIImage)
    case error
}
final class UserCellViewModel {
    /*
     ユーザーを変数として保持
     */
    private var user: User
    
    /*
     ImageDownloader を変数として保持
     */
    private let imageDownloader = ImageDownloader()
    
    /*
     ImageDownloaderでダウンロード中かどうかをBool変数として保持
     */
    private var isLoading = false
    
    /*
     Cellに反映させるアウトプット
     */
    var nickName: String {
        return user.login
    }
    
    /*
     Cellを選択したときに必要なwegURL
     */
    var html_url: URL {
        return URL(string: user.html_url)!
    }
    
    /*
     userを引数にinit
     */
    init(user: User) {
        self.user = user
    }
    
    /*
     imageDownloaderを使ってダウンロードし
     その結果をImageDownloadProgressとしてClosureで返している
     */
    func downloadImage(progress:@escaping (ImageDownloadProgress) -> Void) {
        /*
         isLoadingがtrueだったら、returnしている。このメソッドはcellForRowメソッドで呼ばれることを想定しているため、何回も
         ダウンロードしないためにisLoadingをしようしている
         */
        
        if isLoading == true {
            return
        }
        isLoading = true
        
        /*
         grayのUIImageの作成
         */
        let loadingImage = UIImage(color: .gray, size: CGSize(width: 45, height: 45))!
        
        /*
         .loadingをClosureで返している
         */
        progress(.loading(loadingImage))
        
        /*
         imageDownloaderを用いて、画像をダウンロードしている。
         引数に、user.iconUrlを使っている
         ダウンロードが終了したら、.finishをClosureで返している
         */
        imageDownloader.downloadImage(imageURL: user.avatar_url) { (image) in
            progress(.finish(image))
        } failure: { (error) in
            progress(.error)
            self.isLoading = false
        }
        
    }
    
}
