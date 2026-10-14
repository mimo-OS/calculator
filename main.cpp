/*
 * Copyright (C) 2020 CutefishOS.
 *
 * Author:     revenmartin <revenmartin@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTranslator>
#include <QLocale>
#include <QIcon>
#include <QFile>
#include <QTimer>
#ifdef __GLIBC__
#include <malloc.h>
#endif
#include "calcengine.h"

int main(int argc, char *argv[])
{
#ifdef __GLIBC__
    mallopt(M_ARENA_MAX, 2);
    mallopt(M_TRIM_THRESHOLD, 128 * 1024);
    mallopt(M_MMAP_THRESHOLD, 64 * 1024);
#endif

    // Dynamic EGL vendor selection to prevent NVIDIA driver bloat on Intel/AMD GPUs
    if (!QFile::exists(QStringLiteral("/dev/nvidia0")) &&
        QFile::exists(QStringLiteral("/usr/share/glvnd/egl_vendor.d/50_mesa.json"))) {
        qputenv("__EGL_VENDOR_LIBRARY_FILENAMES", "/usr/share/glvnd/egl_vendor.d/50_mesa.json");
    }

    qputenv("QSG_RENDER_LOOP", "basic");

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling, true);
#endif

    QGuiApplication app(argc, argv);
    app.setApplicationName("mimo-calculator");
    app.setApplicationDisplayName(QObject::tr("mimo OS Calculator"));
    app.setWindowIcon(QIcon::fromTheme("cutefish-calculator"));

    // Trim freed memory after startup and periodically
    QTimer::singleShot(2000, []() {
#ifdef __GLIBC__
        malloc_trim(0);
#endif
    });

    QTimer *trimTimer = new QTimer(&app);
    trimTimer->setInterval(45000);
    QObject::connect(trimTimer, &QTimer::timeout, []() {
#ifdef __GLIBC__
        malloc_trim(0);
#endif
    });
    trimTimer->start();

    qmlRegisterType<CalcEngine>("Cutefish.Calculator", 1, 0, "CalcEngine");

    QQmlApplicationEngine engine;

#ifdef QT_DEBUG
    engine.rootContext()->setContextProperty(QStringLiteral("debug"), true);
#else
    engine.rootContext()->setContextProperty(QStringLiteral("debug"), false);
#endif

    // Translations
    QLocale locale;
    QString qmFilePath = QString("%1/%2.qm").arg("/usr/share/cutefish-calculator/translations/").arg(locale.name());
    if (QFile::exists(qmFilePath)) {
        QTranslator *translator = new QTranslator(QGuiApplication::instance());
        if (translator->load(qmFilePath)) {
            QGuiApplication::installTranslator(translator);
        } else {
            translator->deleteLater();
        }
    }

    engine.addImportPath(QStringLiteral("qrc:/"));
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}
