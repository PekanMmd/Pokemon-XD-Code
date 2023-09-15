//
//  DiscordBot.swift
//  GoD Tool
//
//  Created by Stars Momodu on 10/10/2022.
//

import Foundation
import Swiftcord
import Darwin

protocol DiscordPlaysOrreEventsHandler: AnyObject {
	func reset()
	func ramDump()
	func saveState()
	func loadState()
	func rewindState(by: Int)
	func party()
}

class DiscordPlaysOrreEvents: ListenerAdapter {
	
	weak var eventsHandler: DiscordPlaysOrreEventsHandler?
	
	override func onReady(botUser: User) async {
		if XGSettings.current.verbose {
			printg("Connected to discord with id: \(botUser.id)")
		}
	}
	
	private func onMessageCreate(message: Message) async {
		if let author = message.author?.id, DiscordBot.ownerIDs.contains(author) {
			switch message.content.lowercased() {
			case "set input channel":
				XGSettings.current.dppInputChannelID = message.channel.id.rawValue
				message.addReaction(.success)
				XGSettings.current.save()
			case "set updates channel":
				XGSettings.current.dppUpdatesChannelID = message.channel.id.rawValue
				message.addReaction(.success)
				XGSettings.current.save()
			case "duration++":
				if XGSettings.current.dppInputDuration < 1.0 {
					XGSettings.current.dppInputDuration += 0.01
					let newDuration = XGSettings.current.dppInputDuration
					message.reply("> default button press duration is now set to: \(newDuration)")
					XGSettings.current.save()
				}
			case "duration--":
				if XGSettings.current.dppInputDuration > 0.1 {
					XGSettings.current.dppInputDuration -= 0.01
					let newDuration = XGSettings.current.dppInputDuration
					message.reply("> default button press duration is now set to: \(newDuration)")
					XGSettings.current.save()
				}
			case "duration":
				let duration = XGSettings.current.dppInputDuration
				message.reply("> default button press duration is set to: \(duration)")
			case "process -reset", "process -terminate":
				eventsHandler?.reset()
			case "process dump-ram":
				eventsHandler?.ramDump()
			case "process reload-settings":
				XGSettings.reload()
			case "process -save":
				eventsHandler?.saveState()
			case "process -load":
				eventsHandler?.loadState()
			case "party":
				eventsHandler?.party()
			default:
				break
			}
		}
		let hasPlus = message.content.hasSuffix("+")
		let hasMinus = message.content.hasSuffix("-")
		let duration = XGSettings.current.dppInputDuration * (hasPlus ? 5 : 1)
		let percentage: UInt = hasMinus ? 40 : 100
		switch message.content.lowercased().replacingOccurrences(of: "+", with: "") {
		case "controls":
			message.reply(controls)
		case "up": bufferStickInput(.stick(.up(percentage: percentage), duration: duration))
		case "down": bufferStickInput(.stick(.down(percentage: percentage), duration: duration))
		case "left": bufferStickInput(.stick(.left(percentage: percentage), duration: duration))
		case "right": bufferStickInput(.stick(.right(percentage: percentage), duration: duration))
		case "a": bufferButtonInput(.button(.A, duration: duration))
		case "b": bufferButtonInput(.button(.B, duration: duration))
		case "x": bufferButtonInput(.button(.X, duration: duration))
		case "y": bufferButtonInput(.button(.Y, duration: duration))
		case "l": bufferButtonInput(.button(.L, duration: duration))
		case "r": bufferButtonInput(.button(.R, duration: duration))
		case "z": bufferButtonInput(.button(.Z, duration: duration))
		case "start": bufferButtonInput(.button(.START, duration: duration))
		case "n": bufferButtonInput(.button(.NONE, duration: duration))
		default: break
		}
	}
	
	override func onMessageCreate(event: Message) async {
			await onMessageCreate(message: event)
	}
	
	private var bufferedButtons = SafeArray<GCPad>()
	private var bufferedStickInputs = SafeArray<GCPad>()
	private func bufferButtonInput(_ button: GCPad) {
		bufferedButtons.append(button)
	}
	private func bufferStickInput(_ input: GCPad) {
		bufferedStickInputs.append(input)
	}
	
	func nextInput() -> GCPad? {
		let buttons = bufferedButtons.randomElement
		let sticks = bufferedStickInputs.randomElement
		switch (buttons, sticks) {
		case (nil, nil): return nil
		case (let buttons, nil): return buttons
		case (nil, let sticks): return sticks
		case (let buttons, let sticks): return sticks?.maskedWith(pad: buttons!)
		}
	}
	
	func resetInput() {
		bufferedButtons.removeAll()
		bufferedStickInputs.removeAll()
	}
}

enum DiscordBot {
	
	static let ownerIDs: [Snowflake] = [206183960580063232, 297164490963943425]
	
	static func setup(token: String, listener: ListenerAdapter) -> SwiftcordClient {
		let bot = SwiftcordClient(
			token: token,
			options: .init(
				isBot: true,
				isDistributed: false,
				willCacheAllMembers: false,
				willLog: false,
				willShard: false
			)
		)
		bot.setIntents(intents: .guildMessages)
		bot.addListeners(listener)
		return bot
	}
}

enum DiscordPostTypes: Equatable {
	case update
	case context
}

extension SwiftcordClient {
	
	func postInfo(type: DiscordPostTypes, text: String, embeds: [EmbedBuilder]? = nil) {
		guard let channelID = (type == .context ? XGSettings.current.dppInputChannelID : XGSettings.current.dppUpdatesChannelID) else {
			return
		}
		if XGSettings.current.verbose {
			"Sending \(type == .context ? "context" : "updates"):".println()
			text.println()
			embeds?.forEach({ embed in
				if let jsonData = try? embed.JSONRepresentation(prettyPrint: true) {
					let text = String(data: jsonData, encoding: .utf8)
					text?.println()
				}
			})
		}
		Task {
			let channel = Snowflake(channelID)
			let sanitisedText = text.replacingOccurrences(of: "é", with: "e")
			let message = MessageBuilder()
				.setMessageContent(sanitisedText)
				.addEmbeds(embeds ?? [])
			_ = try? await send(message, to: channel)
		}
	}
}

extension EmbedBuilder {
	func setThumbnail(url: String?, height: Int? = nil, width: Int? = nil) -> EmbedBuilder {
		guard let url = url else {
			return self
		}
		return self.setThumbnail(url: url, height: height, width: width)
	}
	
	func addFields(_ fields: [EmbedBuilder.Field]) -> EmbedBuilder {
		var result = self
		for field in fields {
			result = result.addField(field.name, value: field.value, isInline: field.inline)
		}
		return result
	}
}

extension Message {
	func addReaction(_ emoji: Emoji) {
		Task {
			try? await addReaction(emoji.rawValue)
		}
	}
	
	func reply(_ message: String) {
		Task {
			try? await reply(with: message)
		}
	}
}

fileprivate extension DiscordPlaysOrreEvents {
	var controls: String {
	  """
	  > __**GC PAD Controls**__"
	  
	  
	  __Face Buttons__"
	  
	  **A** | **B** | **X** | **Y** | **START**"
	  
	  
	  __Shoulder Buttons__"
	  
	  **L** | **R** | **Z**"
	  
	  
	  __D Pad Buttons__"
	  
	  **UP** | **DOWN** | **LEFT** | **RIGHT**"
	  
	  
	  __Diagonal Movement__"
	  
	  **ULEFT** | **URIGHT** | **DLEFT** | **DRIGHT**"
	  
	  
	  __Lightly Tilt Stick__"
	  
	  **UP-** | **DOWN-** | **LEFT-** | **RIGHT-**"
	  
	  
	  __Hold Down Stick__"
	  
	  **UP+** | **DOWN+** | **LEFT+** | **RIGHT+**"
	  
	  
	  __No Input__"
	  
	  **N**"
	  
	  
	  __Commands__"
	  
	  **PARTY** | **CONTROLS**"
	  """
	}
}

actor AtomicList<T> {
	private var array = [T]()
	
	func addAsync(_ element: T) {
		array.append(element)
	}
	
	func resetAsync() {
		array = []
	}
	
	var elements: [T] {
		array
	}
	
	var randomElement: T? {
		array.randomElement()
	}
	
	subscript(async index: Int) -> T {
		get {
			array[index]
		}
		set {
			array[index] = newValue
		}
	}
	
	nonisolated
	func add(_ element: T) {
		Task {
			await addAsync(element)
		}
	}
	
	nonisolated
	func reset() {
		Task {
			await resetAsync()
		}
	}
}
