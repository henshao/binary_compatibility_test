
// Bar.swift

import Foo

open class Bar : Foo {
    public var prop3 : String?

    override public init() {
    }

    public func func3() {
        print("func3: prop3=\(String(describing:self.prop3))")
    }
}
