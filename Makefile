FINALPACKAGE = 1
TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = MobileSMS

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = GroupMessageRenamer

GroupMessageRenamer_FILES = Tweak.x
GroupMessageRenamer_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk