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
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    let commentBar = MessageInputBar();
    var isCommentBarVisible = false
    var posts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notifCenter = NotificationCenter.default
        
        commentBar.inputTextView.placeholder = "Post a comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // dismiss keyboard by dragging down with the table view
        tableView.keyboardDismissMode = .interactive
        
        // Notify with notification with a event happends
        notifCenter.addObserver(self, selector: #selector(HideKeyBoard(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func HideKeyBoard(note: Notification) {
        commentBar.inputTextView.text = nil
        isCommentBarVisible = false
        becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let query = PFQuery(className: "Posts")
        
        // Since author is a pointer to another object, it has to fetch the data
        // to disply it
        query.includeKeys(["author", "comments", "comments.author"])
        query.limit = 20
        
        // query sequence
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!         // set the array equal to fetched data
                self.tableView.reloadData() // reload the data in the tableview
            }
        }
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        // Create the comment
        
        // Clear dismmiss the  input bar
        commentBar.inputTextView.text = nil
        isCommentBarVisible = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    // MessageInputBar
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return isCommentBarVisible
    }
    //--
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let singlePost = posts[section]
        let comments = singlePost["comments"] as? [PFObject] ?? []
        
        return comments.count + 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let singlePost = posts[indexPath.section]
        let comments = (singlePost["comments"] as? [PFObject]) ?? []
        
        if  indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
            let user = singlePost["author"] as! PFUser
            
            // AlamofireImage
            let imageFile = singlePost["image"] as! PFFileObject
            let urlString =  imageFile.url!
            let url = URL(string: urlString)!
            
            cell.usernameLabel.text = user.username
            cell.captionLabel.text = (singlePost["caption"] as! String)
            cell.photoImageView.af_setImage(withURL: url)
            return cell
        } else if indexPath.row <= comments.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            let singleComment = comments[indexPath.row - 1]
            let user = singleComment["author"] as! PFUser
            
            cell.nameLabel.text = user.username
            cell.commentLabel.text = singleComment["text"] as? String
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singlePost = posts[indexPath.section]
        let comments = (singlePost["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == comments.count + 1 {
            isCommentBarVisible = true
            
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
        }
        
//        comment["text"] = "Random comment"
//        comment["post"] = singlePost
//        comment["author"] = PFUser.current()
//
//        // add comment to "comments" array
//        post.add(comment, forKey: "comments")
//
//        post.saveInBackground { (success, error) in
//            if success {
//                print("Comment saved")
//            } else {
//                print("Error saving comment")
//            }
//        }
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
