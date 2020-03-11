//
//  FeedViewController.swift
//  Parstagram
//
//  Created by RAUL RIVERO RUBIO on 3/5/20.
//  Copyright © 2020 codepath-cit238b-spring2020. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let query = PFQuery(className: "Posts")
        
        // Since author is a pointer to another object, it has to fetch the data
        // to disply it
        query.includeKey("author")
        query.limit = 20
        
        // query sequence
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!         // set the array equal to fetched data
                self.tableView.reloadData() // reload the data in the tableview
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        let singlePost = posts[indexPath.row]
        let user = singlePost["author"] as! PFUser
        
        // AlamofireImage
        let imageFile = singlePost["image"] as! PFFileObject
        let urlString =  imageFile.url!
        let url = URL(string: urlString)!
        
        cell.usernameLabel.text = user.username
        cell.captionLabel.text = (singlePost["caption"] as! String)
        cell.photoImageView.af_setImage(withURL: url)
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func logoutEvent(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name : "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.window?.rootViewController = loginViewController
    }
    
}
