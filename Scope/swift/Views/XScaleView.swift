//
//  XScaleView.swift
//  Oscilloscope
//
//  Created by Bill Farmer on 09/04/2018.
//  Copyright © 2018 Bill Farmer. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.

import Cocoa

// XScaleView
class XScaleView: NSView
{
    // intrinsicContentSize
    override var intrinsicContentSize: NSSize
    {
        get
        {
            return  NSSize(width: super.intrinsicContentSize.width,
                           height: CGFloat(kScaleHeight))
        }
    }

    var scale = Float(0)
    {
        didSet
        {
            needsDisplay = true
        }
    }

    var start = Float(0)
    {
        didSet
        {
            needsDisplay = true
        }
    }

    var step = Float(0)
    {
        didSet
        {
            needsDisplay = true
        }
    }

    // draw
    override func draw(_ rect: NSRect)
    {
        super.draw(rect)

        // Drawing code here.
        let kTextSize = rect.height / 2

        // Move the origin
        let context = NSGraphicsContext.current!
        context.cgContext.translateBy(x: CGFloat(kScaleWidth), y: 0)
        context.shouldAntialias = false

        // Draw scale
        for x in stride(from: 0, to: rect.width, by: 50)
        {
            NSBezierPath.strokeLine(from: NSMakePoint(x, rect.maxY * 2 / 3),
                                    to: NSMakePoint(x, rect.maxY))
        }

        for x in stride(from: 0, to: rect.width, by: 10)
        {
            NSBezierPath.strokeLine(from: NSMakePoint(x, rect.maxY * 3 / 4),
                                    to: NSMakePoint(x, rect.maxY))
        }

        context.shouldAntialias = true
        let font = NSFont.boldSystemFont(ofSize: kTextSize)
        let attrs: [NSAttributedString.Key: Any] = [.font: font]

        if (scale < 100)
        {
            var offset = "ms".size(withAttributes: attrs).width / 2
            "ms".draw(at: NSMakePoint(-offset, 4), withAttributes: attrs)

            for x in stride(from: 100, to: rect.width, by: 100)
            {
                let s =
                  String(format: "%0.1f",
                         (start + (Float(x) * scale)) / 100.0)
                offset = s.size(withAttributes: attrs).width / 2
                s.draw(at: NSMakePoint(x - offset, 4), withAttributes: attrs)
            }
        }

        else
        {
            var offset = "sec".size(withAttributes: attrs).width / 2
            "sec".draw(at: NSMakePoint(-offset, 4), withAttributes: attrs)

            for x in stride(from: 100, to: rect.width, by: 100)
            {
                let s =
                  String(format: "%0.1f",
                         (start + (Float(x) * scale)) / 100000.0)
                offset = s.size(withAttributes: attrs).width / 2
                s.draw(at: NSMakePoint(x - offset, 4), withAttributes: attrs)
            }
        }
    }
}
