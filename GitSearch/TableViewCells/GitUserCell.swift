//
//  GitUserCell.swift
//  GitSearch
//
//  Created by Chanappa on 10/10/19.
//  Copyright © 2019 Chanappa. All rights reserved.
//

import UIKit

class GitUserCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userAvatar: AsyncDownloadingImageView!
    @IBOutlet weak var userRepoCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userName.text = nil
        userRepoCount.text = nil
        userAvatar.image = nil
        self.selectionStyle = .none
    }
    
    var userData: GitUser? {
        didSet {
            guard let data = userData else {return}
            userName.text = data.login
            userAvatar.loadImage(withImageURL: data.avatarURL, UIImage(systemName: "person.fill")!)
            userRepoCount.text = ""
            getNumberOfRepo(withRepoURL: data.reposURL!)
        }
    }
    
    
    private func getNumberOfRepo(withRepoURL strUrl: String) {
        guard let url = URL(string: strUrl) else {return}
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let data = data, let httpResponse = response as? HTTPURLResponse, !data.isEmpty, httpResponse.statusCode == 200 {
                
                guard
                    let json = try? JSONSerialization.jsonObject(with: data, options:[]),
                    let jsonArray = json as? [[String:Any]]
                else {
                    return
                }
                DispatchQueue.main.async {
                    self?.userRepoCount.text = "\(jsonArray.count) repos"
                }
            }
            
        }.resume()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
