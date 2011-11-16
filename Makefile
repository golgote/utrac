#####################################################################
#       Makefile for Linux!
# 
#   Wed Jun 16 18:03:34 2004
#   Copyright  2004  Alliance MCA
#   Written by : Antoine Calando (antoine@alliancemca.net)
#####################################################################
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Library General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

CC = gcc

#release :
CFLAGS = -Wall -O2 -DDEBUG
# Linux : CFLAGS = -Wall -O2 -DDEBUG -fPIC

# debug
#CFLAGS = -Wall -g -DDEBUG

LIBS = -lm

PREFIX_PATH = /usr/local
LIB_PATH = ${PREFIX_PATH}/lib
INC_PATH = ${PREFIX_PATH}/include
BIN_PATH = ${PREFIX_PATH}/bin
MAN_PATH = ${PREFIX_PATH}/man/man1
SHARE_PATH = ${PREFIX_PATH}/share/utrac
CHARMAPS_FILE = charsets.dat

####

all: lib utrac

clean:
	rm -f  *.o *.a testimport *.bb *.da *.bbg core utrac
	
force:	clean all

#### INSTALL / UNINSTALL ######	
install: utrac
	strip ./utrac
	mkdir -p ${BIN_PATH}
	cp ./utrac ${BIN_PATH}
	mkdir -p ${SHARE_PATH}
	cp -f ${CHARMAPS_FILE} ${SHARE_PATH}
	cp -f utrac.1 ${MAN_PATH}

install-lib: lib
	mkdir -p ${LIB_PATH}
	cp libutrac.a ${LIB_PATH}
	mkdir -p ${LIB_PATH}
	cp libutrac.a ${LIB_PATH}
	
uninstall:
	rm -f ${BIN_PATH}/utrac
	rm -f ${LIB_PATH}/libutrac.a
	rm -f ${SHARE_PATH}/${CHARMAPS_FILE}
	rmdir ${SHARE_PATH}

###### OBJECT FILES #########
utrac_cmd.o: utrac_cmd.c utrac.h ut_charset.h ut_error.h ut_text.h debug.h
	$(CC) -c $(CFLAGS) $< -o $@

ut_loading.o: ut_loading.c utrac.h ut_error.h ut_text.h debug.h
	$(CC) -c $(CFLAGS) $< -o $@

ut_recognition1.o: ut_recognition1.c utrac.h ut_charset.h ut_error.h ut_text.h debug.h
	$(CC) -c $(CFLAGS) $< -o $@

ut_recognition2.o: ut_recognition2.c utrac.h ut_charset.h ut_error.h ut_text.h debug.h
	$(CC) -c $(CFLAGS) $< -o $@

ut_conversion.o: ut_conversion.c utrac.h ut_charset.h ut_error.h ut_text.h debug.h
	$(CC) -c $(CFLAGS) $< -o $@

#option -Wno-multichar has no effect! (gcc 3.3.4) so we use -w...
ut_charset.o: ut_charset.c utrac.h ut_charset.h ut_error.h debug.h
	$(CC) -w -Wno-multichar -c $(CFLAGS) -DUT_CHARMAPS_FILENAME='"${SHARE_PATH}/${CHARMAPS_FILE}"' $< -o $@

ut_utils.o: ut_utils.c ut_error.h utrac.h debug.h
	$(CC) -c $(CFLAGS) $< -o $@
	
ut_messages.o: ut_messages.c ut_error.h debug.h
	$(CC) -c $(CFLAGS) $< -o $@
	
ut_messages.c: ut_messages_en.c
	ln -sf ut_messages_en.c ut_messages.c

utrac.o: utrac.c utrac.h ut_error.h ut_text.h debug.h
	$(CC) -c $(CFLAGS) $< -o $@

###### COMMAND #####

utrac: utrac_cmd.o libutrac.a
	$(CC) $^ $(LIBS) -o $@


##### LIB #######
lib: libutrac.a

libutrac.a: utrac.o ut_charset.o ut_utils.o ut_loading.o ut_recognition1.o ut_recognition2.o \
	ut_conversion.o ut_messages.o
	ar rus libutrac.a $?
