TARGET := iphone:clang:16.5:14.0
INSTALL_TARGET_PROCESSES = SpringBoard
ARCHS = arm64 arm64e

THEOS_DEVICE_IP = 192.168.102.61

GO_EASY_ON_ME = 1

THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HomeBar

HomeBar_FILES = Tweak.x
HomeBar_CFLAGS = -fobjc-arc
HomeBar_FRAMEWORKS = UIKit MediaRemote

include $(THEOS_MAKE_PATH)/tweak.mk
