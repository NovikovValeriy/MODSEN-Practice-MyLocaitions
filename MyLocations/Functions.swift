//
//  Functions.swift
//  MyLocations
//
//  Created by Валерий Новиков on 30.06.25.
//

import Foundation

let applicationDocumentsDirectory: URL = {
    let paths = FileManager.default.urls(for: .documentDirectory , in: .userDomainMask)
    return paths[0]
}()

func fatalCoreDataError(_ error: Error ) {
    print("*** Fatal error: \(error)")
    NotificationCenter.default.post(name: NSNotification.Name("dataSaveFailedNotification"), object: nil)
}
