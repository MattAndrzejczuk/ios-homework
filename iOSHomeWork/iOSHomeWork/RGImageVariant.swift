//
//  RGImageVariant.swift
//  iOSHomeWork
//
//  Created by Matt Andrzejczuk on 4/2/17.
//  Copyright © 2017 Harry Tormey. All rights reserved.
//



import Foundation
import EVReflection



let IMAGE_VARIATIONS = [
    "fixed_height",
    "fixed_height_still",
    "fixed_height_downsampled",
    "fixed_width",
    "fixed_width_still",
    "fixed_width_downsampled",
    "fixed_height_small",
    "fixed_height_small_still",
    "fixed_width_small",
    "fixed_width_small_still",
    "downsized",
    "downsized_still",
    "downsized_large",
    "downsized_medium",
    "original",
    "original_still",
    "looping",
    "preview",
    "downsized_small",
    "preview_gif",
    "preview_webp"
]

enum GiphyVariationREST {
    case fixedHeight,
    fixedHeightStill,
    fixedHeightDownsampled,
    fixedWidth,
    fixedWidthStill,
    fixedWidthDownsampled,
    fixedHeightSmall,
    fixedHeightSmallStill,
    fixedWidthSmall,
    fixedWidthSmallStill,
    downsized,
    downsizedStill,
    downsizedLarge,
    downsizedMedium,
    original,
    originalStill,
    looping,
    preview,
    downsizedSmall,
    previewGif,
    previewWebp;
    
    var getKeyName : String {
        switch self {
        case .fixedHeight:
            return IMAGE_VARIATIONS[0]
        case .fixedHeightStill:
            return IMAGE_VARIATIONS[1]
        case .fixedHeightDownsampled:
            return IMAGE_VARIATIONS[2]
        case .fixedWidth:
            return IMAGE_VARIATIONS[3]
        case .fixedWidthStill:
            return IMAGE_VARIATIONS[4]
        case .fixedWidthDownsampled:
            return IMAGE_VARIATIONS[5]
        case .fixedHeightSmall:
            return IMAGE_VARIATIONS[6]
        case .fixedHeightSmallStill:
            return IMAGE_VARIATIONS[7]
        case .fixedWidthSmall:
            return IMAGE_VARIATIONS[8]
        case .fixedWidthSmallStill:
            return IMAGE_VARIATIONS[9]
        case .downsized:
            return IMAGE_VARIATIONS[10]
        case .downsizedStill:
            return IMAGE_VARIATIONS[11]
        case .downsizedLarge:
            return IMAGE_VARIATIONS[12]
        case .downsizedMedium:
            return IMAGE_VARIATIONS[13]
        case .original:
            return IMAGE_VARIATIONS[14]
        case .originalStill:
            return IMAGE_VARIATIONS[15]
        case .looping:
            return IMAGE_VARIATIONS[16]
        case .preview:
            return IMAGE_VARIATIONS[17]
        case .downsizedSmall:
            return IMAGE_VARIATIONS[18]
        case .previewGif:
            return IMAGE_VARIATIONS[19]
        case .previewWebp:
            return IMAGE_VARIATIONS[20]
        default:
            return IMAGE_VARIATIONS[0]
        }
    }
}

class RGImageVariants : EVObject {
    var fixedHeight : RGBaseImage
    var fixedHeightStill : RGBaseImage
    var fixedHeightDownsampled : RGBaseImage
    var fixedWidth : RGBaseImage
    var fixedWidthStill : RGBaseImage
    var fixedWidthDownsampled : RGBaseImage
    var fixedHeightSmall : RGBaseImage
    var fixedHeightSmallStill : RGBaseImage
    var fixedWidthSmall : RGBaseImage
    var fixedWidthSmallStill : RGBaseImage
    var downsized : RGBaseImage
    var downsizedStill : RGBaseImage
    var downsizedLarge : RGBaseImage
    var downsizedMedium : RGBaseImage
    var original : RGBaseImage
    var originalStill : RGBaseImage
    var looping : RGBaseImage
    var preview : RGBaseImage
    var downsizedSmall : RGBaseImage
    var previewGif : RGBaseImage
    var previewWebp : RGBaseImage
    
    
    required init() {
        fixedHeight = RGBaseImage()
        fixedHeightStill = RGBaseImage()
        fixedHeightDownsampled = RGBaseImage()
        fixedWidth = RGBaseImage()
        fixedWidthStill = RGBaseImage()
        fixedWidthDownsampled = RGBaseImage()
        fixedHeightSmall = RGBaseImage()
        fixedHeightSmallStill = RGBaseImage()
        fixedWidthSmall = RGBaseImage()
        fixedWidthSmallStill = RGBaseImage()
        downsized = RGBaseImage()
        downsizedStill = RGBaseImage()
        downsizedLarge = RGBaseImage()
        downsizedMedium = RGBaseImage()
        original = RGBaseImage()
        originalStill = RGBaseImage()
        looping = RGBaseImage()
        preview = RGBaseImage()
        downsizedSmall = RGBaseImage()
        previewGif = RGBaseImage()
        previewWebp = RGBaseImage()
    }
    
    init(usingVariation: GiphyVariationREST) {
        fixedHeight = RGBaseImage(variation: usingVariation)
        fixedHeightStill = RGBaseImage(variation: usingVariation)
        fixedHeightDownsampled = RGBaseImage(variation: usingVariation)
        fixedWidth = RGBaseImage(variation: usingVariation)
        fixedWidthStill = RGBaseImage(variation: usingVariation)
        fixedWidthDownsampled = RGBaseImage(variation: usingVariation)
        fixedHeightSmall = RGBaseImage(variation: usingVariation)
        fixedHeightSmallStill = RGBaseImage(variation: usingVariation)
        fixedWidthSmall = RGBaseImage(variation: usingVariation)
        fixedWidthSmallStill = RGBaseImage(variation: usingVariation)
        downsized = RGBaseImage(variation: usingVariation)
        downsizedStill = RGBaseImage(variation: usingVariation)
        downsizedLarge = RGBaseImage(variation: usingVariation)
        downsizedMedium = RGBaseImage(variation: usingVariation)
        original = RGBaseImage(variation: usingVariation)
        originalStill = RGBaseImage(variation: usingVariation)
        looping = RGBaseImage(variation: usingVariation)
        preview = RGBaseImage(variation: usingVariation)
        downsizedSmall = RGBaseImage(variation: usingVariation)
        previewGif = RGBaseImage(variation: usingVariation)
        previewWebp = RGBaseImage(variation: usingVariation)
    }
}




