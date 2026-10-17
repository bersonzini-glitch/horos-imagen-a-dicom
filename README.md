# Imagen a DICOM — Horos plugin for Apple Silicon

[Español](#español) · [English](#english)

Native **arm64** plugin for **Horos 4** that converts photos (JPG, PNG, HEIC, …) into DICOM Secondary Capture files and imports them straight into the Horos database.

The original *JPEG to DICOM* plugin from the Horos catalog only ships an Intel (x86_64) binary, so it doesn't load in Horos 4 on Apple Silicon Macs. This is a from-scratch replacement.

---

## Español

### Qué hace

- Convierte una o varias imágenes (JPG, PNG, HEIC y cualquier formato que lea macOS) a DICOM *Secondary Capture* (modalidad `OT`) y las importa a Horos automáticamente.
- **Toma los datos del paciente seleccionado** en Horos (apellido, nombre, ID, fecha de nacimiento, sexo), leídos del archivo DICOM original.
- Opcionalmente **agrega las imágenes al estudio seleccionado** como una serie nueva, por ejemplo fotos clínicas junto a la resonancia.
- Respeta la orientación EXIF de las fotos del celular.
- Por defecto reduce a 1600 px y comprime en JPEG Baseline dentro del DICOM (archivos livianos). Se puede desactivar para resolución completa sin compresión.
- Nombres con acentos y ñ (UTF-8, `ISO_IR 192`).
- Opción de guardar una copia del `.dcm` en Descargas.

### Requisitos

- Horos **4.x** en una Mac con Apple Silicon (M1 o posterior).
- macOS 11 o posterior.

### Instalación

1. Descargá **`Instalar Imagen a DICOM.pkg`** desde [Releases](../../releases/latest).
2. Hacé doble clic. Como el instalador no está notarizado por Apple, la Mac puede decir que no puede verificarlo: tocá **OK**, andá a **Ajustes del Sistema → Privacidad y seguridad**, bajá hasta el final y tocá **"Abrir igualmente"**.
3. Seguí el instalador y, al terminar, cerrá y volvé a abrir Horos.

<details>
<summary>Instalación manual con el .zip (usuarios avanzados)</summary>

Descomprimí `JPEGToDICOMArm.horosplugin.zip`, quitá la cuarentena y hacé doble clic en el plugin (o copialo a `~/Library/Application Support/Horos/Plugins/`):

```bash
xattr -dr com.apple.quarantine ~/Downloads/JPEGToDICOMArm.horosplugin
```

Sin ese paso macOS bloquea la carga del plugin.
</details>

### Uso

1. (Opcional) Seleccioná en Horos un estudio, serie o imagen del paciente.
2. Menú **Plugins → Database → Imagen a DICOM…**
3. Elegí las imágenes, revisá los datos y tocá **Convertir**. En unos segundos aparecen en la base de datos.

### Compilar desde el código

Solo hacen falta las *Command Line Tools* de Xcode (no Xcode completo):

```bash
xcode-select --install   # si no las tenés
./build.sh               # genera el plugin, el .zip y el instalador .pkg en build/
```

`build/jpg2dcm_test` es una herramienta de línea de comandos para probar la conversión sin Horos.

### Aviso

Las imágenes generadas son capturas secundarias (fotos encapsuladas en DICOM) y **no están pensadas para diagnóstico primario**. Este software no es un dispositivo médico. Se distribuye "tal cual", sin garantía (ver [LICENSE](LICENSE)).

---

## English

### Features

- Converts one or more images (JPG, PNG, HEIC and anything macOS can read) into DICOM *Secondary Capture* (`OT` modality) and imports them into Horos automatically.
- **Uses the patient selected** in the Horos browser (name, ID, birth date, sex), read from the original DICOM file so the surname/given-name split is preserved.
- Optionally **adds the images to the selected study** as a new series, e.g. clinical photos next to an MRI.
- Honors EXIF orientation from phone photos.
- By default downsizes to 1600 px and stores JPEG Baseline inside the DICOM (small files). Can be turned off for full-resolution uncompressed RGB.
- UTF-8 patient names (`ISO_IR 192`).
- Optional copy of each `.dcm` saved to Downloads.

### Requirements

- Horos **4.x** on an Apple Silicon Mac (M1 or later).
- macOS 11 or later.

### Install

1. Download **`Instalar Imagen a DICOM.pkg`** from [Releases](../../releases/latest).
2. Double-click it. The installer isn't notarized by Apple, so macOS may say it can't verify it: click **OK**, open **System Settings → Privacy & Security**, scroll down and click **"Open Anyway"**.
3. Follow the installer, then quit and reopen Horos.

<details>
<summary>Manual install from the .zip (advanced)</summary>

Unzip `JPEGToDICOMArm.horosplugin.zip`, remove the quarantine flag and double-click the plugin (or copy it into `~/Library/Application Support/Horos/Plugins/`):

```bash
xattr -dr com.apple.quarantine ~/Downloads/JPEGToDICOMArm.horosplugin
```

Without this, macOS refuses to load the plugin. The `.pkg` avoids it because files installed by Installer are not quarantined.
</details>

### Usage

1. (Optional) Select a study, series or image of the patient in Horos.
2. **Plugins → Database → Imagen a DICOM…**
3. Pick the images, check the form and click **Convertir**. They show up in the database within seconds.

### Building

Only Xcode *Command Line Tools* are needed:

```bash
xcode-select --install   # if needed
./build.sh               # builds the plugin, the .zip and the .pkg installer in build/
```

The plugin links against the Horos executable with `-bundle_loader` and declares only the minimal `PluginFilter` interface it needs (`PluginFilter.h`); Horos 4 is signed with `disable-library-validation`, so an ad-hoc signature is enough. `build/jpg2dcm_test` is a CLI to test conversion without Horos.

### How it works

| File | Purpose |
|---|---|
| `JPEGToDICOMArm.m` | Plugin entry point, form, reading the Horos selection, import via the database `INCOMING` folder |
| `DicomWriter.m` | Minimal DICOM Part 10 writer (Explicit VR Little Endian / encapsulated JPEG Baseline) |
| `DicomHeaderReader.m` | Small reader for patient/study attributes of the selected study |

### Disclaimer

Generated images are secondary captures (photos wrapped in DICOM) and are **not intended for primary diagnosis**. This software is not a medical device and is provided "as is", without warranty (see [LICENSE](LICENSE)).

---

Made by **Bernardo Sonzini Astudillo** — [columna-spine.com](https://columna-spine.com)
