THEOS_DEVICE_IP = 192.168.1.17
GO_EASY_ON_ME = 1
include theos/makefiles/common.mk

BUNDLE_NAME = Example1
Example1_FILES = Example1.mm
Example1_INSTALL_PATH = /Library/liblockscreen/Lockscreens
Example1_FRAMEWORKS = UIKit QuartzCore Foundation
Example1_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/liblockscreen/Lockscreens$(ECHO_END)
