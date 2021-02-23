//
//  LadderPermissions.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 21/11/2020.
//

enum LadderPermission: String, CaseIterable {
    case open = "Open"
    case requests = "Public, with Requests"
    case invitation = "Invitation"
    case admin = "Invitation by Admins Only"
}
