//
//  AppDelegate.swift
//  LMS
//
//  Created by Bill Farmer on 03/07/2018.
//  Copyright © 2018 Bill Farmer. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation; either version 2 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License along
//  with this program; if not, write to the Free Software Foundation, Inc.,
//  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{

    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        // Insert code here to initialize your application

        window.contentMinSize = NSMakeSize(CGFloat(kMinWidth),
                                           CGFloat(kMinHeight))
        window.contentAspectRatio = NSMakeSize(CGFloat(kMinWidth),
                                               CGFloat(kMinHeight))
        window.collectionBehavior.insert(.fullScreenNone)

        window.title = "Level Measuring Set"

        // Find the menu
        let menu = NSApp.mainMenu!
        let item = menu.item(withTitle: "File")!
        if (item.hasSubmenu)
        {
            let subMenu = item.submenu!
            let subItem = subMenu.item(withTitle: "Print…")!
            subItem.target = self
            subItem.action = #selector(print)
        }

        // Views
        displayView = DisplayView()
        meterView = MeterView()
        spectrumView = SpectrumView()

        displayView.toolTip = "Frequency and level display"
        meterView.toolTip = "Level meter"
        spectrumView.toolTip = "Spectrum"

        // Stack
        let stack = NSStackView(views: [displayView, meterView, spectrumView])
        stack.orientation = .vertical
        stack.spacing = 8
        stack.edgeInsets = NSEdgeInsetsMake(20, 20, 20, 20)
        let spectrumHeight = NSLayoutConstraint(item: spectrumView as Any,
                                                attribute: .height,
                                                relatedBy: .equal,
                                                toItem: displayView as Any,
                                                attribute: .height,
                                                multiplier: 1,
                                                constant: 0)
        stack.addConstraint(spectrumHeight)
        let meterHeight = NSLayoutConstraint(item: meterView as Any,
                                             attribute: .height,
                                             relatedBy: .equal,
                                             toItem: displayView as Any,
                                             attribute: .height,
                                             multiplier: 1,
                                             constant: 0)
        stack.addConstraint(meterHeight)

        // Window
        window.contentView = stack
        window.makeKeyAndOrderFront(self)
        window.makeMain()

        // Audio
        let status = SetupAudio()
        if (status != noErr)
        {
            displayAlert("Tuner", "Audio initialisation failed", status)
        }
    }

    // DisplayAlert
    func displayAlert(_ message: String, _ informativeText: String,
                      _ status: OSStatus)
    {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = message

        let error = (status > 0) ? UTCreateStringForOSType(OSType(status))
          .takeRetainedValue() as String :
          String(utf8String: AudioUnitErrString(status))!

        alert.informativeText = String(format: "%@: %@ (%x)", informativeText,
                                       error, status)
        alert.runModal()
    }

    // print
    @objc func print(sender: Any)
    {
        window.printWindow(sender)
    }

    // applicationShouldTerminateAfterLastWindowClosed
    func
      applicationShouldTerminateAfterLastWindowClosed(_ sender:
                                                        NSApplication) -> Bool
    {
        return true
    }

    func applicationWillTerminate(_ aNotification: Notification)
    {
        // Insert code here to tear down your application
        ShutdownAudio()
    }


}

