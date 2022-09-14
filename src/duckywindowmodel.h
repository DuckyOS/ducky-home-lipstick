#ifndef DUCKYWINDOWMODEL_H
#define DUCKYWINDOWMODEL_H

#include <windowmodel.h>
#include <lipstickcompositorwindow.h>
#include <QDebug>

class LipstickCompositorWindow;
class QWaylandSurfaceItem;

class Q_DECL_EXPORT DuckyWindowModel : public WindowModel 
{
    Q_OBJECT
public:
    explicit DuckyWindowModel();
    bool approveWindow(LipstickCompositorWindow *window);
    Q_INVOKABLE int getWindowIdForTitle(QString title);
    Q_INVOKABLE void removeWindowForTitle(QString title);
private:
    QHash<QString, int> m_titles;
};

#endif