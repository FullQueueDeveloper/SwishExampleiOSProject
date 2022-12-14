import Foundation
import Sh

public struct XCAssets {

  let inputSVG: String, outputDir: String
  public init(inputSVG: String, outputDir: String) {
    self.inputSVG = inputSVG
    self.outputDir = outputDir
  }

  public func render() throws {
    try sh(.terminal, "mkdir -p \(outputDir)/AppIcon.xcassets/AppIcon.appiconset")
    for size in AppiconSize.allCases {
      let pngPath = "\(outputDir)/AppIcon.xcassets/AppIcon.appiconset/\(filename(for: size))"
      try sh(.terminal, "inkscape -o \(pngPath) -w \(size.edge) -h \(size.edge) \(inputSVG)")

    }

    try XCAssetsJSON.xcassetsContents.data(using: .utf8)!.write(to: URL(fileURLWithPath: "\(outputDir)/AppIcon.xcassets/Contents.json"))
    try XCAssetsJSON.appiconsetContents.data(using: .utf8)!.write(to: URL(fileURLWithPath: "\(outputDir)/AppIcon.xcassets/AppIcon.appiconset/Contents.json"))
  }

  func filename(for size: AppiconSize) -> String {
    switch size.data.scale {
    case .one:
      return "AppIcon-\(size.data.pixelWidth).png"
    case .two, .three:
      return "AppIcon-\(size.data.pixelWidth)-\(size.data.baseWidth)\(size.data.scale.rawValue).png"
    }
  }
}
