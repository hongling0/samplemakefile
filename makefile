# author wanghong
# date:2013-05-02
# C&&C++
.PHONY:all list clean
OBJDIR:=./.obj/
# NEXTDIRS:=$(shell ls -p|grep /|tr -d /)
NEXTDIRS:=$(shell find . -type d)
DIRS:=. $(NEXTDIRS)
TARGET:=test
IGNDIRS:=bin 
IGNFILE:= 
LIBS:=-lpthread
PREPROCE=-DDEBUG
LIBPATH:=-L.
INCLUDE:=-I.
CFLAGS=-g -m32
CXXFLAGS=-g -m32
CPPFLAGS=$(INCLUDE) $(PREPROCE)
LDFLAGS=$(LIB) $(LIBPATH)
ARFLAGS=-rcs
OUTPUT_OPTION=
CC=gcc
CXX=g++
AR=ar
RM=rm -rf
MKDIR=mkdir -p
CEXTS=.C .c
CCEXTS=.cpp .cc .cxx
SRCEXTS=$(CEXTS) $(CCEXTS)
SRCDIRS=$(filter-out $(IGNDIRS),$(DIRS))
COMPILE.cc=$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH)
COMPILE.c=$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH)
LINK.cc=$(CXX) $(OBJS) $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) -o $(TARGET)
LINK.c=$(CC) $(OBJS) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) -o $(TARGET)
LINK.ar=$(AR) $(ARFLAGS) $(TARGET) $(OBJS)
PREPROC.cc=$(CXX) $(CXXFLAGS) $(CPPFLAG)
PREPROC.c=$(CC) $(CFLAGS) $(CPPFLAG)
SOURCES:=$(filter-out $(IGNFILE),$(foreach d,$(SRCDIRS),$(wildcard $(addprefix $(d)/*,$(SRCEXTS)))))
OBJS:=$(foreach x,$(SRCEXTS), $(addprefix $(OBJDIR),$(patsubst %$(x),%.o,$(filter %$(x),$(SOURCES)))))
DEPS:=$(patsubst %.o,%.d,$(OBJS))
ifeq ($(filter-out $(addprefix %,$(CCEXTS)),$(SOURCES)),)
LINK=$(LINK.c)
else
LINK=$(LINK.cc)
endif
ifeq ($(suffix $(TARGET)),.a)
LINK=$(LINK.ar)	
endif
all:link
	@echo finish-------------------------------------------
link:$(TARGET)
	@$(MKDIR) $(@D)
	$(LINK) $(OUTPUT_OPTION)
$(TARGET):$(OBJS)
list:
	@echo TARGET:$(TARGET)
	@echo dir  list----------------------------------------
	@for d in $(SRCDIRS); do echo dir:$$d; done 
	@echo file list --------------------------------------- 
	@for f in $(SOURCES); do echo file:$$f; done 
	@echo list end ---------------------------------------- 

ifneq ($(MAKECMDGOALS),clean)
$(OBJDIR)%.o:%.c $(OBJDIR)%.d
	$(COMPILE.c) $< -o $@
$(OBJDIR)%.o:%.C $(OBJDIR)%.d
	$(COMPILE.c) $< -o $@
$(OBJDIR)%.o:%.cpp $(OBJDIR)%.d
	$(COMPILE.cc) $< -o $@
$(OBJDIR)%.o:%.cxx $(OBJDIR)%.d
	$(COMPILE.cc) $< -o $@
$(OBJDIR)%.o:%.cc $(OBJDIR)%.d
	$(COMPILE.cc) $< -o $@

$(OBJDIR)%.d:%.c
	$(PREPROC.c) -MM $< -MT$(@:.d=.o) -MF$@
$(OBJDIR)%.d:%.C
	$(PREPROC.c) -MM $< -MT$(@:.d=.o) -MF$@
$(OBJDIR)%.d:%.cpp
	$(PREPROC.cc) -MM $< -MT$(@:.d=.o) -MF$@
$(OBJDIR)%.d:%.cxx
	$(PREPROC.cc) -MM $< -MT$(@:.d=.o) -MF$@
$(OBJDIR)%.d:%.cc
	$(PREPROC.cc) -MM $< -MT$(@:.d=.o) -MF$@
$(foreach d,$(SRCDIRS),$(shell $(MKDIR) $(OBJDIR)$(d)))
-include $(DEPS)
endif
clean:
	$(RM) $(OBJS)
	$(RM) $(DEPS)
	$(RM) $(OBJDIR)
	$(RM) $(TARGET)
