QT_LED_CONTROLLER_VERSION = 1.0
QT_LED_CONTROLLER_SITE = $(TOPDIR)/package/qt_led_controller
QT_LED_CONTROLLER_SITE_METHOD = local
QT_LED_CONTROLLER_DEPENDENCIES = qt6base qt6declarative host-cmake
QT_LED_CONTROLLER_CONF_OPTS = \
    -DCMAKE_BUILD_TYPE=Release

$(eval $(cmake-package))
