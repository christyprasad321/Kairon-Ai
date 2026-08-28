import QtQuick
import QtQuick.Window

Window {
    id: win
    visible: true
    width: 1600
    height: 1000
    minimumWidth: 1200
    minimumHeight: 720
    color: "#020713"
    title: "KAIRON"

    property real sx: width / 1600
    property real sy: height / 1000
    property real sf: Math.min(sx, sy)

    Item {
        anchors.fill: parent

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0; color: "#01030b" }
                GradientStop { position: .42; color: "#041329" }
                GradientStop { position: 1; color: "#01030a" }
            }
        }

        // Subtle atmospheric illumination
        Rectangle {
            x: 80 * sx
            y: -130 * sy
            width: 1360 * sf
            height: 1360 * sf
            radius: width / 2
            opacity: .18
            gradient: Gradient {
                GradientStop { position: 0; color: "#063f72" }
                GradientStop { position: .55; color: "#042247" }
                GradientStop { position: 1; color: "#00000000" }
            }
        }

        // Fine stars
        Repeater {
            model: 230
            delegate: Rectangle {
                property real ang: (index * 2.399963)
                property real rad: (140 + ((index * 67) % 650)) * sf
                width: (index % 3 === 0 ? 2 : 1) * sf
                height: width
                radius: width / 2
                color: "#7bdcff"
                opacity: .12 + (index % 8) * .035
                x: 760 * sx + Math.cos(ang) * rad - width/2
                y: 475 * sy + Math.sin(ang) * rad * .68 - height/2

                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    PauseAnimation { duration: 250 + (index % 19) * 80 }
                    NumberAnimation { to: .72; duration: 450 + (index % 5) * 100 }
                    NumberAnimation { to: .12; duration: 900 + (index % 7) * 120 }
                }
            }
        }

        // Large orbital rings
        Item {
            anchors.fill: parent

            Repeater {
                model: 15
                delegate: Rectangle {
                    property real rr: (240 + index * 43) * sf
                    width: rr * 2
                    height: rr * 2
                    x: 760 * sx - width/2
                    y: 475 * sy - height/2
                    radius: width/2
                    color: "transparent"
                    border.width: index % 5 === 0 ? Math.max(2, 2*sf) : Math.max(1, sf)
                    border.color: "#2e8fc9"
                    opacity: .08 + (index % 4) * .025

                    RotationAnimation on rotation {
                        from: index % 2 ? 360 : 0
                        to: index % 2 ? 0 : 360
                        duration: 22000 + index * 1800
                        loops: Animation.Infinite
                    }
                }
            }

            // Broken arc markers
            Repeater {
                model: 38
                delegate: Rectangle {
                    property real theta: index * 9.47
                    property real rr: (360 + (index % 3) * 55) * sf
                    width: (18 + index % 4 * 8) * sf
                    height: Math.max(1, 2*sf)
                    radius: height/2
                    color: "#61d8ff"
                    opacity: .17 + (index % 5)*.035
                    x: 760*sx + Math.cos(theta*Math.PI/180)*rr - width/2
                    y: 475*sy + Math.sin(theta*Math.PI/180)*rr*.70 - height/2
                    rotation: theta + 90
                }
            }
        }

        // Central Core composition
        Item {
            id: core
            property real baseSize: 505 * sf
            width: baseSize
            height: baseSize
            x: 760*sx - width/2
            y: 455*sy - height/2

            // Bloom layers
            Repeater {
                model: 5
                delegate: Rectangle {
                    property real f: 1.02 + index*.065
                    anchors.centerIn: parent
                    width: parent.width*f
                    height: width*.86
                    radius: width/2
                    color: "#18bfff"
                    opacity: (.028 + index*.012) *
                             (kaironState.state === "THINKING" ? 1.8 :
                              kaironState.state === "LISTENING" ? 1.35 :
                              kaironState.state === "SPEAKING" ? 1.55 : 1.0)

                    SequentialAnimation on scale {
                        loops: Animation.Infinite
                        NumberAnimation { to: 1.06; duration: 1000; easing.type: Easing.InOutSine }
                        NumberAnimation { to: .97; duration: 1000; easing.type: Easing.InOutSine }
                    }
                }
            }

            // Rotating energy shell
            Image {
                id: shell
                anchors.centerIn: parent
                width: parent.width * .99
                height: width
                source: "../assets/neural_core.svg"
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true
                opacity: .20

                RotationAnimation on rotation {
                    from: 0
                    to: 360
                    duration: 42000
                    loops: Animation.Infinite
                }
            }

            // Main neural core
            Image {
                id: neural
                anchors.centerIn: parent
                width: parent.width * .86
                height: width
                source: "../assets/neural_core.svg"
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true

                opacity: kaironState.state === "ERROR" ? .72 : .94

                SequentialAnimation on scale {
                    loops: Animation.Infinite

                    NumberAnimation {
                        to: kaironState.state === "THINKING" ? 1.035 :
                            kaironState.state === "LISTENING" ? 1.022 :
                            kaironState.state === "SPEAKING" ? 1.030 : 1.012
                        duration: kaironState.state === "THINKING" ? 520 : 1150
                        easing.type: Easing.InOutSine
                    }

                    NumberAnimation {
                        to: .992
                        duration: kaironState.state === "THINKING" ? 520 : 1150
                        easing.type: Easing.InOutSine
                    }
                }

                RotationAnimation on rotation {
                    from: -2
                    to: 2
                    duration: 7000
                    loops: Animation.Infinite
                    easing.type: Easing.InOutSine
                }
            }

            // Moving neural light particles
            Repeater {
                model: 90
                delegate: Rectangle {
                    property real t: index / 90
                    property real a: index * 2.618
                    property real rr: (80 + (index % 15)*12) * sf
                    width: (index % 4 === 0 ? 4 : 2) * sf
                    height: width
                    radius: width/2
                    color: "#a1efff"
                    opacity: .20 + (index % 6)*.07

                    x: parent.width/2 + Math.cos(a + t*6.283) * rr - width/2
                    y: parent.height/2 + Math.sin(a + t*6.283) * rr*.72 - height/2

                    SequentialAnimation on opacity {
                        loops: Animation.Infinite
                        PauseAnimation { duration: index * 17 }
                        NumberAnimation { to: .95; duration: 300 + index%5*90 }
                        NumberAnimation { to: .15; duration: 700 + index%7*90 }
                    }
                }
            }

            // Central nucleus
            Rectangle {
                anchors.centerIn: parent
                width: 105*sf
                height: width
                radius: width/2
                color: "#72e7ff"
                opacity: kaironState.state === "THINKING" ? .22 :
                         kaironState.state === "SPEAKING" ? .18 : .12

                SequentialAnimation on scale {
                    loops: Animation.Infinite
                    NumberAnimation { to: 1.18; duration: 620; easing.type: Easing.InOutSine }
                    NumberAnimation { to: .84; duration: 620; easing.type: Easing.InOutSine }
                }
            }
        }

        // Reflected Core — soft, elongated and distorted visually
        Item {
            x: 515*sx
            y: 705*sy
            width: 490*sx
            height: 205*sy
            opacity: .22

            Image {
                anchors.centerIn: parent
                width: parent.width
                height: parent.height*2.0
                source: "../assets/neural_core.svg"
                fillMode: Image.PreserveAspectFit
                opacity: .65
                scale: 1.05
                transform: Scale {
                    origin.x: parent.width/2
                    origin.y: parent.height/2
                    yScale: -1
                }
            }

            Rectangle {
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop { position: 0; color: "#061b33" }
                    GradientStop { position: .55; color: "#061b33" }
                    GradientStop { position: 1; color: "#00000000" }
                }
            }

            SequentialAnimation on opacity {
                loops: Animation.Infinite
                NumberAnimation { to: .28; duration: 1200 }
                NumberAnimation { to: .14; duration: 1200 }
            }
        }

        // Right-side information
        Item {
            x: 1115*sx
            y: 62*sy
            width: 410*sx
            height: 850*sy

            Text {
                x: 130*sx
                text: "☁  10:24 AM"
                color: "#f4f8ff"
                font.pixelSize: 29*sf
                font.bold: true
            }

            Text {
                x: 130*sx
                y: 42*sy
                text: "PARTLY CLOUDY"
                color: "#d6e3f2"
                font.pixelSize: 13*sf
                font.bold: true
            }

            Text {
                x: 130*sx
                y: 72*sy
                text: "⌖  KOCHI, INDIA"
                color: "#a8b8c9"
                font.pixelSize: 11*sf
                font.bold: true
            }

            Text {
                y: 510*sy
                text: "▮▮▮  LIVE TRANSCRIPT"
                color: "#e2edfa"
                font.pixelSize: 18*sf
                font.bold: true
            }

            Rectangle {
                y: 542*sy
                width: 390*sx
                height: 1
                color: "#5ba1c9"
                opacity: .22
            }

            Column {
                y: 565*sy
                width: 390*sx
                spacing: 19*sy

                Text {
                    text: "10:24.01   YOU       Good morning Kairon"
                    color: "#edf4fc"
                    font.pixelSize: 13*sf
                }

                Text {
                    text: "10:24.03   KAIRON    Good morning, Christy!\\n                       How can I assist you today?"
                    color: "#e5edf8"
                    font.pixelSize: 13*sf
                    lineHeight: 1.25
                }

                Text {
                    text: "10:24.10   YOU       Show me today's system summary"
                    color: "#edf4fc"
                    font.pixelSize: 13*sf
                }

                Text {
                    text: "10:24.12   KAIRON    Sure, fetching the latest system\\n                       summary for you."
                    color: "#e5edf8"
                    font.pixelSize: 13*sf
                    lineHeight: 1.25
                }
            }
        }

        // Temporary development state strip
        Rectangle {
            visible: true
            x: 25*sx
            y: 920*sy
            width: 610*sx
            height: 45*sy
            radius: 7
            color: "#061426"
            border.color: "#1c567b"
            opacity: .9

            Row {
                anchors.centerIn: parent
                spacing: 7*sx

                Repeater {
                    model: ["IDLE","LISTENING","THINKING","SPEAKING","EXECUTING","SUCCESS","WARNING","ERROR"]

                    delegate: Rectangle {
                        width: 68*sf
                        height: 28*sf
                        radius: 4
                        color: kaironState.state === modelData ? "#155a83" : "#0a1e31"
                        border.color: "#2b7399"

                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            color: "#d8efff"
                            font.pixelSize: 8*sf
                            font.bold: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: kaironState.setState(modelData)
                        }
                    }
                }
            }
        }
    }
}
