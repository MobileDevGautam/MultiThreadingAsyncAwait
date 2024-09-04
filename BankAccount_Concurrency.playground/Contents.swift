import UIKit

class BankAccount {
    
    var balance: Double
    let lock = NSLock()
    
    init(balance: Double) {
        self.balance = balance
    }
    
    func withdraw(_ amount: Double) {
        lock.lock()
        if balance >= amount {
            
            let processingTime = UInt32.random(in: 0...3)
            print("[Withdraw] Processing for \(amount) \(processingTime) seconds")
            sleep(processingTime)
            print("Withdrawing \(amount) from account")
            balance -= amount
            print("Balance is \(balance)")
        }
        lock.unlock()
        
    }
    
}

let bankAccount = BankAccount(balance: 500)


//1. Race Condition Example
//let queue = DispatchQueue(label: "ConcurrentQueue", attributes: .concurrent)
//
//queue.async {
//    bankAccount.withdraw(300)
//}
//
//queue.async {
//    bankAccount.withdraw(500)
//}


//2. Serial Queue
//let queue = DispatchQueue(label: "SerialQueue")
//
//queue.async {
//    bankAccount.withdraw(300)
//}

//queue.async {
//    bankAccount.withdraw(500)
//}


//3. Separate Serial Queue which creates a race condition
//let queue2 = DispatchQueue(label: "SerialQueue2")
//
//queue2.async {
//    bankAccount.withdraw(500)
//}


//4.
let queue4 = DispatchQueue(label: "ConcurrentQueue", attributes: .concurrent)
queue4.async {
    bankAccount.withdraw(300)
}

queue4.async {
    bankAccount.withdraw(500)
}
