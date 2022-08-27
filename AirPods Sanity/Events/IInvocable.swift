//
// Created by Tobias Punke on 27.08.22.
//

import Foundation

protocol IInvocable: AnyObject
{
	func invoke(data: Any)
}
