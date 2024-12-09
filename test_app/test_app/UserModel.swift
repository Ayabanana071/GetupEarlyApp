//
//  UserModel.swift
//  test_app
//
//  Created by ayana taba on 2024/12/09.
//

import Foundation

class UserModel: ObservableObject {
    @Published var id: Int = 0
    @Published var name: String = ""
    @Published var email: String = ""
    
    func update(from dictionary: [String: Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.name = dictionary["name"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
    }
}

