import Testing
import CoreImage
import CoreGraphics
@testable import CoreImageWriter


// ChatGPT generated function
func createWhiteImage() -> CGImage? {
    let width = 32
    let height = 32
    let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
    
    // Define the white color in RGBA format
    let whiteColor: [CGFloat] = [1.0, 1.0, 1.0, 1.0] // RGBA where each component is 1.0 (fully white, fully opaque)
    
    // Create a bitmap context with 32x32 pixels, 8 bits per component, and 4 components (RGBA)
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
    
    guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
        return nil
    }
    
    // Fill the entire context with white color
    context.setFillColor(whiteColor)
    context.fill(CGRect(x: 0, y: 0, width: width, height: height))
    
    // Create a CGImage from the context
    return context.makeImage()
}


@Suite struct CoreImageWriterTests {
    let img = CIImage(cgImage: createWhiteImage()!)
    let writer = CoreImageWriter()
    
    func assertCanLoadImage(_ url: URL) {
        let loadedImg = CIImage(contentsOf: url)
        #expect(loadedImg != nil)
    }
    
    @Test(arguments: ["jpg", "jpeg", "png"]) func succeed(ext: String) async {
        var target = URL(filePath: "dest", relativeTo: URL.temporaryDirectory)
        target.appendPathExtension(ext)
        try! writer.write(image: img, to: target)
        
        assertCanLoadImage(target)
    }
    
    @Test func filepathWithinDirectory() async {
        let sample = URL(filePath: "sample", relativeTo: URL.temporaryDirectory)
        try! FileManager.default.createDirectory(at: sample, withIntermediateDirectories: true)
        let targetWithinDirectory = URL(filePath: "sample/dest.jpg", relativeTo: URL.temporaryDirectory)
        try! writer.write(image: img, to: targetWithinDirectory)
        
        assertCanLoadImage(targetWithinDirectory)
    }

    @Test func invalidURLShouldCauseWriteError() async {
        let targetWithNonExistingDir = URL(filePath: "nonExistingDir/dest.jpeg", relativeTo: URL.temporaryDirectory)
        #expect(
            throws: CoreImageWriter.Errors.writeError,
            "CoreImageWriter.write(image:to) should emit writeError"
        ) {
            try writer.write(image: img, to: targetWithNonExistingDir)
        }
    }
    
    @Test func invalidExtensionShouldCauseUnsupportedExtensionError() async {
        let targetWithInvalidExtension = URL(filePath: "dest.bmp")
        #expect(
            throws: CoreImageWriter.Errors.unsupportedExtensionError,
            "CoreImageWriter.write(image:to) supports extensions only in jpeg, jpg, png."
        ) {
            try writer.write(image: img, to: targetWithInvalidExtension)
        }
    }
}






