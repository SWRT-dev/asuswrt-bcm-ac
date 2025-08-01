
# Copyright (C) 2018-2023 Ruilin Peng (Nick) <pymumu@gmail.com>.
#
# smartdns is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# smartdns is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
include $(TOP)/common.mak
BIN=smartdns 
OBJS_LIB=lib/rbtree.o lib/art.o lib/bitops.o lib/radix.o lib/timer_wheel.o
OBJS_MAIN=smartdns.o fast_ping.o dns_client.o dns_server.o dns.o util.o tlog.o dns_conf.o dns_cache.o http_parse.o proxy.o timer.o lib/conf.o lib/nftset.o
OBJS=$(OBJS_MAIN) $(OBJS_LIB)

ifeq ($(RTCONFIG_HND_ROUTER),y)
CFLAGS += -O1 -Wall -Wstrict-prototypes -fno-omit-frame-pointer -Wstrict-aliasing -funwind-tables -Wmissing-prototypes -Wshadow -Wextra -Wno-unused-parameter -Wno-implicit-fallthrough
else
CFLAGS += -O2 -Wall -Wstrict-prototypes -fno-omit-frame-pointer -Wstrict-aliasing -funwind-tables -Wmissing-prototypes -Wshadow -Wextra -Wno-unused-parameter -Wno-implicit-fallthrough
endif
CFLAGS +=-I./include -I$(TOP)/openssl/include
CFLAGS += -DBASE_FILE_NAME='"$(notdir $<)"'
CFLAGS += -I$(STAGEDIR)/usr/include
CFLAGS += -DSMARTDNS_VERION='"$(SWRT_VER_MINOR)"'

CXXFLAGS=-O2 -g -Wall -std=c++11 
CXXFLAGS +=-Iinclude

LDFLAGS += -L$(STAGEDIR)/usr/lib -lssl -lcrypto -lpthread -ldl
ifeq ($(RTCONFIG_OPENSSL3),y)
LDFLAGS += -latomic
endif

.PHONY: all clean

ifeq ($(BUILD_NAME), $(filter $(BUILD_NAME), RT-AC88U RT-AC3100 RT-AC3200 RT-AC68U RT-AC5300))
#toolchain is too old
all:
	cp ./smartdns_arm ./smartdns

else

all: $(BIN)

$(BIN) : $(OBJS)
	$(CC) $(OBJS) -o $@ $(LDFLAGS)

clang-tidy:
	clang-tidy -p=. $(OBJS_MAIN:.o=.c) -- $(CFLAGS)

endif

clean:
	$(RM) $(OBJS) $(BIN)
