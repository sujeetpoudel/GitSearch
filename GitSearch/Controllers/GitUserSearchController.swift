//
//  GitUserSearchController.swift
//  GitSearch
//
//  Created by Sujeet on 10/10/19.
//  Copyright © 2019 Sujeet. All rights reserved.
//

import UIKit

class GitUserSearchController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    
    let cellIdentifier = "GitUserCell"
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    var aryGitUserData = [GitUser]()
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tblView.delegate = self
        tblView.dataSource = self
        self.title = "GitHub Searcher"
    }

}

private extension GitUserSearchController {
    
    
    func showLoader() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 0)
            ])
    }
    
    func hideLoader() {
        activityIndicator.removeFromSuperview()
    }
    
    func manageSuccessResponse(withUserModel users: [GitUser]) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.aryGitUserData.removeAll()
            weakSelf.aryGitUserData = users
            weakSelf.tblView.reloadData()
        }
    }
    
    func callSearchUserAPI(withSearchText text: String) {
        
        showLoader()
        let baseURL = NetworkManager.sharedInstance.baseURl
        let endPoint = NetworkManager.EndPoints.searchUser(text).value()
        let strURL = baseURL + endPoint
        let httpMethod = NetworkManager.HttpMethod.get
    
        guard let url = URL(string: strURL) else { return }
        
        NetworkManager.sharedInstance.callWebservice(withUrl: url, httpMethod: httpMethod, parameters: nil, header: nil) { [weak self] (data, response, error) in
            
            guard let weakSelf = self else { return }
            
            DispatchQueue.main.async {
                weakSelf.hideLoader()
            }
            
            if let err = error {
                Alert.showNormalAlertWith(message: err.localizedDescription)
            }
            
            if let data = data, let httpResponse = response as? HTTPURLResponse, !data.isEmpty, httpResponse.statusCode == 200 {
                
                guard
                    let json = try? JSONSerialization.jsonObject(with: data, options:[]),
                    let jsonDictionary = json as? [String:Any],
                    let userData = try? JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted),
                    let user = try? JSONDecoder().decode(UserModel.self
                        , from: userData)
                else {
                    return
                }
                
                weakSelf.manageSuccessResponse(withUserModel: user.items)
                
            }
            
        }
    }
    
}

extension GitUserSearchController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if !isSearching {
            searchBar.showsCancelButton = true
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        callSearchUserAPI(withSearchText: searchText)
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

extension GitUserSearchController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryGitUserData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let userCell = tblView.dequeueReusableCell(withIdentifier: cellIdentifier) as? GitUserCell else {
            return UITableViewCell()
        }
        userCell.userData = aryGitUserData[indexPath.row]
        return userCell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension GitUserSearchController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetail", let destination = segue.destination as? GitUserDetailController {
            let userData = aryGitUserData[tblView.indexPathForSelectedRow!.row]
            destination.profileURL = userData.url
            destination.repoURL = userData.reposURL
        }
    }
}
