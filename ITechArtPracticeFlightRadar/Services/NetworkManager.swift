//
//  NetworkManager.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/9/21.
//

import Foundation
import Alamofire
import RxSwift

protocol NetworkManagerProtocol {
    func requestFlights(within region: CoordinateRectangle) -> Observable<[Aircraft]>
}

class NetworkManager: NetworkManagerProtocol {
    
    var count = 0
    
    func requestFlights(within region: CoordinateRectangle) -> Observable<[Aircraft]> {
        return Observable.create { observer in
//            let minLatitude = region.minLatitude
//            let minLongitude = region.minLongitude
//            let maxLatitude = region.maxLatitude
//            let maxLongitude = region.maxLongitude
            
            
            
            let path = Bundle.main.path(forResource: "MyJSON", ofType: "json")
            let path2 = Bundle.main.path(forResource: "MyJSON2", ofType: "json")
            let path3 = Bundle.main.path(forResource: "MyJSON3", ofType: "json")
            let path4 = Bundle.main.path(forResource: "MyJSON4", ofType: "json")
            let path5 = Bundle.main.path(forResource: "MyJSON5", ofType: "json")
            let path6 = Bundle.main.path(forResource: "MyJSON6", ofType: "json")
            let path7 = Bundle.main.path(forResource: "MyJSON7", ofType: "json")
            let path8 = Bundle.main.path(forResource: "MyJSON8", ofType: "json")
            let path9 = Bundle.main.path(forResource: "MyJSON9", ofType: "json")
            let path10 = Bundle.main.path(forResource: "MyJSON10", ofType: "json")
            let path11 = Bundle.main.path(forResource: "MyJSON11", ofType: "json")
            let path12 = Bundle.main.path(forResource: "MyJSON12", ofType: "json")
            let path13 = Bundle.main.path(forResource: "MyJSON13", ofType: "json")
            let path14 = Bundle.main.path(forResource: "MyJSON14", ofType: "json")
            
            
            let paths = [
                path, path2, path3, path4, path5, path6, path7, path8,
                path9, path10, path11, path12, path13, path14
            ]
            
            //print(self.count)
            
            let url = URL(fileURLWithPath: paths[self.count]!)
            
            //print(url)
            
            self.count += 1
            
            if self.count == 14 {
                self.count = 0
            }
            
//            let url = URL(string: "https://opensky-network.org/api/states/all?lamin=\(minLatitude)&lomin=\(minLongitude)&lamax=\(maxLatitude)&lomax=\(maxLongitude)")!
            
            let request = AF.request(url).responseDecodable(of: FlightInfo.self) { response in
                switch response.result {
                case .success(let flightInfo):
                    observer.onNext(flightInfo.aircraft)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
        
    }
}
