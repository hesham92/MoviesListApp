import Foundation
import Combine

extension Numeric where Self: LosslessStringConvertible {
    func formattedWithoutSeparatorAndCurrency() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.maximumFractionDigits = 0

        if let number = self as? NSNumber,
           let formatted = numberFormatter.string(from: number) {
            return "\(formatted) $"
        }
        return "\(self) $"
    }
}


extension Publisher {
  func asResult() -> some Publisher<Result<Output, Failure>, Never> {
    self
      .map(Result.success)
      .catch { error in
        Just(.failure(error))
      }
  }
}

