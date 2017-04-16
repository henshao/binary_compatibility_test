
main: main.cpp libfoo.dylib libbar.dylib
	clang++ main.cpp -g -o main -L. -lfoo -lbar
    
libfoo.dylib : Foo.*
	clang++ -shared -fPIC -g Foo.cpp -o libfoo.dylib

foo : Foo.*
	clang++ -shared -fPIC -g Foo.cpp -o libfoo.dylib

libbar.dylib : Bar.*
	clang++ -shared -fPIC -g Bar.cpp -o libbar.dylib -L. -lfoo

.PHONY : clean

clean :
	@rm -f main *.dylib
