//
//  ProfilesModel.swift
//  EasyTaxes
//
//  Created by Joel Gutierrez on 11/28/18.
//  Copyright © 2018 Joel Gutierrez. All rights reserved.
//

import Foundation

class ProfilesModel {
    //MARK: - class variables
    public var profiles = [Profile]()
    static let sharedInstance = ProfilesModel()
    
    //MARK: - constructor
    //default user given
    init() {
        let profile = Profile.init(name: "Joel Gutierrez", image: #imageLiteral(resourceName: "usericon") , birthdate: "01/23/91", address1: "153 southeast lane", address2: "mountain view, CA, 90723", phoneNumber: "555-555-5555")
        self.profiles.append(profile)
    }
    
    //MARK: - class functions
    //input: index and form
    //index is used to find specific user
    //form is added to the specified user
    func addFormToUser(index: Int, form: Form) {
        profiles[index].addForm(form: form)
    }
    
    //input: userindex and formindex
    //userindex is used to find specific user
    //formindex is used to delete the specific form from the user
    func deleteFormFromUser(userIndex: Int, formIndex: Int) {
        profiles[userIndex].deleteForm(atIndex: formIndex)
    }

    //returns the number of profiles in this model
    func numberOfProfiles() -> Int {
        return profiles.count
    }
    
    //input: index
    //returns the user corresponding to the specified index (if availble)
    func profile(atIndex: Int) -> Profile? {
        if (atIndex >= 0 && atIndex < numberOfProfiles()) {
            return profiles[atIndex]
        } else {
            return nil
        }
    }
    
    //input: profile atindex
    //deletes the profile corresponding to the index from the data model
    func removeProfile(atIndex: Int) {
        profiles.remove(at: atIndex)
    }
    
    //input: a profile
    //the user is added to the data model
    func addProfile(profile: Profile) {
        profiles.append(profile)
    }
}
