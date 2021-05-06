PACKAGE_VERSION=$(THEOS_PACKAGE_BASE_VERSION)

TARGET = iphone:clang:13.0:13.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ColorCodedLogs
ColorCodedLogs_FILES = Tweak.xm
ColorCodedLogs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 MobilePhone"
