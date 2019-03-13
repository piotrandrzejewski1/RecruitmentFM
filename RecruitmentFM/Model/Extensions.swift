//
//  Extensions.swift
//  RecruitmentFM
//
//  Created by Piotr Andrzejewski on 12/03/2019.
//  Copyright © 2019 Piotr Andrzejewski. All rights reserved.
//

import Foundation

extension String {
    var embededUrl: URL? {
        if self.contains("http") {
            let str = self[self.range(of: "http")!.lowerBound...]
            return URL(string: String(str))
        }
        else {
            return nil
        }
    }
    var trimUrl: String {
        if self.contains("\thttp") {
            let str = self[...self.range(of: "\thttp")!.lowerBound]
            return String(str)
        }
        else {
            return self
        }
    }
}
