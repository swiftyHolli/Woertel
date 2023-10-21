//
//  DeviceGeometry.swift
//  Wordle
//
//  Created by Holger Becker on 13.10.23.
//

import Foundation
import SwiftUI

struct DeviceGeometry {
    var isIpad = false
    var deviceWidth: CGFloat = 0
    var deviceHeight: CGFloat = 0
    
    init() {
        setDeviceDimensions()
    }
    
    var infoViewWidth: CGFloat {
        return deviceWidth * (isIpad ? 0.8 : 1.0)
    }
    var infoViewHeight: CGFloat {
        return deviceHeight * (isIpad ? 0.5 : 0.7)
    }
    var infoPageWidth: CGFloat {
        return deviceWidth * (isIpad ? 0.8 : 1.0) - 10
    }
    var infoPageLettersWidth: CGFloat {
        return deviceWidth * (isIpad ? 0.5 : 0.8)
    }
    var dotsOffset: CGFloat {
        return -(deviceHeight - infoViewHeight - 100)
    }
    var infoViewHeaderWidth: CGFloat {
        return infoViewWidth - infoPageCornerRadius * 2
    }
    var infoPageCornerRadius: CGFloat {
        return 25
    }
    var infoViewHeaderHeight: CGFloat {
        return isIpad ? 100 : 80
    }
    var infoViewCloseButtonOffset: CGSize {
        let size = CGSize(width: (infoViewWidth - 120) / 2,
                          height: -infoViewHeight / 2 - 40)
        return size
    }
    
    mutating func setDeviceDimensions() {
        deviceWidth = UIScreen.main.bounds.size.width
        deviceHeight = UIScreen.main.bounds.size.height
        isIpad = UIDevice.current.userInterfaceIdiom == .pad
    }
}
