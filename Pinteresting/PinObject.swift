//
//  PinItem.swift
//  Pinteresting
//
//  Created by Ty Daniels on 4/4/17.
//  Copyright © 2017 Ty Daniels. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PinObject {
    var id: String?
    var imageURL: String?
    var creatorName: String?
    var linkUrl: String?
    var description: String?
    
    // MARK: - Object initialization
    
    init(name: String) {
        self.creatorName = name
    }
    
    /*
     *Check if key/value pairs matching the model exist. If so,
     *continue verifying JSON key/values then store variable values.
     */
    init?(json: JSON) {
        if json["creator"]["first_name"].string != nil {
            let first = json["creator"]["first_name"].string ?? ""
            let last = json["creator"]["last_name"].string ?? ""
            self.init(name: "\(first) \(last)") //Initialized w/ interpolated first/last creator name.
            
            self.id = json["id"].string ?? ""
            self.imageURL = json["image"]["original"]["url"].string ?? ""
            self.linkUrl = json["url"].string ?? ""
            self.description = json["note"].string ?? ""
            
            return
        }
        
        return nil
    }

}
