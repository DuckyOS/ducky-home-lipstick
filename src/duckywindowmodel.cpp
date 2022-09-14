#include "duckywindowmodel.h"

DuckyWindowModel::DuckyWindowModel(): WindowModel() {}

int DuckyWindowModel::getWindowIdForTitle(QString title) {
    return m_titles.value(title, 0);
}

bool DuckyWindowModel::approveWindow(LipstickCompositorWindow *window) {
    bool accepted = window->isInProcess() == false
        && window->category() != QLatin1String("overlay")
        && window->category() != QLatin1String("cover")
        && window->title() != QLatin1String("maliit-server");
    
    if (accepted) {
        m_titles.insert(window->title(), window->windowId());
    }
    
    return accepted;
}

void DuckyWindowModel::removeWindowForTitle(QString title) {
    m_titles.remove(title);
}