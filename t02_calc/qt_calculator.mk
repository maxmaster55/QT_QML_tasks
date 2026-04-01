QT_CALCULATOR_VERSION = 1.0
QT_CALCULATOR_SITE = $(TOPDIR)/package/qt_calculator
QT_CALCULATOR_SITE_METHOD = local
QT_CALCULATOR_DEPENDENCIES = qt6base qt6declarative host-cmake
QT_CALCULATOR_CONF_OPTS = \
    -DCMAKE_BUILD_TYPE=Release

$(eval $(cmake-package))