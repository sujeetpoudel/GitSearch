//
//  GitUserDetailController.swift
//  GitSearch
//
//  Created by Chanappa on 10/10/19.
//  Copyright © 2019 Chanappa. All rights reserved.
//

import UIKit


class RepoCell : UITableViewCell {
    
    @IBOutlet weak var StarsLabel: UILabel!
    @IBOutlet weak var ForksLabel: UILabel!
    @IBOutlet weak var RepoName: UILabel!
}



struct RepoModel {
    var full_name : String = ""
    var forks_count : String = ""
    var stargazers_count : String = ""
    var url : String = ""
}

class GitUserDetailController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var avatarImage: AsyncDownloadingImageView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var joinedDateLabel: UILabel!
    
    var profileURL: String?
    var repoURL: String?
    var userData: GitUser?
    var aryRepo: [RepoModelElement] = []
    var filterRepo: [RepoModelElement] = []
    var repoArray : [RepoModel] = []
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.dataSource = self
        tblView.delegate = self
        
        searchBar.delegate = self
        
        
        fetchProfileDetails()
        fetchRepoDetail()
       
    }
    
}

private extension GitUserDetailController {
    
    func fetchProfileDetails() {
        guard let url = URL(string: profileURL!) else { return }
        let httpMethod = NetworkManager.HttpMethod.get
        NetworkManager.sharedInstance.callWebservice(withUrl: url, httpMethod: httpMethod, parameters: nil, header: nil) { [weak self] (data, response, error) in
            
            guard let weakSelf = self else { return }
            
            if let err = error {
                Alert.showNormalAlertWith(message: err.localizedDescription)
            }
            
            if let data = data, let httpResponse = response as? HTTPURLResponse, !data.isEmpty, httpResponse.statusCode == 200 {
                
                guard
                    let json = try? JSONSerialization.jsonObject(with: data, options:[]),
                    let jsonDict = json as? [String: Any],
                    let userData = try? JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted),
                    let user = try? JSONDecoder().decode(GitUser.self
                        , from: userData)
                else {
                    return
                }
                
                
                DispatchQueue.main.async {
                    weakSelf.userName.text = user.login
                    weakSelf.followersLabel.text = user.followers!.description
                    weakSelf.followersLabel.text = user.following!.description
                    weakSelf.avatarImage.loadImage(withImageURL: user.avatarURL, UIImage(systemName: "person.fill")!)
                    weakSelf.locationLabel.text = user.location
                    weakSelf.emailLabel.text = user.email
                    weakSelf.bioLabel.text = user.bio
                    let date = String((user.created_at?.prefix(10) ?? nil)!)
                    weakSelf.joinedDateLabel.text = date
                }
                
            }
            
        }
    }
    
    func fetchRepoDetail() {
        guard let url = URL(string: repoURL!) else { return }
        
        let httpMethod = NetworkManager.HttpMethod.get
        
        NetworkManager.sharedInstance.callWebservice(withUrl: url, httpMethod: httpMethod, parameters: nil, header: nil) { [weak self] (data, response, error) in
            
            guard let weakSelf = self else { return }
            
            if let err = error {
                Alert.showNormalAlertWith(message: err.localizedDescription)
            }
            
            if let data = data, let httpResponse = response as? HTTPURLResponse, !data.isEmpty, httpResponse.statusCode == 200 {
                
                guard
                    let json = try? JSONSerialization.jsonObject(with: data, options:[]) as! NSArray
                else {
                    return
                }
                
                
                for index in 0..<json.count {
                    let jsonDict = json[index] as! NSDictionary
                    var repoModel = RepoModel()
                    
                    print(jsonDict["name"]!)
                    print(jsonDict["forks_count"]!)
                    print(jsonDict["stargazers_count"]!)
                    
                    repoModel.full_name = jsonDict["name"]! as! String
                    repoModel.forks_count = String(describing: jsonDict["forks_count"]!)
                    repoModel.stargazers_count = String(describing: jsonDict["forks_count"]!)
                    repoModel.url = jsonDict["svn_url"]! as! String
                    self?.repoArray.append(repoModel)
                    
                    
                }
                
                
                DispatchQueue.main.async {
                    weakSelf.tblView.reloadData()
                }
                
            }
            
        }
    }
}

extension GitUserDetailController: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RepoCell
        cell.RepoName.text = repoArray[indexPath.row].full_name
        cell.ForksLabel.text = repoArray[indexPath.row].forks_count
        cell.StarsLabel.text = repoArray[indexPath.row].stargazers_count
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.openURL(NSURL(string: repoArray[indexPath.row].url) as! URL)
    }
    
    
    
}

extension GitUserDetailController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if !isSearching {
            searchBar.showsCancelButton = true
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var repoArray2 : [RepoModel] = []
        for index in 0..<self.repoArray.count {
            if searchText.lowercased() == repoArray[index].full_name.prefix(searchText.count).lowercased() {
                repoArray2.append(repoArray[index])
            }
        }
        repoArray = repoArray2
        tblView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.searchTextField.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.searchTextField.resignFirstResponder()
    }
}

