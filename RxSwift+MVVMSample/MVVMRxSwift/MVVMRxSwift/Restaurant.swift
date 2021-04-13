//
//  Restaurant.swift
//  MVVMRxSwift
//
//  Created by Yebin Kim on 2021/04/13.
//

import Foundation

struct Restaurant: Decodable {
    let name: String
    let cuisine: Cuisine
}

enum Cuisine: String, Decodable {
    case european
    case indian
    case mexican
    case french
    case english
}
