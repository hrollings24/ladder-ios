//
//  ChallengeStatus.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 01/03/2021.
//

import Foundation

enum ChallengeStatus: String{
    case documentEmpty = "The challenge was empty"
    case success = "Success"
    case noDocument = "The challenge does not exist"
    case errorRecievingUsers = "Could not retrive users in the challenge"
}
