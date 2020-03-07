//
//  CamaraViewController.swift
//  Parstagram
//
//  Created by RAUL RIVERO RUBIO on 3/5/20.
//  Copyright © 2020 codepath-cit238b-spring2020. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class CamaraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitEvent(_ sender: Any) {
        let post = PFObject(className: "Pets") // like a dictionary of [Parse]
        // save it separate table for the photos
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        
        post["caption"] = commentTextField.text
        post["author"] = PFUser.current()!
        post["image"] =  file        // this column will have the url for the image
        
        // save the dictionary[{Parse]
        post.saveInBackground{(success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("saved")
            } else {
                print("error! (saving)")
            }
        }
    }
    
    @IBAction func cameraEvent(_ sender: Any) {
        let picker = UIImagePickerController()
        // when the user have taken a photo, notify picker.delegate about that photo.
        picker.delegate = self
        // present a second screen to allow the user to edit the image if he wishes to.
        picker.allowsEditing = true
        
        // If the camera resource is available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera         // use the camere
        } else {
            picker.sourceType = .photoLibrary   // use photo gallery
        }
        
        // executes the picker (camera / photo gallery)
        present(picker, animated: true, completion: nil)
    }
    
    // Get image dictionary
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 300, height: 300)
        // scall it down
        let scaledImage = image.af_imageScaled(to: size)
        
        // insert that scall image inside this imageview
        imageView.image = scaledImage
        
        // dismiss the camera view
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
