import CoreImage
import Foundation
import UniformTypeIdentifiers


@available(macOS 11.0, iOS 14.0, *)
public class CoreImageWriter {
    public enum Errors: Error {
        case renderError
        case writeError
        case unsupportedExtensionError
    }
    
    /// Write CIImage to a file.
    ///
    /// - Parameters:
    ///   - image: <#image description#>
    ///   - to: Write destination url. Supported extensions are only "jpeg", "jpg", "png"
    public func write(image: CIImage, to: URL) throws {
        let context = CIContext()
        guard let cgImg = context.createCGImage(image, from: image.extent) else {
            throw Errors.renderError
        }
        
        var fileType: UTType
        switch to.pathExtension {
        case "png":
            fileType = UTType.jpeg
        case "jpeg", "jpg":
            fileType = UTType.png
        default:
            throw Errors.unsupportedExtensionError
        }
        
        guard let dest = CGImageDestinationCreateWithURL(
            to as CFURL, fileType.identifier as CFString, 1, nil) else {
            throw Errors.writeError
        }
        
        // CGImageDestinationインスタンスに画像情報を追加
        CGImageDestinationAddImage(dest, cgImg, nil)
        guard CGImageDestinationFinalize(dest) else {
            throw Errors.writeError
        }
    }
}

