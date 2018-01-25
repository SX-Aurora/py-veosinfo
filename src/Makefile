PYLIBDIR = $(shell python-config --exec-prefix)/lib
LIBS = -L$(PYLIBDIR) $(shell python-config --libs) -lboost_python
INC = $(shell python-config --include)
VEOSLIB = /opt/nec/ve/veos/lib64
VEOSINC = -I/opt/nec/ve/veos/include
INC += $(VEOSINC)
LIBS += -L$(VEOSLIB) -lveosinfo
CFLAGS = -O2 -fPIC
CFLAGS += -std=c++11
LDFLAGS = -Wl,-rpath,$(PYLIBDIR) -Wl,-rpath,$(VEOSLIB) -shared
CC = g++
LD = gcc

TARGET = veosinfo.so
SOURCES = $(wildcard *.cpp)
OBJECTS = $(patsubst %cpp,%o,$(SOURCES))

all: $(TARGET)

veosinfo.so: $(OBJECTS)
	$(LD) $(LDFLAGS) $(LIBS) $^ -o $@

%.o: %.cpp Makefile
	$(CC) -c $(INC) $(CFLAGS) $< -o $@

clean:
	rm -f $(OBJECTS) $(TARGET)

.PHONY: all clean
