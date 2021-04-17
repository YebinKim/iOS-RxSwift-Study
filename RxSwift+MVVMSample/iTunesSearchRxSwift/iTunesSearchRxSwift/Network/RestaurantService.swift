//
//  RestaurantService.swift
//  MVVMRxSwift
//
//  Created by Yebin Kim on 2021/04/13.
//

import Foundation
import RxSwift

protocol RestaurantServiceProtocol {
    func fetchRestaurants() -> Observable<[Restaurant]>
}

class RestaurantService: RestaurantServiceProtocol {

    func fetchRestaurants() -> Observable<[Restaurant]> {

        return Observable.create { observer -> Disposable in

            // 추후 서버 통신 API와 연결할 때 사용
//            let task = URLSession.shared.dataTask(with: URL(string: "custon-url")!) { data, _, _ in

            // restaurants.json 경로를 찾지 못하면 에러 방출
            guard let path = Bundle.main.path(forResource: "restaurants", ofType: "json") else {
                observer.onError(NSError(domain: "", code: -1, userInfo: nil))
                return Disposables.create { }
            }

            do {
                // restaurants.json 디코딩
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let restaurants = try JSONDecoder().decode([Restaurant].self, from: data)
                // 디코딩 성공 시 next 이벤트 방출
                observer.onNext(restaurants)
            } catch(let error) {
                // 디코딩 실패 시 에러 방출
                observer.onError(error)
            }
//            }
//            task.resume()

            return Disposables.create {
//                task.cancel()
            }
        }
    }
}
