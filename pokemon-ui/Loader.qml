import QtQuick 2.0

Item {
    id: image_frame
    property string source: ""
    property Item loader: image

    signal ready(string icon)
    width: 720
    height: 576

    Image {
        id: image
        anchors.centerIn: parent
        source: image_frame.source
        smooth: true
        width: 116
        height: 116
        fillMode: Image.PreserveAspectCrop

        property bool rounded: true
        property bool adapt: true

        layer.enabled: rounded
        layer.effect: ShaderEffect {
            property real adjustX: image.adapt ? Math.max(width / height, 1) : 1
            property real adjustY: image.adapt ? Math.max(1 / (width / height), 1) : 1

            fragmentShader: "
            #ifdef GL_ES
                precision lowp float;
            #endif // GL_ES
            varying highp vec2 qt_TexCoord0;
            uniform highp float qt_Opacity;
            uniform lowp sampler2D source;
            uniform lowp float adjustX;
            uniform lowp float adjustY;

            void main(void) {
                lowp float x, y;
                x = (qt_TexCoord0.x - 0.5) * adjustX;
                y = (qt_TexCoord0.y - 0.5) * adjustY;
                float delta = adjustX != 1.0 ? fwidth(y) / 2.0 : fwidth(x) / 2.0;
                gl_FragColor = texture2D(source, qt_TexCoord0).rgba
                    * step(x * x + y * y, 0.25)
                    * smoothstep((x * x + y * y) , 0.25 + delta, 0.25)
                    * qt_Opacity;
            }"
        }
        states: State {
             name: "rotate"
             PropertyChanges { target: image; rotation: 360 }
             PropertyChanges {
                 target: image
                 width: 70
                 height: 70
             }
         }

        transitions: [
            Transition {
                to: "rotate"
                RotationAnimation {
                    loops: Animation.Infinite
                    from: 0
                    to: 360
                }
            }
        ]

         onStatusChanged: {
             if( image.status == Image.Ready)
                 ready( source);
         }
    }

}
