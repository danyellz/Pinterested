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
        PDKClient.sharedInstance().getAuthenticatedUserBoards(withFields: Set(["url", "id", "name", "image", "description", "privacy"]), success: {(response) -> Void in
            
            guard let boards = JSON(response?.parsedJSONDictionary["data"]!).array else {
                print("Unable to retrieve user boards.")
                return
            }
            // MARK : Iterate through response object, storing each board.
            var emptyBoardArr = [BoardObject]()
            for board in boards {
                if let validBoard = BoardObject(json: board) { //Validate JSON object before storing as BoardObject
                    emptyBoardArr.append(validBoard)
                    
                    self.getBoardPins(identifier: validBoard.id, completionHandler: {(pins) -> Void in
                    })
                }
            }
            
            completionHandler(emptyBoardArr) //Pass filled collection to completion
            
        }) {(error) -> Void in
            print(error ?? "Error fetching boards")
        }
    }
    
    // MARK: Get pins for board ID. Used in the board detail view.
    func getBoardPins(identifier: String?, completionHandler: @escaping (_ pins: [PinObject]?) -> Void) {
        PDKClient.sharedInstance().getBoardPins(identifier!, fields: Set(["id", "image", "note", "creator"]), withSuccess: { (response) -> Void in
            
            guard let pins = JSON(response?.parsedJSONDictionary["data"]!).array else {
                print("Unable to parse pin JSON.")
                return
            }
            //Iterate through pin objects. If JSON object is valid, store in Pin model.
            if !pins.isEmpty {
                var emptyPinArr = [PinObject]()
                for pin in pins {
                    if let validPin = PinObject(json: pin) {
                        emptyPinArr.append(validPin)
                    }
                }
                completionHandler(emptyPinArr)
            }
        }) {(error) -> Void in
            print(error ?? "Error fetching pins")
        }
    }
    
    func getFeedItems(completionHandler: @escaping (_ pins: [PinObject]?) -> Void) {
        var emptyPinArr = [PinObject]()
        
        getUserBoards(completionHandler: {(boards) -> Void in
            for board in boards! {
                self.getBoardPins(identifier: board.id!, completionHandler: {(pins) -> Void in
                    for pin in pins! {
                        emptyPinArr.append(pin)
                    }
                    completionHandler(emptyPinArr)
                })
            }
        })
    }
    
    // TODO : Attempted to build a feed of followed boards but am getting a 401 from Pinterest.
    func getFollowedBoards() {
        PDKClient.sharedInstance().getAuthorizedUserFollowedBoards(withFields: Set(["id"]), success: {(response) -> Void in
            
            guard let followedBoards = response?.parsedJSONDictionary else {
                print("Unable to fetch followed boards.")
                return
            }
            
            for board in followedBoards {
                print("Followed board: \(board)")
            }
        }) {(error) -> Void in
            print(error ?? "Error fetching followed boards.")
        }
    }
}
