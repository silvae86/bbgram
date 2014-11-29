# Config.pri file version 2.0. Auto-generated by IDE. Any changes made by user will be lost!
BASEDIR = $$quote($$_PRO_FILE_PWD_)

device {
    CONFIG(debug, debug|release) {
        profile {
            INCLUDEPATH += $$quote($$BASEDIR/../tgl) \
                $$quote($$BASEDIR/../tgl/public)

            DEPENDPATH += $$quote($$BASEDIR/../tgl) \
                $$quote($$BASEDIR/../tgl/public)

            LIBS += -ltgl

            LIBS += $$quote(-L$$BASEDIR/../tgl/Device-Release)

            PRE_TARGETDEPS += $$quote($$BASEDIR/../tgl/Device-Release)

            CONFIG += \
                config_pri_assets \
                config_pri_source_group1
        } else {
            INCLUDEPATH += $$quote($$BASEDIR/../tgl) \
                $$quote($$BASEDIR/../tgl/public)

            DEPENDPATH += $$quote($$BASEDIR/../tgl) \
                $$quote($$BASEDIR/../tgl/public)

            LIBS += -ltgl

            LIBS += $$quote(-L$$BASEDIR/../tgl/Device-Debug)

            PRE_TARGETDEPS += $$quote($$BASEDIR/../tgl/Device-Debug)

            CONFIG += \
                config_pri_assets \
                config_pri_source_group1
        }

    }

    CONFIG(release, debug|release) {
        !profile {
            INCLUDEPATH += $$quote($$BASEDIR/../tgl) \
                $$quote($$BASEDIR/../tgl/public)

            DEPENDPATH += $$quote($$BASEDIR/../tgl) \
                $$quote($$BASEDIR/../tgl/public)

            LIBS += -ltgl

            LIBS += $$quote(-L$$BASEDIR/../tgl/Device-Release)

            PRE_TARGETDEPS += $$quote($$BASEDIR/../tgl/Device-Release)

            CONFIG += \
                config_pri_assets \
                config_pri_source_group1
        }
    }
}

simulator {
    CONFIG(debug, debug|release) {
        !profile {
            INCLUDEPATH += $$quote($$BASEDIR/../tgl) \
                $$quote($$BASEDIR/../tgl/public)

            DEPENDPATH += $$quote($$BASEDIR/../tgl) \
                $$quote($$BASEDIR/../tgl/public)

            LIBS += -ltgl

            LIBS += $$quote(-L$$BASEDIR/../tgl/Simulator-Debug)

            PRE_TARGETDEPS += $$quote($$BASEDIR/../tgl/Simulator-Debug)

            CONFIG += \
                config_pri_assets \
                config_pri_source_group1
        }
    }
}

config_pri_assets {
    OTHER_FILES += \
        $$quote($$BASEDIR/assets/dm_countries.xml) \
        $$quote($$BASEDIR/assets/dm_intro_page.xml) \
        $$quote($$BASEDIR/assets/images/bar_back.png) \
        $$quote($$BASEDIR/assets/images/bar_chats.png) \
        $$quote($$BASEDIR/assets/images/bar_menu.png) \
        $$quote($$BASEDIR/assets/images/bar_menu_settings.png) \
        $$quote($$BASEDIR/assets/images/bar_profile.png) \
        $$quote($$BASEDIR/assets/images/frame.9.png) \
        $$quote($$BASEDIR/assets/images/frame.amd) \
        $$quote($$BASEDIR/assets/images/header_confirm.png) \
        $$quote($$BASEDIR/assets/images/header_search.png) \
        $$quote($$BASEDIR/assets/images/intro/intro1.png) \
        $$quote($$BASEDIR/assets/images/intro/intro2.png) \
        $$quote($$BASEDIR/assets/images/intro/intro3.png) \
        $$quote($$BASEDIR/assets/images/intro/intro4.png) \
        $$quote($$BASEDIR/assets/images/intro/intro5.png) \
        $$quote($$BASEDIR/assets/images/intro/intro6.png) \
        $$quote($$BASEDIR/assets/images/intro/intro7.png) \
        $$quote($$BASEDIR/assets/images/menu_FAQ.png) \
        $$quote($$BASEDIR/assets/images/menu_bar_chat.png) \
        $$quote($$BASEDIR/assets/images/menu_bar_contact_plus.png) \
        $$quote($$BASEDIR/assets/images/menu_bar_edit.png) \
        $$quote($$BASEDIR/assets/images/menu_bin.png) \
        $$quote($$BASEDIR/assets/images/menu_broadcast.png) \
        $$quote($$BASEDIR/assets/images/menu_chat.png) \
        $$quote($$BASEDIR/assets/images/menu_contactblock.png) \
        $$quote($$BASEDIR/assets/images/menu_contactshare.png) \
        $$quote($$BASEDIR/assets/images/menu_group.png) \
        $$quote($$BASEDIR/assets/images/menu_plus.png) \
        $$quote($$BASEDIR/assets/images/menu_secretchat.png) \
        $$quote($$BASEDIR/assets/images/menu_sharedmedia.png) \
        $$quote($$BASEDIR/assets/images/placeholders/broadcast_placeholder_blue.png) \
        $$quote($$BASEDIR/assets/images/placeholders/broadcast_placeholder_cyan.png) \
        $$quote($$BASEDIR/assets/images/placeholders/broadcast_placeholder_green.png) \
        $$quote($$BASEDIR/assets/images/placeholders/broadcast_placeholder_orange.png) \
        $$quote($$BASEDIR/assets/images/placeholders/broadcast_placeholder_pink.png) \
        $$quote($$BASEDIR/assets/images/placeholders/broadcast_placeholder_purple.png) \
        $$quote($$BASEDIR/assets/images/placeholders/broadcast_placeholder_red.png) \
        $$quote($$BASEDIR/assets/images/placeholders/broadcast_placeholder_yellow.png) \
        $$quote($$BASEDIR/assets/images/placeholders/group_placeholder_blue.png) \
        $$quote($$BASEDIR/assets/images/placeholders/group_placeholder_cyan.png) \
        $$quote($$BASEDIR/assets/images/placeholders/group_placeholder_green.png) \
        $$quote($$BASEDIR/assets/images/placeholders/group_placeholder_orange.png) \
        $$quote($$BASEDIR/assets/images/placeholders/group_placeholder_pink.png) \
        $$quote($$BASEDIR/assets/images/placeholders/group_placeholder_purple.png) \
        $$quote($$BASEDIR/assets/images/placeholders/group_placeholder_red.png) \
        $$quote($$BASEDIR/assets/images/placeholders/group_placeholder_yellow.png) \
        $$quote($$BASEDIR/assets/images/placeholders/user_placeholder_blue.png) \
        $$quote($$BASEDIR/assets/images/placeholders/user_placeholder_cyan.png) \
        $$quote($$BASEDIR/assets/images/placeholders/user_placeholder_green.png) \
        $$quote($$BASEDIR/assets/images/placeholders/user_placeholder_orange.png) \
        $$quote($$BASEDIR/assets/images/placeholders/user_placeholder_pink.png) \
        $$quote($$BASEDIR/assets/images/placeholders/user_placeholder_purple.png) \
        $$quote($$BASEDIR/assets/images/placeholders/user_placeholder_red.png) \
        $$quote($$BASEDIR/assets/images/placeholders/user_placeholder_yellow.png) \
        $$quote($$BASEDIR/assets/images/setting_arrow.png) \
        $$quote($$BASEDIR/assets/server.pub) \
        $$quote($$BASEDIR/assets/ui/pages/Chats.qml) \
        $$quote($$BASEDIR/assets/ui/pages/ContactInfo.qml) \
        $$quote($$BASEDIR/assets/ui/pages/Contacts.qml) \
        $$quote($$BASEDIR/assets/ui/pages/CountrySelect.qml) \
        $$quote($$BASEDIR/assets/ui/pages/Intro.qml) \
        $$quote($$BASEDIR/assets/ui/pages/Login.qml) \
        $$quote($$BASEDIR/assets/ui/pages/Main.qml) \
        $$quote($$BASEDIR/assets/ui/pages/Settings.qml) \
        $$quote($$BASEDIR/assets/ui/pages/YourCode.qml) \
        $$quote($$BASEDIR/assets/ui/pages/chats/ChatItem.qml) \
        $$quote($$BASEDIR/assets/ui/pages/contacts/ContactItem.qml) \
        $$quote($$BASEDIR/assets/ui/pages/intro/CarouselView.qml) \
        $$quote($$BASEDIR/assets/ui/pages/intro/Indicator.qml) \
        $$quote($$BASEDIR/assets/ui/pages/settings/ChatBackground.qml) \
        $$quote($$BASEDIR/assets/ui/pages/settings/ChatSettings.qml) \
        $$quote($$BASEDIR/assets/ui/pages/settings/NotificationsAndSounds.qml) \
        $$quote($$BASEDIR/assets/ui/pages/settings/PrivacyAndSecurity.qml) \
        $$quote($$BASEDIR/assets/ui/pages/settings/SettingsDropDown.qml) \
        $$quote($$BASEDIR/assets/ui/pages/settings/SettingsHeader.qml) \
        $$quote($$BASEDIR/assets/ui/pages/settings/SettingsRow.qml) \
        $$quote($$BASEDIR/assets/ui/pages/settings/SettingsToggleButton.qml)
}

config_pri_source_group1 {
    SOURCES += \
        $$quote($$BASEDIR/src/ApplicationUI.cpp) \
        $$quote($$BASEDIR/src/Storage.cpp) \
        $$quote($$BASEDIR/src/Telegraph.cpp) \
        $$quote($$BASEDIR/src/main.cpp) \
        $$quote($$BASEDIR/src/model/Chat.cpp) \
        $$quote($$BASEDIR/src/model/Dialog.cpp) \
        $$quote($$BASEDIR/src/model/User.cpp) \
        $$quote($$BASEDIR/src/telegraph/net.cpp) \
        $$quote($$BASEDIR/src/telegraph/timers.cpp) \
        $$quote($$BASEDIR/src/ui/IntroScreen.cpp) \
        $$quote($$BASEDIR/src/ui/MainScreen.cpp) \
        $$quote($$BASEDIR/src/ui/PhoneNumberInput.cpp)

    HEADERS += \
        $$quote($$BASEDIR/src/ApplicationUI.h) \
        $$quote($$BASEDIR/src/Storage.h) \
        $$quote($$BASEDIR/src/Telegraph.h) \
        $$quote($$BASEDIR/src/model/Chat.h) \
        $$quote($$BASEDIR/src/model/Dialog.h) \
        $$quote($$BASEDIR/src/model/User.h) \
        $$quote($$BASEDIR/src/telegraph/net.h) \
        $$quote($$BASEDIR/src/telegraph/timers.h) \
        $$quote($$BASEDIR/src/ui/IntroScreen.h) \
        $$quote($$BASEDIR/src/ui/MainScreen.h) \
        $$quote($$BASEDIR/src/ui/PhoneNumberInput.h) \
        $$quote($$BASEDIR/src/ui/Screen.h)
}

CONFIG += precompile_header

PRECOMPILED_HEADER = $$quote($$BASEDIR/precompiled.h)

lupdate_inclusion {
    SOURCES += \
        $$quote($$BASEDIR/../src/*.c) \
        $$quote($$BASEDIR/../src/*.c++) \
        $$quote($$BASEDIR/../src/*.cc) \
        $$quote($$BASEDIR/../src/*.cpp) \
        $$quote($$BASEDIR/../src/*.cxx) \
        $$quote($$BASEDIR/../src/model/*.c) \
        $$quote($$BASEDIR/../src/model/*.c++) \
        $$quote($$BASEDIR/../src/model/*.cc) \
        $$quote($$BASEDIR/../src/model/*.cpp) \
        $$quote($$BASEDIR/../src/model/*.cxx) \
        $$quote($$BASEDIR/../src/telegraph/*.c) \
        $$quote($$BASEDIR/../src/telegraph/*.c++) \
        $$quote($$BASEDIR/../src/telegraph/*.cc) \
        $$quote($$BASEDIR/../src/telegraph/*.cpp) \
        $$quote($$BASEDIR/../src/telegraph/*.cxx) \
        $$quote($$BASEDIR/../src/ui/*.c) \
        $$quote($$BASEDIR/../src/ui/*.c++) \
        $$quote($$BASEDIR/../src/ui/*.cc) \
        $$quote($$BASEDIR/../src/ui/*.cpp) \
        $$quote($$BASEDIR/../src/ui/*.cxx) \
        $$quote($$BASEDIR/../assets/*.qml) \
        $$quote($$BASEDIR/../assets/*.js) \
        $$quote($$BASEDIR/../assets/*.qs) \
        $$quote($$BASEDIR/../assets/images/*.qml) \
        $$quote($$BASEDIR/../assets/images/*.js) \
        $$quote($$BASEDIR/../assets/images/*.qs) \
        $$quote($$BASEDIR/../assets/images/intro/*.qml) \
        $$quote($$BASEDIR/../assets/images/intro/*.js) \
        $$quote($$BASEDIR/../assets/images/intro/*.qs) \
        $$quote($$BASEDIR/../assets/images/placeholders/*.qml) \
        $$quote($$BASEDIR/../assets/images/placeholders/*.js) \
        $$quote($$BASEDIR/../assets/images/placeholders/*.qs) \
        $$quote($$BASEDIR/../assets/ui/*.qml) \
        $$quote($$BASEDIR/../assets/ui/*.js) \
        $$quote($$BASEDIR/../assets/ui/*.qs) \
        $$quote($$BASEDIR/../assets/ui/pages/*.qml) \
        $$quote($$BASEDIR/../assets/ui/pages/*.js) \
        $$quote($$BASEDIR/../assets/ui/pages/*.qs) \
        $$quote($$BASEDIR/../assets/ui/pages/chats/*.qml) \
        $$quote($$BASEDIR/../assets/ui/pages/chats/*.js) \
        $$quote($$BASEDIR/../assets/ui/pages/chats/*.qs) \
        $$quote($$BASEDIR/../assets/ui/pages/contacts/*.qml) \
        $$quote($$BASEDIR/../assets/ui/pages/contacts/*.js) \
        $$quote($$BASEDIR/../assets/ui/pages/contacts/*.qs) \
        $$quote($$BASEDIR/../assets/ui/pages/intro/*.qml) \
        $$quote($$BASEDIR/../assets/ui/pages/intro/*.js) \
        $$quote($$BASEDIR/../assets/ui/pages/intro/*.qs) \
        $$quote($$BASEDIR/../assets/ui/pages/settings/*.qml) \
        $$quote($$BASEDIR/../assets/ui/pages/settings/*.js) \
        $$quote($$BASEDIR/../assets/ui/pages/settings/*.qs)

    HEADERS += \
        $$quote($$BASEDIR/../src/*.h) \
        $$quote($$BASEDIR/../src/*.h++) \
        $$quote($$BASEDIR/../src/*.hh) \
        $$quote($$BASEDIR/../src/*.hpp) \
        $$quote($$BASEDIR/../src/*.hxx)
}

TRANSLATIONS = $$quote($${TARGET}.ts)
