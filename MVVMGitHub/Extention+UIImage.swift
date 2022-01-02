//
//  Extention+UIImage.swift
//  MVVMGitHub
//
//  Created by 小野寺祥吾 on 2022/01/01.
//

import UIKit
extension UIImage {
    convenience init?(color:UIColor, size: CGSize){
        let rect = CGRect(origin:.zero, size:size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false , 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage:cgImage)        
    }
}
