//
//  RestaurantViewModel.swift
//  MVVMRxSwift
//
//  Created by Yebin Kim on 2021/04/13.
//

import Foundation

struct RestaurantViewModel {

    private let restaurant: Restaurant

    var displayTest: String {
        return restaurant.name + " - " + restaurant.cuisine.rawValue.capitalized
    }

    init(restaurant: Restaurant) {
        self.restaurant = restaurant
    }
}
