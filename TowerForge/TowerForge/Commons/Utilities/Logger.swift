import Foundation

/// A utility class to provide for a universal logging function. The logger class
/// can be set to be active if logging is required, within the Constants class.
///
/// Use case:
/// Standard - print("Value is \(variable)")
/// Alternative - Logger.log("Value is \(variable)", self)
///
/// Benefits:
/// - Can universally turn off logging, so the console output can be turned off before publication
/// - "self" argument will output the class name where the log function was invoked = easier debugging.
class Logger {
    static var isActive = Constants.LOGGING_IS_ACTIVE

    private init() { }

    static func log(_ string: String, _ caller: Any? = nil) {
        if isActive {
            let callerType = caller == nil ? "Unknown" : String(describing: type(of: caller!))
            let date = Date.now.formatted(date: .omitted, time: .standard)
            print("[\(date)] -- [\(callerType)] \(string)")
        }

    }
}
