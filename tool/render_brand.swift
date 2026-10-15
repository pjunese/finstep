// Regenerate the code-drawn app mark at native icon/launch sizes on macOS.
// Run from the project root: swift tool/render_brand.swift
import AppKit

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let orange = CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!,
    components: [1, 149.0 / 255, 84.0 / 255, 1])!

func render(_ path: String, pixels: Int, square: Bool = false, transparent: Bool = false) throws {
    let context = CGContext(data: nil, width: pixels, height: pixels,
        bitsPerComponent: 8, bytesPerRow: pixels * 4, space: CGColorSpace(name: CGColorSpace.sRGB)!,
        bitmapInfo: (transparent ? CGImageAlphaInfo.premultipliedLast : CGImageAlphaInfo.noneSkipLast).rawValue)!
    context.setAllowsAntialiasing(true)
    context.scaleBy(x: CGFloat(pixels) / 104, y: CGFloat(pixels) / 104)
    context.translateBy(x: 0, y: 104)
    context.scaleBy(x: 1, y: -1)
    if !transparent {
        context.setFillColor(CGColor(gray: 1, alpha: 1))
        context.fill(CGRect(x: 0, y: 0, width: 104, height: 104))
    }
    context.setFillColor(orange)
    context.addPath(CGPath(roundedRect: CGRect(x: 0, y: 0, width: 104, height: 104),
        cornerWidth: square ? 0 : 26, cornerHeight: square ? 0 : 26, transform: nil))
    context.fillPath()
    context.setStrokeColor(CGColor(gray: 1, alpha: 1))
    context.setLineWidth(8)
    context.move(to: CGPoint(x: 34, y: 72))
    context.addLine(to: CGPoint(x: 70, y: 36))
    context.strokePath()
    context.setFillColor(CGColor(gray: 1, alpha: 1))
    for (x, y) in [(22, 60), (40, 42), (58, 24)] {
        context.addPath(CGPath(roundedRect: CGRect(x: x, y: y, width: 24, height: 24),
            cornerWidth: 8, cornerHeight: 8, transform: nil))
        context.fillPath()
    }
    let url = root.appendingPathComponent(path)
    try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bitmap = NSBitmapImageRep(cgImage: context.makeImage()!)
    try bitmap.representation(using: .png, properties: [:])!.write(to: url)
}

let iconDir = "ios/Runner/Assets.xcassets/AppIcon.appiconset"
let manifest = try Data(contentsOf: root.appendingPathComponent("\(iconDir)/Contents.json"))
let icons = (try JSONSerialization.jsonObject(with: manifest) as! [String: Any])["images"] as! [[String: String]]
for icon in icons {
    let size = Double(icon["size"]!.components(separatedBy: "x")[0])!
    let scale = Double(icon["scale"]!.dropLast())!
    try render("\(iconDir)/\(icon["filename"]!)", pixels: Int(size * scale), square: true)
}
for scale in 1...3 {
    let suffix = scale == 1 ? "" : "@\(scale)x"
    try render("ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage\(suffix).png", pixels: 96 * scale)
}
for (density, pixels) in [("mdpi", 48), ("hdpi", 72), ("xhdpi", 96), ("xxhdpi", 144), ("xxxhdpi", 192)] {
    try render("android/app/src/main/res/mipmap-\(density)/ic_launcher.png", pixels: pixels, transparent: true)
}
print("Rendered iOS and Android brand assets.")
