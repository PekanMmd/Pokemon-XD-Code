//
//  AppDelegate.swift
//  PBR Tool
//
//  Created by The Steez on 11/01/2019.
//

import Cocoa

let appDelegate = (NSApp.delegate as! AppDelegate)

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	var homeViewController : GoDHomeViewController!

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		createDirectories()
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		printg("The tool is now closing.")
		printg("deleting LZSS files...")
		for file in XGFolders.LZSS.files where file.fileType == .lzss {
			file.delete()
		}
		printg("Good bye :-)")
	}

	func decodeInputFiles(_ files: [XGFiles]) {
		for file in files {
			guard file.exists else {
				printg("cannot open file:", file.path, "\nIt doesn't exist.")
				continue
			}
			printg("opening filepath:", file.path)

			switch file.fileType {
			case .gtx, .atx:
				let texture = file.texture
				let vc = GoDGTXViewController()
				vc.texture = texture
				present(vc)
			case .msg:
				let table = file.stringTable
				let storyboard = NSStoryboard(name: "Messages", bundle: nil)
				if let vc = storyboard.instantiateInitialController() as? GoDMessageViewController {
					vc.singleTable = table
					present(vc)
				}
			case .fsys:
				let outputFolder = XGFolders.nameAndFolder(file.fileName.removeFileExtensions(), file.folder)
				outputFolder.createDirectory()
				printg("Unzipping contents of \(file.path) to \(outputFolder.path)")
				let fsysData = file.fsysData
				fsysData.extractFilesToFolder(folder: outputFolder, decode: true)
			default:
				continue
			}
		}
	}

	func application(_ application: NSApplication, open urls: [URL]) {
		printg("opening files")

		if urls.count > 0 {
			let files = urls.map { (fileurl) -> XGFiles in
				return fileurl.file
			}
			if files.count == 1, files[0].fileType == .iso {
				inputISOFile = files[0]
			} else {
				decodeInputFiles(files)
				return
			}
		}
	}

	@IBAction func setVerboseLogs(_ sender: Any) {
		printg("Set verbose logs")
		settings.verbose = true
		settings.save()
	}

	@IBAction func setFastLogs(_ sender: Any) {
		printg("Set fast logs")
		settings.verbose = false
		settings.save()
	}

	@IBAction func deleteLogs(_ sender: Any) {
		printg("Deleting logs...")
		for file in XGFolders.Logs.files where file.fileType == .txt {
			file.delete()
		}
		printg("Logs deleted")
	}

	@IBOutlet weak var fileSizeMenuItem: NSMenuItem!

	@IBAction func toggleAllowIncreasedFileSizes(_ sender: Any) {
		settings.increaseFileSizes = !settings.increaseFileSizes
		settings.save()
		if settings.increaseFileSizes {
			printg("Enabled file size increases. This will stop the file importer from ignoring files that are larger than the original but importing might take a lot longer if the files are larger. Make sure your ISO has enough free space if using larger files.")
		}
		fileSizeMenuItem.title = settings.increaseFileSizes ? "Disable File Size Increases" : "Enable File Size Increases"
	}

	@IBAction func unpackISO(_ sender: AnyObject) {
		printg("Unpacking ISO...")
		XGThreadManager.manager.runInBackgroundAsync {
			let result = XGUtility.decompileISO(printOutput: false) ?? "No logs recorded"

			XGThreadManager.manager.runInForegroundAsync {
				self.displayAlert(title: "ISO Unpacking Complete", text: result)
			}
			self.isBuilding = false
		}
	}

	@IBAction func extractFSYS(_ sender: Any) {
		printg("extracting FSYS files")
		guard XGFolders.FSYS.exists, !XGFolders.FSYS.files.isEmpty else {
			let text = "The ISO must be unpacked first."
			printg(text)
			self.displayAlert(title: "Error", text: text)
			return
		}
		XGFolders.setUpFolderFormat()
		XGUtility.extractMainFiles()

		printg("extraction complete")
		self.displayAlert(title: "FSYS Extraction Complete", text: "Done.")
	}

	var isBuilding = false

	@IBAction func compileFSYS(_ sender: Any) {
		guard !isBuilding else {
			self.displayAlert(title: "Please wait", text: "Please wait for previous build to complete.")
			return
		}
		isBuilding = true
		printg("Importing into FSYS files...")
		XGThreadManager.manager.runInBackgroundAsync {
			XGUtility.compileMainFiles()

			XGThreadManager.manager.runInForegroundAsync {
				self.displayAlert(title: "Done", text: "Import completed successfully!")
			}

			self.isBuilding = false
		}
	}

	@IBAction func rebuildISO(_ sender: AnyObject) {
		guard !isBuilding else {
			self.displayAlert(title: "Please wait", text: "Please wait for previous build to complete.")
			return
		}
		isBuilding = true
		XGThreadManager.manager.runInBackgroundAsync {
			let result = XGUtility.compileISO(printOutput: false) ?? "No logs recorded"

			XGThreadManager.manager.runInForegroundAsync {
				self.displayAlert(title: "ISO Rebuild completed", text: result)
			}
			self.isBuilding = false
		}
	}

	var isDocumenting = false
	@IBAction func documentISO(_ sender: Any) {
		guard !isDocumenting else {
			return
		}
		isDocumenting = true
		printg("Documenting ISO...")
		XGThreadManager.manager.runInBackgroundAsync {
			XGUtility.documentISO()
			self.isDocumenting = false
		}
	}
	
	func createDirectories() {
		XGFolders.setUpFolderFormat()
	}

	@IBAction func showHexCalculator(_ sender: Any) {
		performSegue("toHexCalcVC")
	}

	@IBAction func showAbout(_ sender: AnyObject) {
		let text = """
		PBR Tool \(versionNumber)
		by @StarsMmd

		source code: https://github.com/PekanMmd/Pokemon-XD-Code.git
		"""
		GoDAlertViewController.displayAlert(title: "About GoD Tool", text: text)
	}

	@IBAction func showHelp(_ sender: Any) {
		self.performSegue("toHelpVC")
	}

	func performSegue(_ name: String) {
		guard XGFiles.fsys("common").exists else {
			self.homeViewController.performSegue(withIdentifier: "toHelpVC", sender: self.homeViewController)
			return
		}
		homeViewController.performSegue(withIdentifier: name, sender: self.homeViewController)
	}
	
	func present(_ controller: NSViewController) {
		homeViewController.presentAsModalWindow(controller)
	}

	func displayAlert(title: String, text: String) {
		GoDAlertViewController.displayAlert(title: title, text: text)
	}

}

