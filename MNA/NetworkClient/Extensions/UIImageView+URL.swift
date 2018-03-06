//
//  UIImageView+URL.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 01/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

extension UIImageView{
    //MARK: - Constants
    private struct AssociationKey{
        static var dataTask = "ap_dataTask"
        static var session = "ap_imageDownloadSession"
    }
    
    // MARK: - Static Properties
    public static let imageDownloader = URLSession(configuration: .default)
    
    // MARK: - Instance Properties
    public var dataTask:URLSessionDataTask?{
        get{
            return objc_getAssociatedObject(self, &AssociationKey.dataTask) as? URLSessionDataTask
        }set{
            dataTask?.cancel()
            objc_setAssociatedObject(self, &AssociationKey.dataTask, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: - Instance Methods
    @discardableResult public func ap_setImage(url:URL?)-> URLSessionDataTask?{
        guard let url = url else {
            self.dataTask = nil
            image = nil
            return nil
        }
        
        let dataTask = UIImageView.imageDownloader.dataTask(with: url) {[weak self] (data, response, error) in
            guard let strongSelf = self else{return}
            guard let data = data, let image = UIImage(data: data) else{
                print("Image Download failed: \(String(describing: error))")
                strongSelf.image = UIImage(named: "img-placeholder")//nil
                return
            }
            DispatchQueue.main.async {
                [weak self] in
                guard let strongSelf = self else{return}
                strongSelf.image = image
            }
        }
        dataTask.resume()
        self.dataTask = dataTask
        return dataTask
    }
}
