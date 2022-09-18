//
//  DataController-StoreKit.swift
//  TDPortfolio
//
//  Created by Thomas on 18/09/2022.
//

import Foundation
import StoreKit

extension DataController {
    func appLaunched() {
        guard count(for: Project.fetchRequest()) >= 5 else { return }
        // DEV DISABLED
        //        let allScenes = UIApplication.shared.connectedScenes
        //        let scene = allScenes.first { $0.activationState == .foregroundActive }
        //
        //        if let windowScene = scene as? UIWindowScene {
        //            SKStoreReviewController.requestReview(in: windowScene)
        //        }
        // DEV DISABLED
    }
}
