//
//  util.swift
//  medicalDiary
//
//  Created by Marko Lazic on 2020-10-06.
//

import Foundation
import SwiftEntryKit
import Charts



struct Util {
    static func showPopup(title: String, desc: String, textColor: UIColor, color1: UIColor, color2: UIColor) {
        // Generate top floating entry and set some properties
        var attributes = EKAttributes.topFloat
        attributes.entryBackground = .gradient(gradient: .init(colors: [EKColor(color1), EKColor(color2)], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 1), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
        attributes.statusBar = .dark
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.bounds.width), height: .intrinsic)

        let title = EKProperty.LabelContent(text: title , style: .init(font: UIFont.boldSystemFont(ofSize: 20), color: EKColor(textColor)))
        let description = EKProperty.LabelContent(text: desc, style: .init(font: UIFont.systemFont(ofSize: 10), color: EKColor(textColor)))
        let simpleMessage = EKSimpleMessage(title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)

        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    static func urlIsEnding(url: String, ending: String) -> Bool {
        let split = url.split(separator: "/").last
        return split != nil ? split! == ending: false
    }
}

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone
    }
}

extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

extension Date {
    var iso8601withFractionalSeconds: String { return Formatter.iso8601withFractionalSeconds.string(from: self) }
}

extension String {
    var iso8601withFractionalSeconds: Date? { return Formatter.iso8601withFractionalSeconds.date(from: self) }
}
