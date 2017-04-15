
all: libfoo.dylib libbar.dylib
	clang -framework Foundation main.m -g -o main -L. -lfoo -lbar

libfoo.dylib : Foo.*
	clang -framework Foundation -shared -fPIC Foo.m -g -o libfoo.dylib

libbar.dylib : Bar.*
	clang -framework Foundation -shared -fPIC Bar.m -g -o libbar.dylib -L. -lfoo

.PHONY : clean

clean :
	@rm -f main *.dylib
