//
//  main.swift
//  L7_AnnaPanfilova
//
//  Created by Anna on 06.08.2020.
//  Copyright © 2020 Anna. All rights reserved.
//

import Foundation

struct Car {
    let name: String
    var price: Int
    var count: Int
}

// Ошибки Error

enum GarageError: LocalizedError {
    case carNotExists(carName: String)
    case outOfStock(carName: String)
    case notEnaughMoney(moneyNeeded: Int)
    
    var localizedDescription: String {
        switch self {
        case .carNotExists(let carName):
            return "Машина \(carName) не найдена в гараже"
        case .outOfStock(let carName):
            return "Машины \(carName) закончились"
        case .notEnaughMoney(let moneyNeeded):
            return "На машину не хватает \(moneyNeeded) руб."
        }
    }
}

class ErrorHandler {
    func handle(error: GarageError) { // с системным Result и try/catch работает только так, если указывать просто "error: Error" или даже "error: LocalizedError", то выводится системный localizedDescription вида "The operation couldn’t be completed..."
        print(error.localizedDescription)
    }
}

class Garage {
    fileprivate var cars = [
        "BMW X7": Car(name: "BMW X7", price: 10000000, count: 1),
        "Nissan Quashquai": Car(name: "Nissan Quashquai", price: 1700000, count: 2),
        "Lada Vesta": Car(name: "Lada Vesta", price: 700000, count: 5)
    ]
    
    var money = 0
    
    func buy(carName: String) -> Result<Car, GarageError> {
        guard var car = cars[carName] else {
            return Result.failure(.carNotExists(carName: carName))
        }
        
        guard car.count > 0 else {
            return Result.failure(.outOfStock(carName: carName))
        }
        
        guard money >= car.price else {
            return Result.failure(.notEnaughMoney(moneyNeeded: car.price - money))
        }
        
        money -= car.price
        car.count -= 1
        
        return Result.success(car)
    }
}

let garage = Garage()
garage.money = 11000000

var cars: [Result<Car, GarageError>] = []
cars.append(garage.buy(carName: "Lada Granta"))
cars.append(garage.buy(carName: "BMW X7"))
cars.append(garage.buy(carName: "Nissan Quashquai"))

print("Ошибки Error:")

for result in cars {
    switch result {
    case let .success(car):
        print("Мы купили: \(car.name)")
    case let .failure(error):
        let errorHandler = ErrorHandler()
        errorHandler.handle(error: error)
    }
}


// Ошибкт try/catch

class Garage2 {
    fileprivate var cars = [
        "BMW X7": Car(name: "BMW X7", price: 10000000, count: 1),
        "Nissan Quashquai": Car(name: "Nissan Quashquai", price: 1700000, count: 2),
        "Lada Vesta": Car(name: "Lada Vesta", price: 700000, count: 5)
    ]
    
    var money = 0
    
    func buy(carName: String) throws -> Car {
        guard var car = cars[carName] else {
            throw GarageError.carNotExists(carName: carName)
        }
        
        guard car.count > 0 else {
            throw GarageError.outOfStock(carName: carName)
        }
        
        guard money >= car.price else {
            throw GarageError.notEnaughMoney(moneyNeeded: car.price - money)
        }
        
        money -= car.price
        car.count -= 1
        
        return car
    }
}

let garage2 = Garage2()
garage2.money = 11000000

print()
print("Ошибки try/catch:")

let carsNames = ["Lada Granta", "BMW X7", "Nissan Quashquai"]

for carName in carsNames {
    do {
        let car = try garage2.buy(carName: carName)
        print("Мы купили: \(car.name)")
    } catch let error as GarageError {
        let errorHandler = ErrorHandler()
        errorHandler.handle(error: error)
    }
}
