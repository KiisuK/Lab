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

    Q_INVOKABLE QColor getAccentColor(QColor dominant) const {

        QColor accent =  dominant;

        int r = dominant.red();
        int g = dominant.green();
        int b = dominant.blue();

        double x = 0.0;
        double y = 0.0;
        double z = 0.0;

        if((r / whiteReferenceX) > Epsilon)
            x = std::pow((r / whiteReferenceX), 1.0 / 3.0);
        else
            x = (Kappa * (r / whiteReferenceX) + 16) / 116;

        if((g / whiteReferenceY) > Epsilon)
            y = std::pow((g / whiteReferenceY), 1.0 / 3.0);
        else
            y = (Kappa * (g / whiteReferenceY) + 16) / 116;

        if((b / whiteReferenceZ) > Epsilon)
            z = std::pow((b / whiteReferenceZ), 1.0 / 3.0);
        else
            z = (Kappa * (b / whiteReferenceZ) + 16) / 116;

        double dominant_L = std::max(0.0, 116 * y - 16);
        double dominant_A = 500 * (x - y);
        double dominant_B = 200 * (y - z);

        double highestDeltaE = 0;

        for(int i = 0; i < m_Colors.size() ; i++)
        {
            if(m_Colors.at(i) > 10)
            {
                QColor currentColor = QColor::fromHsl(i,dominant.hslSaturation() ,dominant.lightness());
                int currentR = currentColor.red();
                int currentG = currentColor.green();
                int currentB = currentColor.blue();

                double currentX = 0.0;
                double currentY = 0.0;
                double currentZ = 0.0;

                if((currentR / whiteReferenceX) > Epsilon)
                    currentX = std::pow((currentR / whiteReferenceX), 1.0 / 3.0);
                else
                    currentX = (Kappa * (currentR / whiteReferenceX) + 16) / 116;

                if((currentG / whiteReferenceY) > Epsilon)
                    currentY = std::pow((currentG / whiteReferenceY), 1.0 / 3.0);
                else
                    currentY = (Kappa * (currentG / whiteReferenceY) + 16) / 116;

                if((currentB / whiteReferenceZ) > Epsilon)
                    currentZ = std::pow((currentB / whiteReferenceZ), 1.0 / 3.0);
                else
                    currentZ = (Kappa * (currentB / whiteReferenceZ) + 16) / 116;

                double current_L = std::max(0.0, 116 * currentY - 16);
                double current_A = 500 * (currentX - currentY);
                double current_B = 200 * (currentY - currentZ);

                double deltaE = std::sqrt(std::pow(current_L - dominant_L,2.0) + std::pow(current_A - dominant_A,2.0) + std::pow(current_B - dominant_B,2.0));

                if(deltaE > highestDeltaE)
                {
                    highestDeltaE = deltaE;
                    accent = QColor::fromHsl(i,m_Saturation.at(i)/m_Colors.at(i) ,m_Luminance.at(i)/m_Colors.at(i));
                }
            }
        }
        return accent;
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
                int l = tmpColor.lightness();
                int s = tmpColor.hslSaturation();

                if(t >= 0 && t < 360 && l > 10 && l < 230)
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

    const double Epsilon = 0.008856; // Intent is 216/24389
    const double Kappa = 903.3; // Intent is 24389/27

    const double whiteReferenceX = 95.047;
    const double whiteReferenceY = 100.000;
    const double whiteReferenceZ = 108.883;

};


#endif // IMAGEANALYZER_H
