import Foundation
import FoundationNetworking

extension XGCompiler {
	class func Blanco() -> Int {
        return 0
    }
}

extension FileManager {
    /// Create a new empty temporary directory.  Caller must delete.
    func createTemporaryDirectory(inDirectory directory: URL? = nil, name: String? = nil) throws -> URL {
        let directoryName = name ?? UUID().uuidString
        let parentDirectoryURL = directory ?? temporaryDirectory
        let directoryURL = parentDirectoryURL.appendingPathComponent(directoryName)
        try createDirectory(at: directoryURL, withIntermediateDirectories: false)
        return directoryURL
    }

    /// Get a new temporary filename.  Caller must delete.
    func temporaryFileURL(inDirectory directory: URL? = nil) -> URL {
        let filename     = UUID().uuidString
        let directoryURL = directory ?? temporaryDirectory
        return directoryURL.appendingPathComponent(filename)
    }

    /// A file URL for the current directory
    var currentDirectory: URL {
        URL(fileURLWithPath: currentDirectoryPath)
    }
}

final class XGTemporaryDirectory {
    let directoryURL: URL
    /// Set true to keep the directory after this `TemporaryDirectory` object expires
    var keepDirectory = false

    /// Create a new temporary directory somewhere in the filesystem that by default will be deleted
    /// along with its contents when the object goes out of scope.
    init() throws {
        directoryURL = try FileManager.default.createTemporaryDirectory()
    }

    /// Wrap an existing directory that, by default, will not be deleted when this object goes out of scope.
    init(url: URL) {
        directoryURL = url
        keepDirectory = true
    }

    deinit {
        if !keepDirectory {
            try? FileManager.default.removeItem(at: directoryURL)
        }
    }

    /// Get a path for a temp file in this object's directory.  File doesn't exist, directory does.
    func createFile(name: String? = nil) throws -> URL {
        if let name = name {
            return directoryURL.appendingPathComponent(name)
        }
        return FileManager.default.temporaryFileURL(inDirectory: directoryURL)
    }

    /// Get a path for a subdirectory in this object's directory.
    /// The new `TemporaryDirectory` is not auto-delete by default.
    func createDirectory(name: String? = nil) throws -> XGTemporaryDirectory {
        let url = try FileManager.default.createTemporaryDirectory(inDirectory: directoryURL, name: name)
        return XGTemporaryDirectory(url: url)
    }
}

extension URLSession {
    func synchronousDataTask(urlrequest: URLRequest) -> (data: Data?, response: URLResponse?, error: Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?

        let semaphore = DispatchSemaphore(value: 0)

        let dataTask = self.dataTask(with: urlrequest) {
            data = $0
            response = $1
            error = $2

            semaphore.signal()
        }
        dataTask.resume()

        _ = semaphore.wait(timeout: .distantFuture)

        return (data, response, error)
    }
}
