//
//  FacebookDataResponse.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 10.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import Foundation

struct FacebookDataResponse<T: Codable>: Codable {
    
    struct Paging: Codable {
        
        let previous: URL?
        let next: URL?
        
    }
    
    let data: [T]
    let paging: Paging?
    
}

struct FacebookErrorResponse<T: Codable>: Codable {
    
    let error: T
    
}
