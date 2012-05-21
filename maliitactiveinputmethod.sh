#!/bin/sh

#force the active im to be used
gconftool-2 --set "/maliit/onscreen/enabled" --type list --list-type=string [nemo-keyboard.qml,en_us]
gconftool-2 --set "/maliit/onscreen/active" --type list --list-type=string [nemo-keyboard.qml,en_us]

#make sure org.kde.plasma.core can be imported
export QML_IMPORT_PATH=/usr/lib/kde4/imports/

#enable maliit plugin
export QT_IM_MODULE=Maliit

