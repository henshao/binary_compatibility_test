all: libFoo.dylib libBar.dylib
	swiftc -g -I. -L. -lFoo -lBar main.swift

libFoo.dylib: Foo.*
	swiftc -g -emit-module -emit-library Foo.swift

libBar.dylib: Bar.*
	swiftc -g -emit-module -emit-library Bar.swift -I. -L. -lFoo

.PHONY : clean

clean :
	@rm -f main *.dylib
