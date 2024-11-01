import datetime
import json
import os
import re
import shutil
import sqlite3
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

import colorama
import vlc
import yt_dlp
from colorama import Back, Fore, Style
from tqdm import tqdm

# Initialize colorama
colorama.init(autoreset=True)


def crear_carpeta(ruta):
    try:
        Path(ruta).mkdir(parents=True, exist_ok=True)
    except PermissionError:
        print(
            f"{Fore.RED}Error: No tienes permisos para crear la carpeta en {ruta}{Style.RESET_ALL}"
        )
        return False
    except Exception as e:
        print(f"{Fore.RED}Error al crear la carpeta: {str(e)}{Style.RESET_ALL}")
        return False
    return True


def obtener_carpeta_descarga():
    config = cargar_configuracion()
    carpeta_defecto = config.get("carpeta_descarga", os.path.expanduser("~/Music"))

    if not crear_carpeta(carpeta_defecto):
        carpeta_defecto = os.getcwd()
        print(
            f"{Fore.YELLOW}Usando el directorio actual como carpeta de descarga: {carpeta_defecto}{Style.RESET_ALL}"
        )

    while True:
        eleccion = input(
            f"{Fore.YELLOW}¿Deseas descargar en {carpeta_defecto}? (S/n): {Style.RESET_ALL}"
        ).lower()
        if eleccion in ["", "s", "n"]:
            break
        print(f"{Fore.RED}Por favor, ingresa 'S' o 'N'.{Style.RESET_ALL}")

    if eleccion == "n":
        while True:
            nueva_carpeta = input(
                f"{Fore.YELLOW}Ingresa la ruta completa de la carpeta de descarga: {Style.RESET_ALL}"
            )
            if crear_carpeta(nueva_carpeta):
                config["carpeta_descarga"] = nueva_carpeta
                guardar_configuracion(config)
                return nueva_carpeta
            print(
                f"{Fore.RED}No se pudo crear la carpeta. Intenta de nuevo.{Style.RESET_ALL}"
            )
    return carpeta_defecto


def mostrar_progreso(d):
    if d["status"] == "downloading":
        porcentaje = d.get("_percent_str", "N/A")
        velocidad = d.get("_speed_str", "N/A")
        tiempo_restante = d.get("_eta_str", "N/A")
        sys.stdout.write(
            f"\r{Fore.CYAN}Descargando... {porcentaje} a {velocidad} ETA: {tiempo_restante}{Style.RESET_ALL}"
        )
        sys.stdout.flush()
    elif d["status"] == "finished":
        print(f"\n{Fore.GREEN}Descarga completada. Procesando...{Style.RESET_ALL}")


def limpiar_archivos_temporales(carpeta):
    extensiones_a_mantener = [".mp3", ".mp4"]
    try:
        for archivo in os.listdir(carpeta):
            ruta_archivo = os.path.join(carpeta, archivo)
            if os.path.isfile(ruta_archivo):
                nombre, extension = os.path.splitext(archivo)
                if extension.lower() not in extensiones_a_mantener:
                    os.remove(ruta_archivo)
    except Exception as e:
        print(
            f"{Fore.RED}Error al limpiar archivos temporales: {str(e)}{Style.RESET_ALL}"
        )


def convertir_formato(archivo_entrada, formato_salida):
    nombre, _ = os.path.splitext(archivo_entrada)
    archivo_salida = f"{nombre}.{formato_salida}"

    formatos_video = [
        "mp4",
        "avi",
        "mov",
        "mkv",
        "flv",
        "wmv",
        "webm",
        "vob",
        "m4v",
        "3gp",
    ]
    formatos_audio = ["mp3", "wav", "ogg", "flac", "aac", "m4a"]

    if formato_salida in formatos_video:
        comando = [
            "ffmpeg",
            "-i",
            archivo_entrada,
            "-c:v",
            "libx264",
            "-crf",
            "23",
            "-c:a",
            "aac",
            "-q:a",
            "100",
            archivo_salida,
        ]
    elif formato_salida in formatos_audio:
        if formato_salida == "mp3":
            comando = [
                "ffmpeg",
                "-i",
                archivo_entrada,
                "-acodec",
                "libmp3lame",
                "-b:a",
                "320k",
                archivo_salida,
            ]
        elif formato_salida == "wav":
            comando = ["ffmpeg", "-i", archivo_entrada, archivo_salida]
        elif formato_salida == "ogg":
            comando = [
                "ffmpeg",
                "-i",
                archivo_entrada,
                "-c:a",
                "libvorbis",
                "-q:a",
                "4",
                archivo_salida,
            ]
        elif formato_salida == "flac":
            comando = ["ffmpeg", "-i", archivo_entrada, "-c:a", "flac", archivo_salida]
        elif formato_salida in ["aac", "m4a"]:
            comando = [
                "ffmpeg",
                "-i",
                archivo_entrada,
                "-c:a",
                "aac",
                "-b:a",
                "256k",
                archivo_salida,
            ]
    else:
        print(
            f"{Fore.RED}Formato de salida no soportado: {formato_salida}{Style.RESET_ALL}"
        )
        return None

    try:
        subprocess.run(
            comando, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
        )
        return archivo_salida
    except subprocess.CalledProcessError:
        print(
            f"{Fore.RED}Error al convertir a {formato_salida}. Asegúrate de tener ffmpeg instalado.{Style.RESET_ALL}"
        )
        return None
    except Exception as e:
        print(
            f"{Fore.RED}Error inesperado al convertir el archivo: {str(e)}{Style.RESET_ALL}"
        )
        return None


def descargar_video(
    url, formato="mp3", carpeta_destino=None, calidad_audio="320", filtros=None
):
    if carpeta_destino is None:
        carpeta_destino = obtener_carpeta_descarga()

    ydl_opts = {
        "format": "bestaudio/best",
        "postprocessors": [
            {
                "key": "FFmpegExtractAudio",
                "preferredcodec": "mp3",
                "preferredquality": calidad_audio,
            }
        ],
        "outtmpl": os.path.join(carpeta_destino, "%(title)s.%(ext)s"),
        "progress_hooks": [mostrar_progreso],
        "writethumbnail": True,
        "embedthumbnail": True,
        "add_metadata": True,
    }

    if formato == "mp4":
        ydl_opts["format"] = "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"
        ydl_opts["postprocessors"] = []

    if filtros:
        ydl_opts.update(filtros)

    try:
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            info = ydl.extract_info(url, download=True)
            if "_type" in info and info["_type"] == "playlist":
                print(
                    f"\n{Fore.GREEN}Descarga de lista de reproducción completada: {info['title']}{Style.RESET_ALL}"
                )
                print(
                    f"{Fore.CYAN}Se descargaron {len(info['entries'])} videos.{Style.RESET_ALL}"
                )
                for entry in info["entries"]:
                    agregar_al_historial(entry["id"], entry["title"], formato)
                archivo_descargado = os.path.join(carpeta_destino, f"{info['title']}")
            else:
                print(
                    f"\n{Fore.GREEN}Descarga completada: {info['title']}{Style.RESET_ALL}"
                )
                agregar_al_historial(info["id"], info["title"], formato)
                archivo_descargado = os.path.join(
                    carpeta_destino, f"{info['title']}.{formato}"
                )

        limpiar_archivos_temporales(carpeta_destino)
        enviar_notificacion(f"Descarga completada: {info['title']}")

        while True:
            reproducir = input(
                f"{Fore.YELLOW}¿Deseas reproducir el archivo descargado? (s/N): {Style.RESET_ALL}"
            ).lower()
            if reproducir in ["s", "n", ""]:
                break
            print(f"{Fore.RED}Por favor, ingresa 'S' o 'N'.{Style.RESET_ALL}")

        if reproducir == "s":
            reproducir_archivo(archivo_descargado)

        return True
    except yt_dlp.utils.DownloadError as e:
        print(f"\n{Fore.RED}Error al descargar: {str(e)}{Style.RESET_ALL}")
        return False
    except Exception as e:
        print(f"\n{Fore.RED}Error inesperado: {str(e)}{Style.RESET_ALL}")
        return False


def buscar_video(query):
    ydl_opts = {
        "quiet": True,
        "no_warnings": True,
        "extract_flat": True,
        "default_search": "ytsearch5:",
    }

    try:
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            result = ydl.extract_info(f"ytsearch5:{query}", download=False)
            return result["entries"]
    except Exception as e:
        print(f"{Fore.RED}Error al buscar videos: {str(e)}{Style.RESET_ALL}")
        return []


def descargar_playlist(url, formato="mp3", carpeta_destino=None):
    if carpeta_destino is None:
        carpeta_destino = obtener_carpeta_descarga()

    ydl_opts = {
        "format": "bestaudio/best",
        "postprocessors": [
            {
                "key": "FFmpegExtractAudio",
                "preferredcodec": "mp3",
                "preferredquality": "320",
            }
        ],
        "outtmpl": os.path.join(
            carpeta_destino, "%(playlist_title)s/%(title)s.%(ext)s"
        ),
        "ignoreerrors": True,
    }

    if formato == "mp4":
        ydl_opts["format"] = "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"
        ydl_opts["postprocessors"] = []

    try:
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            info = ydl.extract_info(url, download=False)
            if "_type" in info and info["_type"] == "playlist":
                videos = info["entries"]
                with ThreadPoolExecutor(max_workers=5) as executor:
                    list(
                        tqdm(
                            executor.map(
                                lambda video: ydl.download([video["url"]]), videos
                            ),
                            total=len(videos),
                        )
                    )
                print(
                    f"\n{Fore.GREEN}Descarga de lista de reproducción completada: {info['title']}{Style.RESET_ALL}"
                )
                print(
                    f"{Fore.CYAN}Se descargaron {len(videos)} videos.{Style.RESET_ALL}"
                )
                for video in videos:
                    agregar_al_historial(video["id"], video["title"], formato)
                enviar_notificacion(f"Descarga de playlist completada: {info['title']}")

                while True:
                    reproducir = input(
                        f"{Fore.YELLOW}¿Deseas reproducir la lista de reproducción descargada? (s/N): {Style.RESET_ALL}"
                    ).lower()
                    if reproducir in ["s", "n", ""]:
                        break
                    print(f"{Fore.RED}Por favor, ingresa 'S' o 'N'.{Style.RESET_ALL}")

                if reproducir == "s":
                    reproducir_playlist(os.path.join(carpeta_destino, info["title"]))
            else:
                print(
                    f"{Fore.RED}La URL proporcionada no es una lista de reproducción válida.{Style.RESET_ALL}"
                )
    except Exception as e:
        print(
            f"{Fore.RED}Error al descargar la lista de reproducción: {str(e)}{Style.RESET_ALL}"
        )


def renombrar_archivos(carpeta):
    try:
        for archivo in os.listdir(carpeta):
            if os.path.isfile(os.path.join(carpeta, archivo)):
                nombre, extension = os.path.splitext(archivo)
                nuevo_nombre = re.sub(r"[^\w\-_\. ]", "_", nombre)
                nuevo_nombre = nuevo_nombre.strip() + extension
                if nuevo_nombre != archivo:
                    os.rename(
                        os.path.join(carpeta, archivo),
                        os.path.join(carpeta, nuevo_nombre),
                    )
                    print(
                        f"{Fore.GREEN}Renombrado: {archivo} -> {nuevo_nombre}{Style.RESET_ALL}"
                    )
    except Exception as e:
        print(f"{Fore.RED}Error al renombrar archivos: {str(e)}{Style.RESET_ALL}")


def cargar_configuracion():
    config_file = os.path.expanduser("~/.youtube_downloader_config.json")
    try:
        if os.path.exists(config_file):
            with open(config_file, "r") as f:
                return json.load(f)
    except Exception as e:
        print(f"{Fore.RED}Error al cargar la configuración: {str(e)}{Style.RESET_ALL}")
    return {}


def guardar_configuracion(config):
    config_file = os.path.expanduser("~/.youtube_downloader_config.json")
    try:
        with open(config_file, "w") as f:
            json.dump(config, f)
    except Exception as e:
        print(f"{Fore.RED}Error al guardar la configuración: {str(e)}{Style.RESET_ALL}")


def enviar_notificacion(mensaje):
    try:
        subprocess.run(["dunstify", "YouTube Downloader", mensaje])
    except FileNotFoundError:
        print(
            f"{Fore.YELLOW}dunstify no está instalado. No se pudo enviar la notificación.{Style.RESET_ALL}"
        )
    except Exception as e:
        print(f"{Fore.RED}Error al enviar la notificación: {str(e)}{Style.RESET_ALL}")


def inicializar_base_datos():
    try:
        conn = sqlite3.connect("historial_descargas.db")
        c = conn.cursor()
        c.execute(
            """CREATE TABLE IF NOT EXISTS historial
                     (id TEXT PRIMARY KEY, titulo TEXT, formato TEXT, fecha TEXT)"""
        )
        conn.commit()
        conn.close()
    except Exception as e:
        print(
            f"{Fore.RED}Error al inicializar la base de datos: {str(e)}{Style.RESET_ALL}"
        )


def agregar_al_historial(id_video, titulo, formato):
    try:
        conn = sqlite3.connect("historial_descargas.db")
        c = conn.cursor()
        fecha = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        c.execute(
            "INSERT OR REPLACE INTO historial VALUES (?, ?, ?, ?)",
            (id_video, titulo, formato, fecha),
        )
        conn.commit()
        conn.close()
    except Exception as e:
        print(f"{Fore.RED}Error al agregar al historial: {str(e)}{Style.RESET_ALL}")


def mostrar_historial():
    try:
        conn = sqlite3.connect("historial_descargas.db")
        c = conn.cursor()
        c.execute("SELECT * FROM historial ORDER BY fecha DESC")
        historial = c.fetchall()
        conn.close()

        if not historial:
            print(f"{Fore.YELLOW}No hay historial de descargas.{Style.RESET_ALL}")
        else:
            print(f"\n{Fore.CYAN}--- Historial de Descargas ---{Style.RESET_ALL}")
            for i, (id_video, titulo, formato, fecha) in enumerate(historial, 1):
                print(
                    f"{Fore.GREEN}{i}. {titulo} ({formato}) - {fecha}{Style.RESET_ALL}"
                )

        return historial
    except Exception as e:
        print(f"{Fore.RED}Error al mostrar el historial: {str(e)}{Style.RESET_ALL}")
        return []


def eliminar_del_historial(indice):
    historial = mostrar_historial()
    if not historial:
        return

    try:
        if 1 <= indice <= len(historial):
            id_video = historial[indice - 1][0]
            conn = sqlite3.connect("historial_descargas.db")
            c = conn.cursor()
            c.execute("DELETE FROM historial WHERE id = ?", (id_video,))
            conn.commit()
            conn.close()
            print(
                f"{Fore.GREEN}Entrada eliminada del historial: {historial[indice - 1][1]}{Style.RESET_ALL}"
            )
        else:
            print(f"{Fore.RED}Índice inválido.{Style.RESET_ALL}")
    except Exception as e:
        print(f"{Fore.RED}Error al eliminar del historial: {str(e)}{Style.RESET_ALL}")


def conversion_por_lotes(carpeta, formato_salida):
    try:
        archivos = [
            f for f in os.listdir(carpeta) if os.path.isfile(os.path.join(carpeta, f))
        ]
        for archivo in archivos:
            archivo_entrada = os.path.join(carpeta, archivo)
            archivo_convertido = convertir_formato(archivo_entrada, formato_salida)
            if archivo_convertido:
                print(
                    f"{Fore.GREEN}Convertido: {archivo} -> {os.path.basename(archivo_convertido)}{Style.RESET_ALL}"
                )
    except Exception as e:
        print(f"{Fore.RED}Error en la conversión por lotes: {str(e)}{Style.RESET_ALL}")


def reproducir_archivo(archivo):
    try:
        # Intentar reproducir con VLC
        instance = vlc.Instance()
        player = instance.media_player_new()
        media = instance.media_new(archivo)
        player.set_media(media)
        player.play()
        print(
            f"{Fore.GREEN}Reproduciendo: {os.path.basename(archivo)}{Style.RESET_ALL}"
        )
        print(
            f"{Fore.YELLOW}Presiona Enter para detener la reproducción...{Style.RESET_ALL}"
        )
        input()
        player.stop()
    except Exception:
        try:
            # Si VLC falla, intentar con mpv
            subprocess.run(["mpv", archivo], check=True)
        except subprocess.CalledProcessError:
            print(
                f"{Fore.RED}No se pudo reproducir el archivo. Asegúrate de tener VLC o mpv instalado.{Style.RESET_ALL}"
            )
        except Exception as e:
            print(
                f"{Fore.RED}Error inesperado al reproducir el archivo: {str(e)}{Style.RESET_ALL}"
            )


def reproducir_playlist(carpeta):
    try:
        archivos = [
            os.path.join(carpeta, f)
            for f in os.listdir(carpeta)
            if os.path.isfile(os.path.join(carpeta, f))
        ]
        # Intentar reproducir con VLC
        instance = vlc.Instance()
        player = instance.media_list_player_new()
        media_list = instance.media_list_new(archivos)
        player.set_media_list(media_list)
        player.play()
        print(
            f"{Fore.GREEN}Reproduciendo playlist: {os.path.basename(carpeta)}{Style.RESET_ALL}"
        )
        print(
            f"{Fore.YELLOW}Presiona Enter para detener la reproducción...{Style.RESET_ALL}"
        )
        input()
        player.stop()
    except Exception:
        try:
            # Si VLC falla, intentar con mpv
            subprocess.run(["mpv"] + archivos, check=True)
        except subprocess.CalledProcessError:
            print(
                f"{Fore.RED}No se pudo reproducir la playlist. Asegúrate de tener VLC o mpv instalado.{Style.RESET_ALL}"
            )
        except Exception as e:
            print(
                f"{Fore.RED}Error inesperado al reproducir la playlist: {str(e)}{Style.RESET_ALL}"
            )


def descargar_subtitulos(url, carpeta_destino):
    ydl_opts = {
        "writesubtitles": True,
        "writeautomaticsub": True,
        "subtitleslangs": ["es", "en"],  # Descarga subtítulos en español e inglés
        "skip_download": True,  # No descarga el video, solo los subtítulos
        "outtmpl": os.path.join(carpeta_destino, "%(title)s.%(ext)s"),
    }

    try:
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            ydl.download([url])
        print(
            f"{Fore.GREEN}Subtítulos descargados en: {carpeta_destino}{Style.RESET_ALL}"
        )
    except Exception as e:
        print(f"{Fore.RED}Error al descargar subtítulos: {str(e)}{Style.RESET_ALL}")


def main():
    inicializar_base_datos()
    config = cargar_configuracion()
    while True:
        print(f"\n{Fore.CYAN}--- YouTube Downloader ---{Style.RESET_ALL}")
        print(f"{Fore.YELLOW}1: Descargar por URL{Style.RESET_ALL}")
        print(f"{Fore.YELLOW}2: Buscar y descargar{Style.RESET_ALL}")
        print(f"{Fore.YELLOW}3: Descargar lista de reproducción{Style.RESET_ALL}")
        print(f"{Fore.YELLOW}4: Renombrar archivos{Style.RESET_ALL}")
        print(f"{Fore.YELLOW}5: Mostrar historial de descargas{Style.RESET_ALL}")
        print(f"{Fore.YELLOW}6: Eliminar entrada del historial{Style.RESET_ALL}")
        print(f"{Fore.YELLOW}7: Conversión por lotes{Style.RESET_ALL}")
        print(f"{Fore.YELLOW}8: Descargar subtítulos{Style.RESET_ALL}")
        print(f"{Fore.YELLOW}9: Configuración{Style.RESET_ALL}")
        print(f"{Fore.YELLOW}10: Salir{Style.RESET_ALL}")

        modo = input(f"{Fore.GREEN}Elige una opción: {Style.RESET_ALL}")

        if modo == "10":
            print(f"{Fore.CYAN}¡Hasta luego!{Style.RESET_ALL}")
            break

        if modo in ["1", "2", "3"]:
            formato = (
                input(
                    f"{Fore.YELLOW}Elige el formato (mp3/mp4) [mp3]: {Style.RESET_ALL}"
                ).lower()
                or "mp3"
            )
            carpeta_destino = config.get("carpeta_descarga", obtener_carpeta_descarga())

            # Filtros avanzados
            filtros = {}
            usar_filtros = (
                input(
                    f"{Fore.YELLOW}¿Deseas usar filtros avanzados? (s/N): {Style.RESET_ALL}"
                ).lower()
                == "s"
            )
            if usar_filtros:
                fecha_despues = input(
                    f"{Fore.YELLOW}Descargar videos después de (YYYYMMDD, dejar en blanco para omitir): {Style.RESET_ALL}"
                )
                if fecha_despues:
                    filtros["dateafter"] = fecha_despues

                duracion_min = input(
                    f"{Fore.YELLOW}Duración mínima en segundos (dejar en blanco para omitir): {Style.RESET_ALL}"
                )
                if duracion_min:
                    filtros["match_filter"] = f"duration > {duracion_min}"

                vistas_min = input(
                    f"{Fore.YELLOW}Número mínimo de vistas (dejar en blanco para omitir): {Style.RESET_ALL}"
                )
                if vistas_min:
                    filtros["view_count"] = int(vistas_min)

            if modo == "1":
                url = input(
                    f"{Fore.YELLOW}Ingresa la URL del video de YouTube: {Style.RESET_ALL}"
                )
                descargar_video(url, formato, carpeta_destino, filtros=filtros)
            elif modo == "2":
                query = input(f"{Fore.YELLOW}Ingresa tu búsqueda: {Style.RESET_ALL}")
                resultados = buscar_video(query)

                if resultados:
                    for i, video in enumerate(resultados):
                        print(f"{Fore.CYAN}{i+1}. {video['title']}{Style.RESET_ALL}")

                    while True:
                        try:
                            seleccion = (
                                int(
                                    input(
                                        f"{Fore.YELLOW}Elige el número del video que quieres descargar: {Style.RESET_ALL}"
                                    )
                                )
                                - 1
                            )
                            if 0 <= seleccion < len(resultados):
                                descargar_video(
                                    resultados[seleccion]["url"],
                                    formato,
                                    carpeta_destino,
                                    filtros=filtros,
                                )
                                break
                            else:
                                print(
                                    f"{Fore.RED}Selección inválida. Intenta de nuevo.{Style.RESET_ALL}"
                                )
                        except ValueError:
                            print(
                                f"{Fore.RED}Por favor, ingresa un número válido.{Style.RESET_ALL}"
                            )
                else:
                    print(
                        f"{Fore.RED}No se encontraron resultados para la búsqueda.{Style.RESET_ALL}"
                    )
            elif modo == "3":
                url = input(
                    f"{Fore.YELLOW}Ingresa la URL de la lista de reproducción de YouTube: {Style.RESET_ALL}"
                )
                descargar_playlist(url, formato, carpeta_destino)
        elif modo == "4":
            carpeta = input(
                f"{Fore.YELLOW}Ingresa la ruta de la carpeta con los archivos a renombrar: {Style.RESET_ALL}"
            )
            renombrar_archivos(carpeta)
        elif modo == "5":
            mostrar_historial()
        elif modo == "6":
            historial = mostrar_historial()
            if historial:
                while True:
                    try:
                        indice = int(
                            input(
                                f"{Fore.YELLOW}Ingresa el número de la entrada que deseas eliminar: {Style.RESET_ALL}"
                            )
                        )
                        eliminar_del_historial(indice)
                        break
                    except ValueError:
                        print(
                            f"{Fore.RED}Por favor, ingresa un número válido.{Style.RESET_ALL}"
                        )
        elif modo == "7":
            carpeta = input(
                f"{Fore.YELLOW}Ingresa la ruta de la carpeta con los archivos a convertir: {Style.RESET_ALL}"
            )
            formato_salida = input(
                f"{Fore.YELLOW}Ingresa el formato de salida deseado: {Style.RESET_ALL}"
            )
            conversion_por_lotes(carpeta, formato_salida)
        elif modo == "8":
            url = input(
                f"{Fore.YELLOW}Ingresa la URL del video para descargar subtítulos: {Style.RESET_ALL}"
            )
            carpeta_destino = config.get("carpeta_descarga", obtener_carpeta_descarga())
            descargar_subtitulos(url, carpeta_destino)
        elif modo == "9":
            print(f"\n{Fore.CYAN}--- Configuración ---{Style.RESET_ALL}")
            print(
                f"{Fore.YELLOW}1: Cambiar carpeta de descarga (actual: {config.get('carpeta_descarga', 'No configurada')}){Style.RESET_ALL}"
            )
            print(f"{Fore.YELLOW}2: Volver al menú principal{Style.RESET_ALL}")
            opcion = input(f"{Fore.GREEN}Elige una opción: {Style.RESET_ALL}")
            if opcion == "1":
                nueva_carpeta = input(
                    f"{Fore.YELLOW}Ingresa la nueva ruta para la carpeta de descarga: {Style.RESET_ALL}"
                )
                if crear_carpeta(nueva_carpeta):
                    config["carpeta_descarga"] = nueva_carpeta
                    guardar_configuracion(config)
                    print(
                        f"{Fore.GREEN}Carpeta de descarga actualizada a: {nueva_carpeta}{Style.RESET_ALL}"
                    )
                else:
                    print(
                        f"{Fore.RED}No se pudo actualizar la carpeta de descarga.{Style.RESET_ALL}"
                    )
        else:
            print(
                f"{Fore.RED}Opción no válida. Por favor, elige una opción del 1 al 10.{Style.RESET_ALL}"
            )


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print(
            f"\n{Fore.YELLOW}Programa interrumpido por el usuario. ¡Hasta luego!{Style.RESET_ALL}"
        )
    except Exception as e:
        print(f"\n{Fore.RED}Error inesperado: {str(e)}{Style.RESET_ALL}")
        print(
            f"{Fore.YELLOW}El programa se cerrará. Por favor, reporta este error.{Style.RESET_ALL}"
        )
