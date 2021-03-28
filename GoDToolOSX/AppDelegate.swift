//
//  AppDelegate.swift
//  GoD Tool
//
//  Created by StarsMmd on 29/06/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import AppKit

let appDelegate = (NSApp.delegate as! AppDelegate)

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	
	var homeViewController : GoDHomeViewController!
	
	@IBOutlet weak var scriptMenuItem: NSMenuItem!
	
	@IBOutlet weak var godtoolmenuitem: NSMenuItem!
	@IBOutlet weak var godtoolaboutmenuitem: NSMenuItem!
	@IBOutlet weak var quitgodtoolmenuitem: NSMenuItem!
	@IBOutlet weak var godtoolhelpmenuitem: NSMenuItem!

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application

		if game == .Colosseum {
			scriptMenuItem.isHidden = true
			godtoolmenuitem.title = "Colosseum Tool"
			godtoolaboutmenuitem.title = "About Colosseum Tool"
			quitgodtoolmenuitem.title = "Quit Colosseum Tool"
			godtoolhelpmenuitem.title = "Colosseum Tool Help"
		}
	}

	func decodeInputFiles(_ files: [XGFiles]) {
		fileDecodingMode = true
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
				break
			}
		}
		fileDecodingMode = false
	}
    
    func application(_ application: NSApplication, open urls: [URL]) {
		if urls.count > 0 {
			let files = urls.map { (fileurl) -> XGFiles in
				return fileurl.file
			}.filter{$0.fileType != .unknown}

			openFiles(files)
		}
    }

	func openFiles(_ files: [XGFiles]) {
		guard files.count > 0 else {
			printg("No input files given.")
			return
		}

		if let isoFile = files.first(where: {$0.fileType == .iso && $0.exists}) {
			printg("opening ISO:", isoFile.path)
			guard XGISO.loadISO(file: isoFile) else {
				return
			}
			homeViewController.reload()
		} else {
			decodeInputFiles(files)
			return
		}

		let noDocumentsFolder = !XGFolders.Documents.exists
		XGFolders.setUpFolderFormat()
		if noDocumentsFolder {
			printg("Created folder structure at:", XGFolders.Documents.path)
		}
	}
	
	func applicationWillTerminate(_ aNotification: Notification) {
		printg("The tool is now closing.")
		if XGFolders.LZSS.files.count > 0 {
			printg("deleting LZSS files...")
		}
		for file in XGFolders.LZSS.files where file.fileType == .lzss {
			file.delete()
		}
	}

	@IBAction func openFilePicker(_ sender: Any) {
		let panel = NSOpenPanel()
		panel.allowsMultipleSelection = true
		panel.canChooseDirectories = false
		panel.canChooseFiles = true
		panel.canDownloadUbiquitousContents = false
		panel.canResolveUbiquitousConflicts = false
		panel.isAccessoryViewDisclosed = false
		panel.resolvesAliases = true
		panel.allowedFileTypes = ["gtx", "atx", "msg", "fsys", "iso"]
		panel.begin { (result) in
			if result == .OK {
				let urls = panel.urls
				if urls.count > 0 {
					self.application(NSApplication.shared, open: urls)
				}
			}
		}
	}

	@IBAction func addFileToISO(_ sender: Any) {
		let panel = NSOpenPanel()
		panel.allowsMultipleSelection = false
		panel.canChooseDirectories = false
		panel.canChooseFiles = true
		panel.canDownloadUbiquitousContents = false
		panel.canResolveUbiquitousConflicts = false
		panel.isAccessoryViewDisclosed = false
		panel.resolvesAliases = true
		panel.begin { (result) in
			if result == .OK {
				let urls = panel.urls
				if urls.count > 0 {
					let files = urls.map { (fileurl) -> XGFiles in
						return fileurl.file
					}.filter{$0.fileType != .unknown}
					files.forEach { (file) in
						XGISO.current.addFile(file, save: true)
					}
				}
			}
		}
	}

	@IBAction func getFreeStringID(_ sender: Any) {
		#if !GAME_PBR
		guard checkRequiredFiles() else {
			return
		}
		
		guard !isSearchingForFreeStringID else {
			self.displayAlert(title: "Please wait", text: "Please wait for previous string id search to complete.")
			return
		}

		printg("Searching for free string id...")
		XGThreadManager.manager.runInBackgroundAsync {
			if let id = freeMSGID() {
				XGThreadManager.manager.runInForegroundAsync {
					self.displayAlert(title: "Free String ID", text: "The next free id is: \(id) (\(id.hexString()))")
				}
			} else {
				XGThreadManager.manager.runInForegroundAsync {
					self.displayAlert(title: "Free String ID", text: "Failed to find a free string id")
				}
			}
		}
		#endif
	}
	
	@IBAction func importTextures(_ sender: Any) {
		guard checkRequiredFiles() else {
			return
		}
		XGUtility.importTextures()
	}
	
	@IBAction func exportTextures(_ sender: Any) {
		guard checkRequiredFiles() else {
			return
		}
		XGUtility.exportTextures()
	}
	
	
	@IBAction func setVerboseLogs(_ sender: Any) {
		printg("Set verbose logs")
//		settings.verbose = true
//		settings.save()
		XGUtility.deleteSuperfluousFiles()
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
	
	@IBAction func extractISO(_ sender: Any) {
		guard checkRequiredFiles() else {
			return
		}
		printg("extracting iso")

		XGFolders.setUpFolderFormat()
		XGUtility.extractAllFiles()
		
		printg("extraction complete")
		self.displayAlert(title: "ISO Extraction Complete", text: "Done.")
	}
	
	var isBuilding = false
	
	@IBAction func quickBuildISO(_ sender: Any) {
		guard checkRequiredFiles() else {
			return
		}
		guard !isBuilding else {
			self.displayAlert(title: "Please wait", text: "Please wait for previous build to complete.")
			return
		}
		isBuilding = true
		printg("Quick building ISO...")
		XGThreadManager.manager.runInBackgroundAsync {
			XGUtility.compileMainFiles()
			if filesTooLargeForReplacement != nil  {
				
				var text = "Files too large to replace:"
				
				for file in filesTooLargeForReplacement! {
					text += "\n\(file.fileName)"
				}
				
				text += "\n\nSet 'ISO > Enable File Size Increases' to include them."
				filesTooLargeForReplacement = nil
				
				XGThreadManager.manager.runInForegroundAsync {
					self.displayAlert(title: "Quick Build Incomplete", text: text)
				}
				
			} else {
				XGThreadManager.manager.runInForegroundAsync {
					self.displayAlert(title: "Done", text: "Quick build completed successfully!")
				}
			}
			self.isBuilding = false
		}
	}
	
	@IBAction func rebuildISO(_ sender: AnyObject) {
		guard checkRequiredFiles(allowAnyISO: true) else {
			return
		}
		guard !isBuilding else {
			self.displayAlert(title: "Please wait", text: "Please wait for previous build to complete.")
			return
		}
		isBuilding = true
		printg("Rebuilding ISO...")
		XGThreadManager.manager.runInBackgroundAsync {
			XGUtility.compileAllFiles()
			if filesTooLargeForReplacement != nil  {
				
				var text = "Files too large to replace:"
				
				for file in filesTooLargeForReplacement! {
					text += "\n\(file.fileName)"
				}
				
				text += "\n\nSet 'ISO > Enable File Size Increases' to include them."
				filesTooLargeForReplacement = nil
				
				XGThreadManager.manager.runInForegroundAsync {
					self.displayAlert(title: "Reuild Incomplete", text: text)
				}
			} else {
				XGThreadManager.manager.runInForegroundAsync {
					self.displayAlert(title: "Done", text: "ISO rebuild completed successfully!")
				}
			}
			self.isBuilding = false
		}
	
	}
	
	@IBAction func getXDSMacros(_ sender: Any) {
		guard checkRequiredFiles() else {
			return
		}
		XGThreadManager.manager.runInBackgroundAsync {
			if game == .XD {
				XGUtility.documentMacrosXDS()
				printg("Finished saving XDS macros file.")
			}
		}
	}
	
	@IBAction func getXDSClasses(_ sender: Any) {
		guard checkRequiredFiles() else {
			return
		}
		XGThreadManager.manager.runInBackgroundAsync {
			if game == .XD {
				XGUtility.documentXDSClasses()
				printg("Finished saving XDS classes file.")
			}
		}
	}
	
	@IBAction func saveSublime(_ sender: Any) {
		guard checkRequiredFiles() else {
			return
		}
		XGThreadManager.manager.runInBackgroundAsync {
			let files : [XGResources] = [
				XGResources.sublimeSyntax("XDScript"),
				XGResources.sublimeSettings("XDScript"),
				XGResources.sublimeColourScheme("XDScript"),
				//			XGResources.sublimeCompletions("XDScript"),
				XGResources.sublimeSyntax("SCD"),
				XGResources.sublimeColourScheme("SCD")
			]
			for file in files {
				printg("Saving: \(file.fileName) to folder: \(XGFolders.Reference.path)")
				let data = file.data
				data.file = .nameAndFolder(file.fileName, .Reference)
				data.save()
			}
			printg("Saving: XDScript.sublime-completions to folder: \(XGFolders.Reference.path). This may take a while")
			XGUtility.documentXDSAutoCompletions(toFile: .nameAndFolder("XDScript.sublime-completions", .Reference))
			printg("saved sublime files.")
		}
	}
	
	@IBAction func installSublime(_ sender: Any) {
		guard checkRequiredFiles() else {
			return
		}
		printg("Installing XDS Plugin files for Sublime Text 3...")
		XGThreadManager.manager.runInBackgroundAsync {
			let files : [XGResources] = [
				XGResources.sublimeSyntax("XDScript"),
				XGResources.sublimeSettings("XDScript"),
				XGResources.sublimeColourScheme("XDScript"),
				//			XGResources.sublimeCompletions("XDScript"),
				XGResources.sublimeSyntax("SCD"),
				XGResources.sublimeColourScheme("SCD")
			]
			
			let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0] + "/Application Support/Sublime Text 3/Packages"
			let folder = XGFolders.nameAndPath("User", path)
			if folder.exists {
				for file in files {
					let saveFile = XGFiles.nameAndFolder(file.fileName, folder)
					printg("Installing: \(file.fileName) to path: \(saveFile.path)")
					let data = file.data
					data.file = saveFile
					data.save()
				}
				let saveFile = XGFiles.nameAndFolder("XDScript.sublime-completions", folder)
				printg("Installing: XDScript.sublime-completions to path: \(saveFile.path). This may take a while.")
				XGUtility.documentXDSAutoCompletions(toFile: saveFile)
				printg("Installation Complete.")
			} else {
				printg("Failed to install. Couldn't find folder: \(folder.path)")
			}
		}
	}
	
	
	@IBAction func showHexCalculator(_ sender: Any) {
		homeViewController.performSegue(withIdentifier: "toHexCalcVC", sender: self.homeViewController)
	}
	
	@IBAction func showStringIDTool(_ sender: Any) {
		guard checkRequiredFiles() else {
			return
		}
		performSegue("toStringVC")
	}
	
	func present(_ controller: NSViewController) {
		homeViewController.presentAsModalWindow(controller)
	}
	
	
	@IBAction func showAbout(_ sender: AnyObject) {
		GoDAlertViewController.displayAlert(title: "About GoD Tool", text: aboutMessage())
	}
	
	@IBAction func showHelp(_ sender: Any) {
		self.performSegue("toHelpVC")
	}
	
	func createDirectories() {
		XGFolders.setUpFolderFormat()
	}
	
	func displayAlert(title: String, text: String) {
		GoDAlertViewController.displayAlert(title: title, text: text)
	}
	
	func performSegue(_ name: String) {
		guard checkRequiredFiles(allowAnyISO: name == "toISOVC") else {
			return
		}
		homeViewController.performSegue(withIdentifier: name, sender: self)
	}
	
	
	@IBAction func openTextureImporter(_ sender: Any) {
		performSegue("toTextureVC")
	}
	
	@IBAction func openScriptCompiler(_ sender: Any) {
		performSegue("toScriptVC")
	}
	
	@IBAction func openStatsEditor(_ sender: Any) {
		performSegue("toStatsVC")
	}
	
	@IBAction func openMoveEditor(_ sender: Any) {
		performSegue("toMoveVC")
	}
	
	@IBAction func openGiftEditor(_ sender: Any) {
		performSegue("toGiftVC")
	}
	
	@IBAction func openPatchEditor(_ sender: Any) {
		performSegue("toPatchVC")
	}
	
	@IBAction func openContextTool(_ sender: Any) {
		performSegue("toContextVC")
	}
	
	@IBAction func openRandomiser(_ sender: Any) {
		performSegue("toRandomiserVC")
	}
	
	@IBAction func exporeISO(_ sender: Any) {
		performSegue("toISOVC")
	}

	@discardableResult
	private func checkRequiredFiles(allowAnyISO: Bool = false) -> Bool {
		if game != .PBR && (XGISO.inputISOFile == nil || !XGFiles.iso.exists) {
			if let appDelegate = (NSApplication.shared.delegate as? AppDelegate) {
				appDelegate.openFilePicker(self)
			} else {
				homeViewController.performSegue(withIdentifier: "toHelpVC", sender: self)
			}
			return false
		}
		if game == .PBR && (!XGFiles.fsys("common").exists || !XGFiles.iso.exists) {
			homeViewController.performSegue(withIdentifier: "toHelpVC", sender: self)
			return false
		}
		guard allowAnyISO || region != .OtherGame else {
			displayAlert(title: "Not available", text: "This option is only for \(game.name)")
			return false
		}
		return true
	}
	
}























