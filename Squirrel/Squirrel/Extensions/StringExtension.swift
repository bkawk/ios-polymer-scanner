//
//  StringExtension.swift
//  Squirrel
//
//  Created by Duc Nguyen on 5/15/17.
//  Copyright © 2017 Squirrel. All rights reserved.
//

import Foundation

extension String {
    func appendingPathComponent(_ string: String) -> String {
        return URL(fileURLWithPath: self).appendingPathComponent(string).path
    }
    
    func urlEncode() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
    }
}
