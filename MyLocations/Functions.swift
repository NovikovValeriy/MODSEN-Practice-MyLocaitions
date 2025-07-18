//
//  Functions.swift
//  MyLocations
//
//  Created by Валерий Новиков on 30.06.25.
//

import Foundation

func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: run)
}

let applicationDocumentsDirectory: URL = {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}()

let dataSaveFailedNotification = Notification.Name(rawValue: "DataSaveFailedNotification")

func fatalCoreDataError(_ error: Error) {
    NotificationCenter.default.post(name: dataSaveFailedNotification, object: nil)
}
