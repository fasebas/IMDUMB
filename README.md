# IMDUMB - Technical Challenge (iOS)

## 📋 Resumen del Proyecto
IMDUMB es una aplicación iOS nativa desarrollada en Swift que permite explorar categorías de programas de televisión y películas, ver sus detalles y realizar recomendaciones. El proyecto ha sido diseñado siguiendo los estándares más altos de calidad de software, utilizando una arquitectura limpia y modular.

## 🏗️ Arquitectura y Patrones
Se ha implementado **Clean Architecture** en combinación con el patrón de diseño **MVP (Model-View-Presenter)** para asegurar la separación de responsabilidades, testabilidad y escalabilidad.

### Capas:
- **Domain:** Contiene las Entidades y Casos de Uso (Lógica de negocio pura).
- **Data:** Implementación de Repositorios y Servicios de Red (Alamofire).
- **Presentation:** Módulos organizados por escenas (Splash, Listado, Detalle) usando MVP y archivos `.xib` exclusivamente.
- **Core:** Extensiones, constantes y utilidades reutilizables.

## 🛠️ Stack Tecnológico
- **Lenguaje:** Swift 6.0+
- **Interfaz:** UIKit (XIBs) - *No SwiftUI, No Vistas Programáticas*.
- **Arquitectura:** MVP + Clean Architecture.
- **Gestión de Dependencias:** Swift Package Manager (SPM).
- **Networking:** Alamofire.
- **Backend/Config:** Firebase (Core y Remote Config).

## 🧩 Principios SOLID Aplicados
La documentación detallada de los principios se encuentra en los siguientes archivos:
1.  **Single Responsibility Principle (SRP):** Ver `Data/Network/NetworkService.swift`.
2.  **Dependency Inversion Principle (DIP):** Ver `Domain/UseCases/GetMoviesUseCase.swift`.
3.  **Interface Segregation Principle (ISP):** Ver `Presentation/MoviesList/Presenter/MoviesListPresenter.swift`.

## 🚀 Instalación y Ejecución
1.  Clonar el repositorio:
    ```bash
    git clone https://github.com/tu-usuario/IMDUMB.git
    ```
2.  Abrir `IMDUMB.xcodeproj` en Xcode (Versión 15.0+ recomendada).
3.  **Firebase:** El archivo `GoogleService-Info.plist` ya está incluido en el repositorio en la carpeta `Resources/` para facilitar la revisión técnica inmediata.
4.  Esperar a que Xcode resuelva las dependencias de SPM (Alamofire y Firebase).
5.  Seleccionar el Scheme **IMDUMB-Dev** o **IMDUMB-Prod**.
6.  Compilar y Ejecutar (`Cmd + R`).

## 📡 API Endpoints
Se utiliza la API gratuita de **TVMaze** para garantizar la disponibilidad inmediata sin necesidad de claves privadas:
- Listado: `https://api.tvmaze.com/shows`
- Reparto: `https://api.tvmaze.com/shows/{id}/cast`

---
*Desarrollado como parte de un reto técnico para la evaluación de habilidades en desarrollo iOS Senior.*
