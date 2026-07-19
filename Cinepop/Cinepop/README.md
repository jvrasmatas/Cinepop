# Cinepop 🎬

Cinepop es una aplicación móvil desarrollada en Flutter para descubrir
películas populares, mejor calificadas y próximos estrenos, consultando la
API pública de **The Movie Database (TMDB)**. Permite buscar películas,
filtrarlas por género y calificación, descubrir una película al azar, ver
sus detalles completos (sinopsis, géneros, reparto) y guardar favoritos
localmente en el dispositivo.

## Descripción

Cinepop nace como un proyecto para practicar buenas prácticas de desarrollo
en Flutter: arquitectura organizada por capas, widgets reutilizables, manejo
de estado con Provider, manejo de errores, estados de carga y vacío, y una
identidad visual coherente basada en Material Design 3.

## Funcionalidades

- Listas de películas populares, mejor calificadas y próximos estrenos.
- Búsqueda de películas por nombre.
- Filtro por género y calificación mínima.
- Modo "Descubrir": sugiere una película al azar.
- Detalle de película con sinopsis, géneros y reparto.
- Favoritos guardados localmente, sin necesidad de conexión para verlos.
- Tema oscuro con identidad visual propia.

## Tecnologías

- Flutter 3.x / Dart
- Material Design 3
- [Provider](https://pub.dev/packages/provider) — manejo de estado
- [http](https://pub.dev/packages/http) — consumo de la API de TMDB
- [cached_network_image](https://pub.dev/packages/cached_network_image) — carga y cacheo de imágenes
- [shared_preferences](https://pub.dev/packages/shared_preferences) — persistencia local de favoritos
- [google_fonts](https://pub.dev/packages/google_fonts) — tipografía Poppins

## Requisitos previos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado (canal estable).
- Un emulador Android/iOS configurado, o un navegador (Flutter Web) o dispositivo físico.
- Una API key gratuita de [TMDB](https://www.themoviedb.org/settings/api).

## Créditos

Desarrollado por **Valeryn Duque y Juan Vrasmatas** para la materia de
Desarrollo de Aplicaciones Móviles, Universidad de Margarita.

Datos de películas provistos por [The Movie Database (TMDB)](https://www.themoviedb.org/).
Este producto usa la API de TMDB pero no está respaldado ni certificado por TMDB.
