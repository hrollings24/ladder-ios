//
//  LadderError.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 13/03/2021.
//

import Foundation

enum LadderError: String, Error{
    case couldnotretrive = "The ladder could not be found"
    case couldnotbeunwrapped = "The ladder could not safely be unwrapped"
    case nodata = "The ladder has no data"
    case corrupt = "The ladder has corrupt data"
    case challengeerror = "Users with challenges could not be found"

}
