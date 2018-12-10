//
//  ProfileCollectionViewController.swift
//  EasyTaxes
//
//  Created by Joel Gutierrez on 11/16/18.
//  Copyright © 2018 Joel Gutierrez. All rights reserved.
//

import UIKit
import GoogleSignIn

class ProfileCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, GIDSignInUIDelegate, AddProfileDelegate, UIGestureRecognizerDelegate {
    //MARK: - class variables
    var sectionsForCVC : Int = 2
    var itemsPerLineForProfile: Int = 2
    var ImageHeightForProfile: Int = 100
    var sectionInsetForProfile: Int = 10
    var minInterItemSpacingForProfile: Int = 10
    var phoneWidth: Int = Int(UIScreen.main.bounds.size.width)
    var numberOfProfiles: Int?
    var profilesModel = ProfilesModel.sharedInstance
    
    //MARK: - lifecycle
    //set up view controller
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDataSourceAndDelegates()
        self.setViewControllerTitle()
        self.registerNibs()
        self.enableLPGestureRecognizerOnCV()
    }
    
    //enable long press gesture recognizer on profile cells
    func enableLPGestureRecognizerOnCV() {
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        self.collectionView?.addGestureRecognizer(lpgr)
    }
    
    //set datasource and delegate for cv and for google sign in
    func setDataSourceAndDelegates() {
        self.collectionView!.delegate = self
        self.collectionView!.dataSource = self
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    //set nav bar title of cvc
    func setViewControllerTitle() {
        self.title = "Profiles Managed"
    }
    
    //register nibs: large header title cv cell, profile cv cells
    func registerNibs() {
        let largeHeaderNib = UINib.init(nibName: "LargeHeaderCollectionViewCell", bundle: nil)
        self.collectionView?.register(largeHeaderNib, forCellWithReuseIdentifier: "largeHeaderCell")

        let profileNib = UINib.init(nibName: "ProfileCollectionViewCell", bundle: nil)
        self.collectionView?.register(profileNib, forCellWithReuseIdentifier: "profileCell")
    }
    
    //MARK: - gesture recognizer delegate
    //if gesture on cell is a long press - display action sheet
    @objc func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
        if (gestureRecognizer.state != UIGestureRecognizerState.ended){
            return
        }
        
        let p = gestureRecognizer.location(in: self.collectionView)
        
        if let indexPath = self.collectionView?.indexPathForItem(at: p){
            confirmDeleteActionSheet(indexPath: indexPath)
        }
    }
    
    //display action sheet to delete user or cancel
    func confirmDeleteActionSheet(indexPath: IndexPath) {
        let alertcontroller = UIAlertController(title: "Caution", message: "Do you want to delete the selected profile?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let clearAllAction = UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            self.profilesModel.removeProfile(atIndex: indexPath.item)
            self.collectionView?.deleteItems(at: [indexPath])
        })
        
        alertcontroller.addAction(cancelAction)
        alertcontroller.addAction(clearAllAction)
        
        self.present(alertcontroller, animated: true, completion: nil)
    }
    
    
    //MARK: - AddProfileDelegate
    //delegate method implementation. add to data model and then reload the collection view
    func addProfileToCVC(profile: Profile) {
        profilesModel.addProfile(profile: profile)
        self.collectionView?.reloadData()
    }

    
    // MARK: - UICollectionViewDataSource
    //number of sections = 2,  1 for header and 1 for profiles
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionsForCVC
    }

    //section 1 has a header cell and section 2 is the number of profiles in the data model
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else {
            return profilesModel.numberOfProfiles()
        }
    }

    //make either a header cell or a profile cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let headerCell : LargeHeaderCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "largeHeaderCell", for: indexPath) as! LargeHeaderCollectionViewCell
            headerCell.setTitleLabel(title: "List of profiles you manage:")
            return headerCell
        } else {
            let profileCell : ProfileCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath) as! ProfileCollectionViewCell
            let profile = profilesModel.profile(atIndex: indexPath.item)
            profileCell.setTitleAndPicture(title: (profile?.getName())!, image: (profile?.getUIImage())!)
            return profileCell
        }
    }
    
    
    //MARK: - UICollectionViewDelegateFlowLayout
    //make create cell of size either for header cell or for profile cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize.init(width: phoneWidth, height: 60)
        } else {
            return self.getItemSizeForProfile()
        }
    }
    
    //make the inset size for either the header cell or the profile cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsetsMake(0, 0, 0, 0)
        } else {
            return UIEdgeInsetsMake(CGFloat(sectionInsetForProfile), CGFloat(sectionInsetForProfile), CGFloat(sectionInsetForProfile), CGFloat(sectionInsetForProfile))
        }
    }

    //get the size of a profile cv cell in cgsize format
    func getItemSizeForProfile() -> CGSize {
        let layout: UICollectionViewFlowLayout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout;
        let width = ((phoneWidth - (minInterItemSpacingForProfile * (itemsPerLineForProfile - 1)) - (2 * sectionInsetForProfile)) / itemsPerLineForProfile);
        let height = width;
        layout.itemSize = CGSize.init(width: width, height: height);
        return layout.itemSize;
    }
    // MARK: - UICollectionViewDelegate
    //if item is selected go to the selected users profile page
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "userProfileSegue", sender: indexPath)
    }
    
    //MARK: - IBActions
    @IBAction func signOutTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "signInVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = signInVC
    }
    
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addProfileSegue" {
            if let addProfileVC = segue.destination as? AddProfileViewController { //check if going to add profile vc
                addProfileVC.delegate = self
            }
        } else if segue.identifier == "userProfileSegue" {
            if let profileVC = segue.destination as? UserProfileTableViewController { //check if going to user profile vc
                if let indexPath = sender as? IndexPath {
                    profileVC.userIndex = indexPath.item
                }
            }
        }
     }
}
