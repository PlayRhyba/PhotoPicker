//
//  JSONDecoder+Decoders.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 14.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import Foundation

extension JSONDecoder {
    
    static var facebook: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return decoder
    }

}
