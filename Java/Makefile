all: foo.jar bar.jar
	javac -Djava.ext.dirs=. main.java

foo.jar: com/henshao/Foo.java
	javac -d . com/henshao/Foo.java
	jar -cf foo.jar com/henshao/Foo.class 

foo : com/henshao/Foo.java
	javac -d . com/henshao/Foo.java
	jar -cf foo.jar com/henshao/Foo.class 

bar.jar: com/henshao/Bar.java
	javac -Djava.ext.dirs=. -d . com/henshao/Bar.java
	jar -cf bar.jar com/henshao/Bar.class

.PHONY : run clean

clean :
	@rm -f *.jar *.class com/henshao/*.class

run:
	@java -classpath . main
