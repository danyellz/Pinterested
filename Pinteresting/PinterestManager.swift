//
//  PinterestManager.swift
//  Pinteresting
//
//  Created by Ty Daniels on 4/4/17.
//  Copyright © 2017 Ty Daniels. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import PinterestSDK

class PinterestManager {
    
    func userAuthenticate(completionHandler: @escaping (_ success: Bool?) -> Void) {
        let permissions = [PDKClientReadPublicPermissions]
        PDKClient.sharedInstance().authenticate(withPermissions: permissions, withSuccess: {(response) -> Void in
            guard response != nil else {
                print("No response from auth.")
                return
            }
            
            completionHandler(true)
            
        }) {(error) -> Void in
            print("PDK auth error: \(error)")
        }
    }
    
    func getUserBoards(completionHandler: @escaping (_ boards: [Any]?) -> Void) {
        PDKClient.sharedInstance().getAuthenticatedUserBoards(withFields: Set(["url", "id", "name"]), success: {(response) -> Void in
            guard let boards = response?.boards() else {
                print("Unable to retrieve user boards.")
                return
            }
            
            for board in boards {
                let board = board as! PDKBoard
//                self.getBoardPins(identifier: board.identifier, completionHandler: {(pins) -> Void in
//                    
//                })
            }
            
        }) {(error) -> Void in
            
        }
    }
    
    func getBoardPins(identifier: String?, completionHandler: @escaping (_ pins: [Any]?) -> Void) {
        
        PDKClient.sharedInstance().getBoardPins(identifier!, fields: Set(["id", "image", "note"]), withSuccess: { (response) -> Void in
            
            guard let pins = response?.parsedJSONDictionary else {
                print("Unable to parse pin JSON.")
                return
            }
            
            if !pins.isEmpty {
                for pin in pins {
                    print(pin)
                }
            }
            
        }) {(error) -> Void in
            print(error)
        }
    }
}
