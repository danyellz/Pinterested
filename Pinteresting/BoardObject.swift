//
//  BoardTemplate.swift
//  Pinteresting
//
//  Created by Ty Daniels on 4/4/17.
//  Copyright © 2017 Ty Daniels. All rights reserved.
//

import Foundation
import SwiftyJSON

class BoardObject {
    var id: String?
    var imageURL: String?
    var name: String?
    var linkUrl: String?
    var description: String?
    
    // MARK: - Object initialization
    
    init(name: String) {
        self.name = name
    }
    
    /*
     *Check if key/value pairs matching the model exist. If so,
     *continue verifying JSON key/values then store variable values.
     */
    convenience init?(json: JSON) {
        if let name = json["name"].string {
            self.init(name: name)
            self.id = json["id"].string ?? ""
            self.imageURL = json["image"]["60x60"]["url"].string ?? ""
            self.linkUrl = json["url"].string ?? ""
            self.description = json["description"].string ?? ""
            
            return
        }
        
        return nil
    }
}
