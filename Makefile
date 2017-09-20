CC=gcc

CFLAGS=-Wall -pedantic -g -D_THREAD_SAFE -pthread -DDEBUG
LDFLAGS=-L$(HIDAPI_LIBDIR) -lhidapi-libusb

C2API_SOURCES=c2api.cpp csafe.cpp csafe_util.cpp debug.cpp utils.cpp

C2API_OBJS=$(C2API_SOURCES:.cpp=.o)

.cpp.o:
	$(CC) -I$(HIDAPI_INCDIR) $(CFLAGS) -c $< -o $@

c2: $(C2API_OBJS) c2.o
	$(CC) -o $@ $^ $(LDFLAGS)

all: c2

unittests: ut_utils ut_csafe

ut_utils: utils.cpp
	$(CC) $(CFLAGS) -o $@ -DUNITTEST_UTILS utils.cpp

ut_csafe: csafe.cpp csafe.h debug.cpp debug.h utils.cpp utils.h
	$(CC) $(CFLAGS) -o $@ -DUNITTEST_CSAFE csafe.cpp debug.cpp utils.cpp

dep:
	makedepend -I$(HIDAPI_INCDIR) $(C2API_SOURCES)

# preprocess macros out of csafe.cpp
pre: csafe.cpp
	$(CC) -E -I$(HIDAPI_INCDIR) $(CFLAGS) -E csafe.cpp -o csafe-pre.cpp

clean: dep
	/bin/rm -rf *.dSYM
	/bin/rm -f c2
	/bin/rm -f ut_*
	/bin/rm -f *.o
	/bin/rm -f Makefile.bak
	/bin/rm -f csafe-pre.cpp
# DO NOT DELETE

c2api.o: csafe.h csafe_util.h
c2api.o: debug.h utils.h
csafe.o: csafe.h
csafe.o: debug.h utils.h
csafe_util.o: csafe.h utils.h
