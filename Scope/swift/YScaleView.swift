//
//  YScaleView.swift
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

class YScaleView: NSView
{
    override var intrinsicContentSize: NSSize
    {
        get
        {
            return NSSize(width: CGFloat(kScaleWidth),
                          height: super.intrinsicContentSize.height)
        }
    }

    override func draw(_ rect: NSRect)
    {
        super.draw(rect)

        // Drawing code here.
        NSColor.red.set()
        NSBezierPath.fill(rect)
    }
    
}
