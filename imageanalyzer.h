#ifndef IMAGEANALYZER_H
#define IMAGEANALYZER_H

#include <QObject>
#include <QImage>
#include <QDebug>
#include <QRgb>
#include <QVector>
#include <QList>

class ImageAnalyzer : public QObject{
    Q_OBJECT

public:
    explicit ImageAnalyzer (QObject* parent = 0) : QObject(parent)
    {
        image = new QImage();
    }

    Q_INVOKABLE void appendPixelsRGB(const int &a) {
        m_pixelsRGB.append(a);
        //emit pixelsRGBChanged();
    }

    Q_INVOKABLE QList<int> getPixelsRGB() const {
        return m_pixelsRGB;
    }

    Q_INVOKABLE int getPixelsRGB(int index) const {
        return m_pixelsRGB.at(index);
    }

    Q_INVOKABLE int getM_Colors(int index) const {
        return m_Colors.at(index);
    }

    Q_INVOKABLE QColor getDominantColor() const {

        int tmp = 0;
        int tmpIndex = 0;

        for(int i = 0; i < m_Colors.size() ; i++)
        {
            if(m_Colors.at(i) >= tmp)
            {
                tmpIndex = i;
                tmp = m_Colors.at(i);
            }
        }

        return QColor::fromHsl(tmpIndex,(m_Saturation.at(tmpIndex)/tmp) ,(m_Luminance.at(tmpIndex)/tmp));
    }

    Q_INVOKABLE void loadImage(QString fileName)
    {
        if(image->load(fileName))
        {
            m_pixelsRGB.clear();
            m_Colors.clear();
            m_Saturation.clear();
            m_Luminance.clear();

            for(int j = 0 ; j < image->height() ; j+=10)
            {
                for(int i = 0 ; i < image->width() ; i+=10)
                {
                    appendPixelsRGB(image->pixelColor(i,j).red());
                    appendPixelsRGB(image->pixelColor(i,j).green());
                    appendPixelsRGB(image->pixelColor(i,j).blue());
                }
            }

            emit pixelsRGBChanged();

            for(int i = 0 ; i<360 ; i++)
            {
                m_Colors.append(0);
                m_Luminance.append(0);
                m_Saturation.append(0);
            }

            for(int i = 0 ; i < m_pixelsRGB.size() ; i+=3)
            {


                QColor tmpColor = QColor(m_pixelsRGB.at(i),m_pixelsRGB.at(i+1),m_pixelsRGB.at(i+2));

                int t = tmpColor.hslHue();
                int s = tmpColor.hslSaturation();
                int l = tmpColor.lightness();

                if(t >= 0 && t < 360)
                {
                    m_Colors.replace(t , m_Colors.at(t) + 1);
                    m_Luminance.replace(t , m_Luminance.at(t) + l);
                    m_Saturation.replace(t , m_Saturation.at(t) + s);
                }

            }


            emit colorsAnalyzed();
        }

    }

signals:
    void pixelsRGBChanged();
    void colorsAnalyzed();

private :
    QList<int> m_pixelsRGB;
    QImage *image;
    bool imageLoaded = false;

    QList<int> m_Colors;
    QList<int> m_Saturation;
    QList<int> m_Luminance;

};





#endif // IMAGEANALYZER_H
