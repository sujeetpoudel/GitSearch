//
//  AsyncDownloadingImageView.swift
//
//  Created by Chanappa on 22/08/19.
//

import UIKit

let imageCacheManager = NSCache<AnyObject, AnyObject>()

class AsyncDownloadingImageView: UIImageView {
    
    private var imageURL: String?
    
    func loadImage(withImageURL imgURL: String,_ placeholderImage: UIImage) {
        //self.image = nil
        imageURL = imgURL
        checkImageStatus(withImageURL: imgURL, andPlaceHolderImage: placeholderImage)
    }
    
    private func checkImageStatus(withImageURL imgURL: String,andPlaceHolderImage placeholderImage: UIImage) {
        if let cachedImage = imageCacheManager.object(forKey: imgURL as AnyObject) as? UIImage {
            if imageURL == imgURL {
                DispatchQueue.main.async {
                    self.image = cachedImage
                }
            }
        } else {
            self.image = placeholderImage
            downloadImage(withURL: imgURL)
        }
    }
    
    private func downloadImage(withURL imgURL: String) {
        DispatchQueue.global().async { [weak self] in
            guard let weakSelf = self, let imageURL = URL(string: imgURL) else {return}
            URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) in
                DispatchQueue.main.async {
                    if error == nil, let imageData = data, let image = UIImage(data: imageData) {
                        if weakSelf.imageURL == imgURL {
                            weakSelf.image = image
                            imageCacheManager.setObject(image, forKey: imgURL as AnyObject)
                        }
                    }
                }
            }).resume()
        }
    }
    
    
}
