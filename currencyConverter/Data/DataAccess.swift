//
//  DataAccess.swift
//  currencyConverter
//
//  Created by Gökhan Kıdak on 26.10.2023.
//

import Alamofire
import Foundation

class DataAccess
{
    public static var shared = DataAccess()
    let requestKey = "https://api.currencyapi.com/v3/latest?apikey=cur_live_r6VAZ8fT3l6P1C1ErMI2viYUwnbXoHraiUgm6BbN&base_currency="
    
    
    func fetchData(from : String, to : String, completion : @escaping (_ rate : Double) -> Void){
        var result = 0.0
        let request = AF.request(requestKey + from)
            .responseData{response in
                if let jsonData = response.data {
                    do {
                        let currencyData = try JSONDecoder().decode(CurrencyData.self, from: jsonData)
                        result = currencyData.data[to]!.value
                        completion(result)
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
                else{
                    print("Error decoding json")
                }
            }
    }
}

struct CurrencyData: Codable {
    let data: [String: CurrencyInfo]
}

struct CurrencyInfo: Codable {
    let code: String
    let value: Double
}
