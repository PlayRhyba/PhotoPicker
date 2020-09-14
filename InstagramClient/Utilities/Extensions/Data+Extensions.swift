//
//  Data+Extensions.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 08.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import Foundation

extension Data {
    
    func extractObject<T: Decodable>(decoder: JSONDecoder = JSONDecoder()) -> T? {
        return try? decoder.decode(T.self, from: self)
    }
    
}
