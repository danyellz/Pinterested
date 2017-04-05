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
    
    // MARK : Authenticate network function
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
    
    // MARK : Get boards for authenitcated user - me
    func getUserBoards(completionHandler: @escaping (_ boards: [BoardObject]?) -> Void) {
        PDKClient.sharedInstance().getAuthenticatedUserBoards(withFields: Set(["url", "id", "name", "image", "description"]), success: {(response) -> Void in
            
            guard let boards = JSON(response?.parsedJSONDictionary["data"]!).array else {
                print("Unable to retrieve user boards.")
                return
            }
            // MARK : Iterate through response object, storing each board.
            var emptyBoardArr = [BoardObject]()
            for board in boards {
                print(board)
                if let validBoard = BoardObject(json: board) { //Validate JSON object before storing as BoardObject
                    emptyBoardArr.append(validBoard)
                }
            }
            
            completionHandler(emptyBoardArr) //Pass filled collection to completion
            
        }) {(error) -> Void in
            print(error ?? "Error fetching boards")
        }
    }
    
    // MARK: Get pins for board ID. Used in the board detail view.
    func getBoardPins(identifier: String?, completionHandler: @escaping (_ pins: [Any]?) -> Void) {
        PDKClient.sharedInstance().getBoardPins(identifier!, fields: Set(["id", "image", "note"]), withSuccess: { (response) -> Void in
            
            guard let pins = response?.parsedJSONDictionary else {
                print("Unable to parse pin JSON.")
                return
            }
            //Iterate through pin objects, store in Pin model
            if !pins.isEmpty {
                for pin in pins {
                    print("PIN: \(pin)")
                }
            }
            
        }) {(error) -> Void in
            print(error ?? "Error fetching pins")
        }
    }
}
