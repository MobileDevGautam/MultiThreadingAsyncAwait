import UIKit

enum NetworkError: Error {
    case badUrl
    case decodingError
    case invalidId
}

struct CreditScore: Decodable {
    let score: Int
}

struct Constants {
    struct Urls {
        static func equifax(userId: Int) -> URL? {
            return URL(string: "https://ember-sparkly-rule.glitch.me/equifax/credit-score/\(userId)")
        }
        
        static func experian(userId: Int) -> URL? {
            return URL(string: "https://ember-sparkly-rule.glitch.me/experian/credit-score/\(userId)")
        }
        
    }
}

func calculateAPR(creditScores: [CreditScore]) -> Double {
    let sum = creditScores.reduce(0) { partialResult, creditScore in
        return partialResult + creditScore.score
    }
    
    return Double((sum/creditScores.count)/100)
}

func getAPR(userId: Int) async throws -> Double {
    
//    if userId % 2 == 0 {
//        throw NetworkError.invalidId
//    }
    
    guard let equifaxUrl = Constants.Urls.equifax(userId: userId),
          let experianUrl = Constants.Urls.experian(userId: userId) else {
              throw NetworkError.badUrl
          }

    async let (equifaxData, _) = URLSession.shared.data(from: equifaxUrl)
    async let (experianData, _) = URLSession.shared.data(from: experianUrl)
    
    //Custom Code
    
    let equifaxCreditScore = try? JSONDecoder().decode(CreditScore.self, from: try await equifaxData)
    let experianCreditScore = try? JSONDecoder().decode(CreditScore.self, from: try await experianData)
    
    guard let equifaxCreditScore = equifaxCreditScore,
          let experianCreditScore = experianCreditScore else {
        throw NetworkError.decodingError
    }
    
    return calculateAPR(creditScores: [equifaxCreditScore, experianCreditScore])
}
//


let ids = [1,2,3,4,5]
var invalidIds: [Int] = []
//Task {
//    for id in ids {
//        do {
//            try Task.checkCancellation()
//            let apr = try await getAPR(userId: id)
//            print(apr)
//            print(Task.isCancelled)
//        } catch {
//            print(error)
//            invalidIds.append(id)
//        }
//    }
//    
//    print(invalidIds)
//}



//Above for loop process data serially. i.e once one user id is processed then another user id will take place for processing
func getAPRforAllUsers(ids: [Int]) async throws -> [Int: Double] {
    
    var userAPR: [Int: Double] = [:]
    
    try await withThrowingTaskGroup(of: (Int, Double).self) { group in
        for id in ids {
            group.addTask {
                return (id, try await getAPR(userId: id))
            }
        }
        
        for try await (id, apr) in group {
            userAPR[id] = apr
        }
    }
    
    return userAPR
}


Task {
    let userAPR = try await getAPRforAllUsers(ids: ids)
    print(userAPR)
    
    let invalidIds = userAPR.filter { $0.value.isNaN }
    print(invalidIds)
}






















