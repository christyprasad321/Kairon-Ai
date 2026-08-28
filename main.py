import sys
from pathlib import Path

from PySide6.QtCore import QObject, Property, Signal, Slot
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine


BASE_DIR = Path(__file__).resolve().parent
QML_DIR = BASE_DIR / "qml"


class KaironState(QObject):
    stateChanged = Signal()

    def __init__(self):
        super().__init__()
        self._state = "IDLE"

    @Property(str, notify=stateChanged)
    def state(self):
        return self._state

    @Slot(str)
    def setState(self, value):
        value = value.upper()
        if value != self._state:
            self._state = value
            self.stateChanged.emit()


def main():
    app = QGuiApplication(sys.argv)

    state = KaironState()

    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("kaironState", state)

    main_qml = QML_DIR / "Main.qml"
    if not main_qml.exists():
        print(f"ERROR: Missing {main_qml}")
        return 1

    engine.load(str(main_qml))

    if not engine.rootObjects():
        print("ERROR: QML failed to load.")
        return 1

    return app.exec()


if __name__ == "__main__":
    sys.exit(main())
