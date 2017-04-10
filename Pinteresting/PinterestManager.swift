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
    
    /*
     NOTE : Attempted to build a feed of followed boards but am getting a 401 from Pinterest.
     Initally I was planning to create a somewhat real-time feed of pin activity from all followed
     boards. However, a workaround for this problem is to use my user's board pins for proof-of-concept.
     */
    /*
     NOTE: Given the timeframe I designed a 'spoofed' feed experience by appending my own board pins. Ideally,
     This function would iterate followed boards with some kind of cap on the number of response objects.
     One way might be to pass a function parameter (next: Int) each time a new request is made. Previous
     query items might be stored using Core or Realm.
     */
    
    // MARK : Authenticate into pinterest, fetching auth for SDK usage
    func userAuthenticate(completionHandler: @escaping (_ success: Bool?) -> Void) {
        let permissions = [PDKClientReadPublicPermissions]
        PDKClient.sharedInstance().authenticate(withPermissions: permissions, withSuccess: {(response) -> Void in
            //Check for nil reponse
            guard response != nil else {
                print("No response from auth.")
                return
            }
            completionHandler(true) //Completion bool to trigger a segue in the main navigationcontroller
            
        }) {(error) -> Void in
            print("PDK auth error: \(error)")
        }
    }
    
    // MARK : getUserBoards for authenitcated user -- me
    func getUserBoards(completionHandler: @escaping (_ boards: [BoardObject]?) -> Void) {
        PDKClient.sharedInstance().getAuthenticatedUserBoards(withFields: Set(["url", "id", "name", "image", "description", "privacy"]), success: {(response) -> Void in
            
            let parsedDict = response?.parsedJSONDictionary["data"] ?? []
            guard let boards = JSON(parsedDict).array else {
                print("Unable to retrieve user boards.")
                return
            }
            
            //Iteration through board objects for further parsing. If JSON object is valid, store in Board model.
            var emptyBoardArr = [BoardObject]()
            for board in boards {
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
    func getBoardPins(identifier: String?, completionHandler: @escaping (_ pins: [PinObject]?) -> Void) {
        PDKClient.sharedInstance().getBoardPins(identifier!, fields: Set(["id", "image", "note", "creator"]), withSuccess: { (response) -> Void in
            
            let parsedDict = response?.parsedJSONDictionary["data"] ?? []
            guard let pins = JSON(parsedDict).array else {
                print("Unable to parse pin JSON.")
                return
            }
            
            //Iteration through pin objects for further parsing. If JSON object is valid, store in Pin model.
            if !pins.isEmpty {
                var emptyPinArr = [PinObject]()
                for pin in pins {
                    print("BOARDPIN: \(pin)")
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
    
    //Network helper for 'feed' pin objects
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
    
    //Get user's followed boards
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
