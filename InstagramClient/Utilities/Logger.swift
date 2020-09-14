//
//  Logger.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 11.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import os.log

final class Logger {
    
    // MARK: - Public
    
    static func log(sender: Any, message: String) {
        let logMessage = "\(type(of: sender)) - \(message)"
        os_log("%@", type: .debug, logMessage)
    }
    
    static func log(error: Error?) {
        guard let error = error else { return }
        
        os_log("%@", type: .error, "\(error)")
    }
    
}
