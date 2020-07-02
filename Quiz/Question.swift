//
//  Question.swift
//  Quiz
//
//  Created by Rishi Palivela on 02/07/20.
//  Copyright © 2020 StarDust. All rights reserved.
//

import Foundation

struct Question: Decodable {
    var question: String
    var correctAns: Int
    var options: [String]
}
