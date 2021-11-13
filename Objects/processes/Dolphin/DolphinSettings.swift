//
//  DolphinSettings.swift
//  GoD Tool
//
//  Created by Stars Momodu on 29/09/2021.
//

import Foundation

enum DolphinSystems {
	case Dolphin(DolphinSections)
	case GFX(GFXSections)
//	case SYSCONF
//	case Logger
//	case GCPadNew
//	case WiimoteNew

	var string: String {
		switch self {
		case .Dolphin(let section):
			return "Dolphin." + section.string
		case .GFX(let section):
			return "GFX." + section.string
		}
	}
}

enum GFXSections {
	case Settings(GFXSettingsKeys)
	case Enhancements(GFXEnhancementsKeys)
//	case Stereoscopy(GFXStereoscopyKeys)
	case Hacks(GFXHacksKeys)

	var string: String {
		switch self {
		case .Settings(let key):
			return "Settings." + key.rawValue
		case .Enhancements(let key):
			return "Enhancements." + key.rawValue
		case .Hacks(let key):
			return "Hacks." + key.rawValue
		}
	}
}

enum GFXSettingsKeys: String {
	case wideScreenHack
	case ShowFPS
	case EnableGPUTextureDecoding
	case EnablePixelLighting
	case FastDepthCalc
	case DisableFog
	case BackendMultithreading
	case WaitForShadersBeforeStarting
	case SaveTextureCacheToState
}

enum GFXEnhancementsKeys: String {
	case ForceFiltering
	case ForceTrueColor
	case DisableCopyFilter
	case ArbitraryMipmapDetection
}

enum GFXHacksKeys: String {
	case EFBAccessEnable
	case BBoxEnable
	case EFBToTextureEnable
	case XFBToTextureEnable
	case DeferEFBCopies
	case ImmediateXFBEnable
	case SkipDuplicateXFBs
	case EFBScaledCopy
	case EFBEmulateFormatChanges
	case VertexRounding
}

enum DolphinSections {
	// seach `GetOrCreateSection` in Dolphin repo to find where they're used and see keys
	case Core(DolphinCoreKeys)
	case Input(DolphinInputKeys)
	case General(DolphinGeneralKeys)
	case Interface(DolphinInterfaceKeys)

	// case DSP(DolphinDSPKeys)
	// case FifoPlayer(DolphinFifoPlayerKeys)
	// case Debug(DolphinDebugKeys)
	// case Order(DolphinOrderKeys)
	// case Movie(DolphinMovieKeys)
	// case Android(DolphinAndroidKeys)
	// case Profile(DolphinProfileKeys)
	// case HotKeys(DolphinHotKeysKeys)
	// case Controls(DolphinControlsKeys)
	// case GameList(DolphinGameListKeys)
	// case AutoUpdate(DolphinAutoUpdateKeys)
	// case USBKeyboard(DolphinUSBKeyboardKeys) // value is "USB Keyboard"
	// case BluetoothPassthrough(DolphinBluetoothPassthroughKeys)
	// case USBPassthrough(DolphinUSBPassthroughKeys)

	var string: String {
		switch self {
		case .Core(let key):
			return "Core." + key.rawValue
		case .Input(let key):
			return "Input." + key.rawValue
		case .General(let key):
			return "General." + key.rawValue
		case .Interface(let key):
			return "Interface." + key.rawValue
		}
	}
}

enum DolphinCoreKeys: String {
	case SkipIPL
	case TimingVariance
	case CPUCore
	case Fastmem
	case CPUThread
	case DSPHLE
	case SyncOnSkipIdle
	case SyncGPU
	case SyncGpuMaxDistance
	case SyncGpuMinDistance
	case SyncGpuOverclock
	case FPRF
	case AccurateNaNs
	case SelectedLanguage
	case OverrideRegionSettings
	case DPL2Decoder
	case AudioLatency
	case AudioStretch
	case AudioStretchMaxLatency
	case AgpCartAPath
	case AgpCartBPath
	case SlotA
	case SlotB
	case SerialPort1
	case BBA_MAC
	case BBA_XLINK_IP
	case BBA_XLINK_CHAT_OSD
	case SIDevice0 // 1,2,3
	case AdapterRumble0 // 1,2,3
	case SimulateKonga0 // 1,2,3
	case WiiSDCard
	case WiiKeyboard
	case WiimoteContinuousScanning
	case WiimoteEnableSpeaker
	case WiimoteControllerInterface
	case RunCompareServer
	case RunCompareClient
	case MMU
	case EmulationSpeed
	case Overclock
	case OverclockEnable
	case GPUDeterminismMode
	case PerfMapDir
	case EnableCustomRTC
	case CustomRTCValue
	case DisableICache
	case MemoryCardSize
	case EnableCheats
}

enum DolphinInputKeys: String {
	case BackgroundInput
}

enum DolphinGeneralKeys: String {
	case ShowLag
	case ShowFrameCount
	case ISOPaths
	case WirelessMac
	case GDBSocket
	case GDBPort
}

enum DolphinInterfaceKeys: String {
	case ConfirmStop
	case HideCursor
	case LockCursor
	case LanguageCode
	case ExtendedFPSInfo
	case ShowActiveTitle
	case UseBuiltinTitleDatabase
	case ThemeName
	case PauseOnFocusLost
	case DebugModeEnabled

}
