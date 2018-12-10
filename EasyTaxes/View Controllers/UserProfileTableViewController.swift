//
//  UserProfileTableViewController.swift
//  EasyTaxes
//
//  Created by Joel Gutierrez on 11/23/18.
//  Copyright © 2018 Joel Gutierrez. All rights reserved.
//

import UIKit

class UserProfileTableViewController: UITableViewController, AddFormDelegate {
    //MARK: - class variables
    var currUser: Profile!
    var profilesModel = ProfilesModel.sharedInstance
    var userIndex = 0
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currUser = profilesModel.profile(atIndex: userIndex)
        self.setNavBarTitle()
        self.registerNibs()
    }
    
    //MARK: - helper functions
    //set nav bar title
    func setNavBarTitle() {
        self.title = currUser.getName()
    }

    //register nibs - large profile tv cell, past form info tv cell
    func registerNibs() {
        let largeProfileNib = UINib.init(nibName: "LargeProfileTableViewCell", bundle: nil)
        self.tableView.register(largeProfileNib, forCellReuseIdentifier: "LargeProfileCell")
        
        let pastInfoNib = UINib.init(nibName: "PastFormInfoTableViewCell", bundle: nil)
        self.tableView.register(pastInfoNib, forCellReuseIdentifier: "PastFormInfoCell")
    }
    
    //input: float number, output: the float number is currency format - ie: "$123,000.00"
    func getCurrencyString(number: Float) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2 //1 for the profile information, 1 for displaying past forms
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1 //only 1 cell to display the profiles general information
        } else {
            let temp = profilesModel.profile(atIndex: userIndex)
            return temp!.getFormCount() //the number of forms the user has created
        }
    }

    //create profile cell or past form info cell, fill both out
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let largeProfileCell : LargeProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LargeProfileCell", for: indexPath) as! LargeProfileTableViewCell
            largeProfileCell.selectionStyle = .none
            largeProfileCell.setImageAndLabel(profileImage: currUser.getUIImage(), name: currUser.getName())
            largeProfileCell.setInfo(address1: currUser.getAddress1(), address2: currUser.getAddress2(), birth: currUser.getBirthdate(), phone: currUser.getPhoneNumber())
            return largeProfileCell
        } else {
            let pastFormInfoCell : PastFormInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PastFormInfoCell", for: indexPath) as! PastFormInfoTableViewCell
            pastFormInfoCell.selectionStyle = .none
            var result = ""
            var isGreen = false
            var date = ""
            let temp = profilesModel.profile(atIndex: userIndex)
            if let form = temp?.form(atIndex: indexPath.row) {
                if form.getLine13() != 0 {
                    result = "+" + getCurrencyString(number: form.getLine13())
                    isGreen = true
                } else {
                    result = "-" + getCurrencyString(number: form.getLine14())
                }
                date = form.getDateCreated()
            }
            pastFormInfoCell.setTitleAndDetail(left: date, right: result, isGreen: isGreen)
            return pastFormInfoCell
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false //the profile cell should not be able to be deleted
        } else {
            return true //allow the past forms rows to be deleted
        }
    }

    //delete a row from the data model and from the tableview
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            profilesModel.deleteFormFromUser(userIndex: userIndex, formIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }  
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Past 1040EZ Forms: " //header for the forms section
        } else {
            return "" //no header for the profile information section
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150 //height size of the profile info cell
        } else {
            return 44.0 //height size of the past form info cell
        }
    }
    
    //MARK: - table view delegate
    //if a row from past form info section is selected - go to the the add form vc (prefilled though)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            performSegue(withIdentifier: "addFormSegue", sender: indexPath)
        }
    }
    
    //MARK: - add form delegate
    //add form delegate implementation - add the form to the user, then reload the table view
    func addFormToTVC(form: Form) {
        profilesModel.addFormToUser(index: userIndex, form: form)
        self.tableView?.reloadData()
    }
    

    //MARK: - IBActions
    //if the left nav bar button is tapped - exit the current view controller
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    
    // MARK: - Navigation
    //go to the add form view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addFormSegue" && sender as? IndexPath != nil { //have the fields prefilled
            if let addFormVC = segue.destination as? AddFormViewController {
                addFormVC.isPrefilled = true
                if let indexPath = sender as? IndexPath {
                    let currUserForm = profilesModel.profile(atIndex: userIndex)?.form(atIndex: indexPath.row)
                    addFormVC.currForm = currUserForm
                }
            }
        } else {
            if let addFormVC = segue.destination as? AddFormViewController { //fresh form to be shown
                addFormVC.delegate = self
            }
        }
    }

}
