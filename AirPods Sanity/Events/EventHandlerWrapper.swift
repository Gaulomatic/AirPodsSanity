//
// Created by Tobias Punke on 27.08.22.
//

import Foundation

class EventHandlerWrapper<T: AnyObject, U> : IInvocable, IDisposable
{
	weak var target: T?
	let handler: (T) -> (U) -> ()
	let event: Event<U>

	init(target: T?, handler: @escaping (T) -> (U) -> (), event: Event<U>)
	{
		self.target = target
		self.handler = handler
		self.event = event;
	}

	func invoke(data: Any) -> ()
	{
		if let t = target
		{
			handler(t)(data as! U)
		}
	}

	func dispose()
	{
		event.eventHandlers = event.eventHandlers.filter
		{
			$0 !== self
		}
	}
}
