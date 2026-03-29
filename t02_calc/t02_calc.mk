T02_CALC_VERSION = 1.0
T02_CALC_SITE = $(TOPDIR)/package/t02_calc
T02_CALC_SITE_METHOD = local
T02_CALC_DEPENDENCIES = qt6base qt6declarative host-cmake

T02_CALC_CONF_OPTS = \
    -DCMAKE_BUILD_TYPE=Release

$(eval $(cmake-package))