//
//  BackgroundTaskWorkshopApp.swift
//  BackgroundTaskWorkshop
//
//  Created by Kevin ABRIOUX on 16/05/2024.
//

import SwiftUI
import BackgroundTasks

@main
struct BackgroundTaskWorkshopApp: App {
    
    let taskIdentifier = "com.kevinabrioux.backgroundtask.refresh"
    
    func handleAppRefresh(task: BGAppRefreshTask) {
       // Schedule a new refresh task.
       scheduleAppRefresh()
     }
    
    func scheduleAppRefresh() {
        print("===>>> scheduleAppRefresh")
       let request = BGProcessingTaskRequest(identifier: taskIdentifier)

        // Fetch no earlier than 15 minutes from now.
       request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
            
       do {
          try BGTaskScheduler.shared.submit(request)
           print("Background task scheduled successfully.")

           // e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.kevinabrioux.backgroundtask.refresh"]

       } catch {
          print("Could not schedule app refresh: \(error)")
       }
    }
    
    func trigger() async {
        print("===>>> in trigger")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    scheduleAppRefresh()
                }
        }.backgroundTask(.appRefresh(taskIdentifier)) { task in
            print("===>>> in .appRefresh")
            await trigger()
        }
    }
}
