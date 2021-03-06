PREFIX	 = /usr
OBJS	 = blocks.o \
	   child.o \
	   client.o \
	   fargs.o \
	   flist.o \
	   hash.o \
	   io.o \
	   log.o \
	   mkpath.o \
	   receiver.o \
	   sender.o \
	   server.o
ALLOBJS	 = $(OBJS) \
	   main.o
AFLS	 = afl/test-blk_recv \
	   afl/test-flist_recv
CFLAGS	+= -W -Wall -Wextra -Wno-unused-parameter

all: openrsync

openrsync: $(ALLOBJS)
	$(CC) -o $@ $(ALLOBJS)

afl: $(AFLS)

$(AFLS): $(OBJS)
	$(CC) -o $@ $*.c $(OBJS)

install: openrsync
	mkdir -p $(PREFIX)/bin
	mkdir -p $(PREFIX)/share/man/man1
	mkdir -p $(PREFIX)/share/man/man5
	install -m 0444 openrsync.1 $(PREFIX)/share/man/man1
	install -m 0444 rsync.5 $(PREFIX)/share/man/man5
	install -m 0555 openrsync $(PREFIX)/bin
	ln -f $(PREFIX)/bin/openrsync $(PREFIX)/bin/rsync

uninstall:
	rm -f $(PREFIX)/bin/openrsync
	rm -f $(PREFIX)/bin/rsync
	rm -f $(PREFIX)/share/man/man1/openrsync.1
	rm -f $(PREFIX)/share/man/man5/rsync.5

clean:
	rm -f $(ALLOBJS) openrsync $(AFLS)

$(ALLOBJS) $(AFLS): extern.h
