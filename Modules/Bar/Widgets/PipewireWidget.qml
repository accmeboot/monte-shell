import QtQuick
import QtQuick.Layouts

import qs.Managers
import qs.Config
import qs.Components

MContainer {
    paddingVertical: MSpacing.xs
    paddingHorizontal: MSpacing.xs

    color: MColors.base01

    RowLayout {
        spacing: MSpacing.xs
        MIcon {
            size: MIcons.l
            fromSource: {
                if (PipewireManager.isMuted)
                    return "volume-muted.svg";

                if (PipewireManager.volume <= 30)
                    return "volume-low.svg";

                if (PipewireManager.volume <= 60)
                    return "volume-half.svg";

                return "volume-full.svg";
            }
            color: MColors.base05
            overlay: true
        }
    }
}
