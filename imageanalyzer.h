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

        return QColor::fromHsl(tmpIndex,100,50);
    }

    Q_INVOKABLE void loadImage(QString fileName)
    {
        if(image->load(fileName))
        {
            m_pixelsRGB.clear();
            m_Colors.clear();

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
                m_Colors.append(0);

            for(int i = 0 ; i < m_pixelsRGB.size() ; i+=3)
            {
                QColor tmpColor = QColor(m_pixelsRGB.at(i),m_pixelsRGB.at(i+1),m_pixelsRGB.at(i+2));
                m_Colors.replace(tmpColor.hslHue() , m_Colors.at(tmpColor.hslHue()) + 1);


            }

            qDebug() << m_Colors.size();

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

};





#endif // IMAGEANALYZER_H
