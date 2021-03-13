//
//  NotificationError.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 13/03/2021.
//

import Foundation

enum NotificationError: String{
    case snapshotcouldnotbeunwrapped = "Error: QuerySnapshot could not be safely unwrapped"
    case message = "Error: Message could not be unwrapped"
    case type = "Error: Type could not be unwrapped"
    case fromUser = "Error: fromUser could not be unwrapped"
    case success = "success"
}
