
main: libfoo.dylib libbar.dylib
	clang++ main.cpp -g -o main -L. -lfoo -lbar
    
libfoo.dylib : Foo.*
	clang++ -shared -fPIC -g foo.cpp -o libfoo.dylib

libbar.dylib : Bar.*
	clang++ -shared -fPIC -g bar.cpp -o libbar.dylib -L. -lfoo

.PHONY : clean

clean :
	@rm -f main *.dylib
