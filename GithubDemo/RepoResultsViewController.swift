//
//  ViewController.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

// Main ViewController
class RepoResultsViewController: UIViewController, UITableViewDataSource , UITableViewDelegate, SettingsViewControllerDelegate{

    var searchBar: UISearchBar!
    var searchSettings = GithubRepoSearchSettings()

    @IBOutlet weak var tableView: UITableView!
    var repos: [GithubRepo]!
    var minStars: Int!
    var filteredRepo: [GithubRepo]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 700
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.minStars = 5
        self.filteredRepo = self.repos
        
        // Initialize the UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self

        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar

        // Perform the first search when the view controller first loads
        doSearch()
        print("View did Load")
    }
    
    override func viewDidAppear(animated: Bool) {
        print("View did appear")
        self.filteredRepo = []
        if let repos = self.repos {
            for repo in repos {
                if repo.stars >= self.minStars {
                    self.filteredRepo.append(repo)
                }
                
            }
        }
        self.tableView.reloadData()

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let repos = self.filteredRepo {
            return repos.count
        } else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("codepath.github.repocell", forIndexPath: indexPath) as! RepoCell
        if let repos = self.filteredRepo {

            let repo = repos[indexPath.row]
            cell.nameLabel.text = repo.name
            cell.authorLabel.text = "By " + repo.ownerHandle!
            cell.thumbnailImageView.setImageWithURL(NSURL(string: repo.ownerAvatarURL!)!)
            cell.descriptionLabel.text = repo.repoDescription
            cell.starredLabel.text = "\(repo.stars!)"
            cell.forkedLabel.text = "\(repo.forks!)"
        }
        
        return cell
    }


    // Perform the search.
    private func doSearch() {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)

        // Perform request to GitHub API to get the list of repositories
        GithubRepo.fetchRepos(searchSettings, successCallback: { (newRepos) -> Void in

            // Print the returned repositories to the output window
            self.repos = newRepos
            self.filteredRepo = []
            for repo in newRepos {
                if repo.stars >= self.minStars {
                    self.filteredRepo.append(repo)
                }
                
            }   
            self.tableView.reloadData()
            print("Reloading data")

            MBProgressHUD.hideHUDForView(self.view, animated: true)
            }, error: { (error) -> Void in
                print(error)
        })
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let navigationController = segue.destinationViewController as! UINavigationController
        let settingsViewController = navigationController.topViewController as! SettingsViewController
        settingsViewController.delegate = self
    }
    
    func minimumStars(minStars: Int) {
        self.minStars = minStars
    }
    
}




// SearchBar methods
extension RepoResultsViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }

    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchSettings.searchString = searchBar.text
        searchBar.resignFirstResponder()
        doSearch()
    }
}