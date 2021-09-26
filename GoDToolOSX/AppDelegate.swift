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

	@IBOutlet weak var scriptClassesMenuItem: NSMenuItem!
	@IBOutlet weak var scriptCompilerMenuItem: NSMenuItem!
	@IBOutlet weak var experimentalFeaturesMenuItem: NSMenuItem!

	@IBOutlet weak var godtoolmenuitem: NSMenuItem!
	@IBOutlet weak var godtoolaboutmenuitem: NSMenuItem!
	@IBOutlet weak var quitgodtoolmenuitem: NSMenuItem!
	@IBOutlet weak var godtoolhelpmenuitem: NSMenuItem!

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application

		if game == .Colosseum {
			scriptClassesMenuItem.isHidden = true
			scriptCompilerMenuItem.isHidden = true
			godtoolmenuitem.title = "Colosseum Tool"
			godtoolaboutmenuitem.title = "About Colosseum Tool"
			quitgodtoolmenuitem.title = "Quit Colosseum Tool"
			godtoolhelpmenuitem.title = "Colosseum Tool Help"
		}
	}

	func decodeInputFiles(_ files: [XGFiles]) {
		// if no iso has been loaded then the tool needs to load these files without context from the rest of the iso
		fileDecodingMode = XGISO.inputISOFile == nil
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
				updateExperimentalMenuItem()
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
						XGISO.current.addFile(file, fsysID: nil, save: true)
					}
				}
			}
		}
	}

	@IBAction func getFreeStringID(_ sender: Any) {
		#if !GAME_PBR
		guard homeViewController.checkRequiredFiles() else {
			return
		}
		
		guard !isSearchingForFreeStringID else {
			displayAlert(title: "Please wait", description: "Please wait for previous string id search to complete.")
			return
		}

		printg("Searching for free string id...")
		XGThreadManager.manager.runInBackgroundAsync {
			if let id = freeMSGID() {
				XGThreadManager.manager.runInForegroundAsync {
					displayAlert(title: "Free String ID", description: "The next free id is: \(id) (\(id.hexString()))")
				}
			} else {
				XGThreadManager.manager.runInForegroundAsync {
					displayAlert(title: "Free String ID", description: "Failed to find a free string id")
				}
			}
		}
		#endif
	}
	
	@IBAction func enableExperimentalFeatures(_ sender: Any) {
		settings.enableExperimentalFeatures = !settings.enableExperimentalFeatures
		settings.save()
		updateExperimentalMenuItem()
	}

	func updateExperimentalMenuItem() {
		experimentalFeaturesMenuItem.title = settings.enableExperimentalFeatures ? "Disable Experimental Features" : "Enable Experimental Features"
		experimentalFeaturesMenuItem.isEnabled = XGISO.inputISOFile != nil
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
	
	@IBAction func extractISO(_ sender: Any) {
		guard homeViewController.checkRequiredFiles() else {
			return
		}
		printg("extracting iso")

		XGFolders.setUpFolderFormat()
		XGUtility.extractAllFiles()
		
		printg("extraction complete")
		displayAlert(title: "ISO Extraction Complete", description: "Done.")
	}
	
	var isBuilding = false
	
	@IBAction func quickBuildISO(_ sender: Any) {
		guard homeViewController.checkRequiredFiles() else {
			return
		}
		guard !isBuilding else {
			displayAlert(title: "Please wait", description: "Please wait for previous build to complete.")
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
				
				displayAlert(title: "Quick Build Incomplete", description: text)
				
			} else {
				displayAlert(title: "Done", description: "Quick build completed successfully!")
			}
			self.isBuilding = false
		}
	}
	
	@IBAction func rebuildISO(_ sender: AnyObject) {
		guard homeViewController.checkRequiredFiles() else {
			return
		}
		guard !isBuilding else {
			displayAlert(title: "Please wait", description: "Please wait for previous build to complete.")
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

				displayAlert(title: "Reuild Incomplete", description: text)
			} else {
				displayAlert(title: "Done", description: "ISO rebuild completed successfully!")
			}
			self.isBuilding = false
		}
	
	}
	
	@IBAction func getXDSMacros(_ sender: Any) {
		guard homeViewController.checkRequiredFiles() else {
			return
		}
		XGThreadManager.manager.runInBackgroundAsync {
			if game != .PBR {
				XGUtility.documentMacrosXDS()
				printg("Finished saving XDS macros file.")
			}
		}
	}
	
	@IBAction func getXDSClasses(_ sender: Any) {
		guard homeViewController.checkRequiredFiles() else {
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
		guard homeViewController.checkRequiredFiles() else {
			return
		}
		XGThreadManager.manager.runInBackgroundAsync {
			let formatName = game == .Colosseum ? "CMS" : "XDS"
			let files : [XGResources] = [
				XGResources.sublimeSyntax("\(formatName)cript"),
				XGResources.sublimeSettings("\(formatName)ript"),
				XGResources.sublimeColourScheme("\(formatName)ript"),
				XGResources.sublimeSyntax("SCD"),
				XGResources.sublimeColourScheme("SCD"),
				XGResources.sublimePreferences("Comments")
			]
			let folder = XGFolders.nameAndFolder("Sublime", .Reference)
			for file in files {
				printg("Saving: \(file.fileName) to folder: \(folder.path)")
				let data = file.data
				data.file = .nameAndFolder(file.fileName, folder)
				data.save()
			}
			printg("Saving: \(formatName)ript.sublime-completions to folder: \(folder.path). This may take a while")
			if !fileDecodingMode {
				XGUtility.documentXDSAutoCompletions(toFile: .nameAndFolder("\(formatName)ript.sublime-completions", folder))
			}
			printg("saved sublime files.")
		}
	}
	
	@IBAction func installSublime(_ sender: Any) {
		guard homeViewController.checkRequiredFiles() else {
			return
		}
		let formatName = game == .Colosseum ? "CMS" : "XDS"
		printg("Installing \(formatName) Plugin files for Sublime Text 3...")
		XGThreadManager.manager.runInBackgroundAsync {
			let files : [XGResources] = [
				XGResources.sublimeSyntax("\(formatName)cript"),
				XGResources.sublimeSettings("\(formatName)cript"),
				XGResources.sublimeColourScheme("\(formatName)cript"),
				XGResources.sublimeSyntax("SCD"),
				XGResources.sublimeColourScheme("SCD"),
				XGResources.sublimePreferences("Comments")
			]
			
			let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0] + "/Application Support/Sublime Text 3/Packages"
			let folder = XGFolders.nameAndPath("User", path)
			folder.createDirectory()
			if folder.exists {
				for file in files {
					let saveFile = XGFiles.nameAndFolder(file.fileName, folder)
					printg("Installing: \(file.fileName) to path: \(saveFile.path)")
					let data = file.data
					data.file = saveFile
					data.save()
				}
				let saveFile = XGFiles.nameAndFolder("\(formatName)cript.sublime-completions", folder)
				printg("Installing: \(formatName)cript.sublime-completions to path: \(saveFile.path). This may take a while.")
				if !fileDecodingMode {
					XGUtility.documentXDSAutoCompletions(toFile: saveFile)
				}
				printg("Installation Complete.")
			} else {
				printg("Failed to install. Couldn't find folder: \(folder.path)")
			}
		}
	}

	@IBAction func dumpTextures(_ sender: Any) {
		guard homeViewController.checkRequiredFiles() else {
			return
		}
		displayAlert(title: "Dumping Textures", description: "This will run in the background. It will take a while. There will be an alert once it is done.")
		XGThreadManager.manager.runInBackgroundAsync {
			XGUtility.extractAllTextures(forDolphin: false)
			displayAlert(title: "Texture Dump Finsihed", description: "Done.")
		}
	}

	@IBAction func dumpDolphinTextures(_ sender: Any) {
		guard homeViewController.checkRequiredFiles() else {
			return
		}
		displayAlert(title: "Dumping Textures", description: "This will run in the background. It will take a while. There will be an alert once it is done.")
		XGThreadManager.manager.runInBackgroundAsync {
			XGUtility.extractAllTextures(forDolphin: true)
			displayAlert(title: "Texture Dump Finsihed", description: "Done.")
		}
	}

	#if GAME_PBR
	@IBAction func create1Pokemon(_ sender: Any) {
		guard homeViewController.checkRequiredFiles() else {
			return
		}
		XGPatcher.increasePokemonTotal(by: 1)
	}

	@IBAction func create10Pokemon(_ sender: Any) {
		guard homeViewController.checkRequiredFiles() else {
			return
		}
		XGPatcher.increasePokemonTotal(by: 10)
	}

	@IBAction func create100Pokemon(_ sender: Any) {
		guard homeViewController.checkRequiredFiles() else {
			return
		}
		XGPatcher.increasePokemonTotal(by: 100)
	}
	#endif
	
	
	@IBAction func showHexCalculator(_ sender: Any) {
		homeViewController.performSegue(withIdentifier: "toHexCalcVC", sender: self.homeViewController)
	}
	
	@IBAction func showStringIDTool(_ sender: Any) {
		performSegue("toStringVC")
	}
	
	func present(_ controller: NSViewController) {
		homeViewController.presentAsModalWindow(controller)
	}
	
	
	@IBAction func showAbout(_ sender: AnyObject) {
		displayAlert(title: "About GoD Tool", description: aboutMessage())
	}
	
	@IBAction func showHelp(_ sender: Any) {
		self.performSegue("toHelpVC")
	}
	
	func performSegue(_ name: String) {
		let alwaysAllowedSegues = ["toAlertVC", "toAboutVC"]
		guard alwaysAllowedSegues.contains(name) || homeViewController.checkRequiredFiles() else {
			return
		}
		homeViewController.performSegue(withIdentifier: name, sender: self)
	}
	
	
	@IBAction func openTextureImporter(_ sender: Any) {
		guard homeViewController.checkRequiredFiles() else {
			return
		}
		performSegue("toTextureVC")
	}
	
	@IBAction func openScriptCompiler(_ sender: Any) {
		guard homeViewController.checkRequiredFiles() else {
			return
		}
		performSegue("toScriptVC")
	}
	
	@IBAction func openStatsEditor(_ sender: Any) {
		guard homeViewController.checkRequiredFiles() else {
			return
		}
		performSegue("toStatsVC")
	}
	
	@IBAction func openMoveEditor(_ sender: Any) {
		guard homeViewController.checkRequiredFiles() else {
			return
		}
		performSegue("toMoveVC")
	}
	
	@IBAction func openGiftEditor(_ sender: Any) {
		guard homeViewController.checkRequiredFiles() else {
			return
		}
		performSegue("toGiftVC")
	}
	
	@IBAction func openPatchEditor(_ sender: Any) {
		guard homeViewController.checkRequiredFiles() else {
			return
		}
		performSegue("toPatchVC")
	}
	
	@IBAction func openContextTool(_ sender: Any) {
		guard homeViewController.checkRequiredFiles() else {
			return
		}
		performSegue("toContextVC")
	}
	
	@IBAction func openRandomiser(_ sender: Any) {
		guard homeViewController.checkRequiredFiles() else {
			return
		}
		performSegue("toRandomiserVC")
	}
	
	@IBAction func exporeISO(_ sender: Any) {
		guard homeViewController.checkRequiredFiles() else {
			return
		}
		performSegue("toISOVC")
	}
}























