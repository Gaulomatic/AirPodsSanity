//
// Created by Tobias Punke on 27.08.22.
//

import Foundation

public class Event<T>
{
	public typealias EventHandler = (T) -> ()

	var eventHandlers = [IInvocable]()

	public func raise(data: T)
	{
		for handler in self.eventHandlers
		{
			handler.invoke(data: data)
		}
	}

	public func addHandler<U: AnyObject>(target: U, handler: @escaping (U) -> EventHandler) -> IDisposable
	{
		let wrapper = EventHandlerWrapper(target: target, handler: handler, event: self)
		eventHandlers.append(wrapper)
		return wrapper
	}
}
