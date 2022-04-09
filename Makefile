TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = MobileSMS

FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MessageRename

MessageRename_FILES = Tweak.x
MessageRenaem_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
