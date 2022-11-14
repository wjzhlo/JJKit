//
//  StringExtension.swift
//  JJKit
//
//  Created by Jero on 2022/11/14.
//

import Foundation

public extension String {
    
    func subStr(_ offset: Int,  _ length: Int) -> String? {
        guard offset + length <= self.count else { return nil }
        let start = index(startIndex, offsetBy: offset)
        let end = index(start, offsetBy: length)
        return String(self[start..<end])
    }
    
    
}
