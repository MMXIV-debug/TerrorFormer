# 📖 Documentación y Manual Técnico de TerrorFormer

Bienvenido a la documentación técnica de **TerrorFormer**. Este documento detalla todos los sistemas del juego organizados según la **estructura del Árbol de Recursos (Asset Browser) de GameMaker**, explicando **cómo funciona cada módulo**, **dónde encontrarlo en el editor**, **cómo modificarlo paso a paso** y las **mejoras planificadas para próximas versiones**.

---

## 📑 Tabla de Contenidos
1. [Organización de Recursos en el Asset Browser de GameMaker](#1-organización-de-recursos-en-el-asset-browser-de-gamemaker)
2. [Sistema de Checkpoints Progresivos](#2-sistema-de-checkpoints-progresivos)
3. [Sistema de Cuerda / Gancho (Grapple Hook)](#3-sistema-de-cuerda--gancho-grapple-hook)
4. [Inteligencia Artificial y Robots Enemigos](#4-inteligencia-artificial-y-robots-enemigos)
5. [Sistema de Escondite y Rejilla Industrial](#5-sistema-de-escondite-y-rejilla-industrial)
6. [Sistema de Iluminación Dinámica y Linterna](#6-sistema-de-iluminación-dinámica-y-linterna)
7. [Fondo Escénico con Efecto de Profundidad y Relieve](#7-fondo-escénico-con-efecto-de-profundidad-y-relieve)
8. [Preguntas Frecuentes y Solución de Problemas (Troubleshooting)](#8-preguntas-frecuentes-y-solución-de-problemas-troubleshooting)
9. [Roadmap: Mejoras Planificadas para la Siguiente Versión](#9-roadmap-mejoras-planificadas-para-la-siguiente-versión)

---

## 1. Organización de Recursos en el Asset Browser de GameMaker

Todos los elementos del juego se encuentran organizados en las siguientes carpetas del editor de GameMaker:

```
📁 Sprites
   ├── 📁 Enemies
   │    ├── s_enemy_1                 (Robot bípedo patrullero con reactor neón)
   │    └── s_enemy_2                 (Robot araña acechador cuadrúpedo)
   ├── 📁 Player
   │    └── 📁 States > NEW
   │         ├── 📁 Idle > s_player   (Sprite base del jugador)
   │         ├── 📁 Move > s_player_move
   │         ├── 📁 Jump > s_player_up
   │         └── 📁 Fall > s_player_down
   ├── 📁 Terrain
   │    └── s_hiding_spot             (Rejilla industrial con ranuras transparentes)
   ├── 📁 TileSets
   │    └── s_bg_tileset              (Texturas 32x32 de placas, tuberías y paneles)
   ├── s_checkpoint_active            (Baliza de checkpoint activada - luz verde)
   └── s_checkpoint_inactive          (Baliza de checkpoint apagada - luz roja)

📁 Objects
   ├── 📁 Enemies
   │    ├── o_enemy_body              (Cuerpo base con físicas y máquina de estados)
   │    └── 📁 EnemyC
   │         ├── o_enemy_1            (Robot bípedo)
   │         └── o_enemy_2            (Robot araña acechador)
   ├── 📁 Player
   │    └── o_player                  (Objeto del jugador: movimiento, gancho y armas)
   ├── 📁 Terrain
   │    ├── o_checkpoint              (Objeto de guardado arrastrable)
   │    └── o_hiding_spot             (Rejilla interactiva para esconderse con tecla E)
   └── 📁 Control > Effects > DynamicL
        └── o_light_ctrl              (Gestor de oscuridad, linterna y neones)

📁 Functions (Scripts)
   ├── 📁 Enemies
   │    ├── c_enemy_wander            (Patrulla y detección de bordes / pinchos)
   │    ├── c_enemy_chase             (Aceleración y persecución)
   │    ├── c_enemy_sim_jump          (Cálculo cinemático de saltos para la araña)
   │    └── 📁 Detection > DetecPlayer
   │         └── c_enemy_detect       (Línea de visión por raycast contra el jugador)
   └── 📁 Control
        ├── c_light_draw              (Dibujo de halos radiales de luz)
        ├── c_light_cast              (Proyección cónica de linterna con oclusión)
        ├── c_collision               (Detección de impacto contra muros)
        └── c_tile_damage             (Detección de pinchos y suelo tóxico)

📁 TileSets
   ├── ts_background                  (Tileset industrial modular en 32x32)
   └── ts_mundo_prueba                (Tileset de colisión y terreno jugable)

📁 Rooms
   └── Room1                          (Escenario principal del juego)
```

---

## 2. Sistema de Checkpoints Progresivos

### 🎯 ¿Cómo funciona?
* Los checkpoints son objetos nativos de GameMaker que se pueden arrastrar visualmente en el Room Editor:
  * **Carpeta:** `Objects > Terrain > o_checkpoint`
* Disponen de dos apariencias:
  * Inactivo: `Sprites > s_checkpoint_inactive` (Baliza apagada con LED rojo tenue).
  * Activo: `Sprites > s_checkpoint_active` (Núcleo holográfico verde turquesa pulsante).
* **Orden de progresión protegido (`order`):** Cada checkpoint tiene un número de orden. El jugador solo actualizará su punto de reaparición si el nuevo checkpoint tiene un `order` mayor o igual al que ya posee (`spawn_order`). Esto impide que al retroceder al inicio del mapa se pierda el progreso avanzado.
* **Persistencia visual:** Una vez activado, el checkpoint permanece encendido e iluminado permanentemente.

### 📁 Recursos de GameMaker involucrados:
* Objeto: `Objects > Terrain > o_checkpoint`
  * Evento `Create`: Define `order = 0`, `is_active = false` y radio `reach = 32`.
  * Evento `Step`: Detecta la cercanía del jugador (`o_player`), comprueba si `order >= o_player.spawn_order` y actualiza las coordenadas de respawn.
* Sprites:
  * `Sprites > s_checkpoint_active`
  * `Sprites > s_checkpoint_inactive`
* Jugador:
  * `Objects > Player > o_player`: Variables `spawn_x`, `spawn_y`, `spawn_order`, `invulMax` (segundos de invulnerabilidad al renacer) y `respawn_state`.

### 🛠️ ¿Cómo agregar o calibrar checkpoints en GameMaker?
1. **Colocar en el mapa:** Abre `Rooms > Room1` en el Room Editor y arrastra `o_checkpoint` sobre la capa de instancias (`Instances`).
2. **Definir el orden:** Haz doble clic sobre el checkpoint en la sala y en su panel de variables asigna el valor de `order` (ejemplo: Checkpoint 1 = `1`, Checkpoint 2 = `2`, etc.).
3. **Cambiar radio de activación:** Abre `Objects > Terrain > o_checkpoint`, ve a su evento `Create` y modifica `reach = 32;` (puedes aumentarlo a `48` o `64`).

---

## 3. Sistema de Cuerda / Gancho (Grapple Hook)

### 🎯 ¿Cómo funciona?
* El jugador dispara un gancho de acero hacia el cursor con el **clic derecho del ratón**.
* **Comportamiento físico:**
  * **Fase 1 (Vuelo):** El proyectil viaja en línea recta a alta velocidad (`gr_fly_speed = 32`) buscando impacto con muros o techos.
  * **Fase 2 (Anclado):** Se crea una cuerda con tensión pendular:
    * Teclas **A / D**: Aplican impulso lateral (`gr_push = 0.15`) para columpiarse.
    * Tecla **W**: Enrolla la cuerda (`gr_reel = 4`) y tira del jugador hacia el ancla (`gr_pull = 0.7`).
    * Tecla **S**: Desenrolla cuerda para descender.
    * **Espacio**: Salto de liberación que transfiere la inercia acumulada hacia adelante.
* **Sistema de Fatiga:** Para balancear la jugabilidad, el jugador no puede quedarse colgado para siempre. Tiene un límite de energía en los brazos (`gr_hang_max = 240` frames = ~4 segundos). Si el contador llega al máximo, se suelta automáticamente y debe esperar el cooldown (`gr_cooldown = 15`) antes de volver a disparar el gancho.

### 📁 Recursos de GameMaker involucrados:
* Objeto: `Objects > Player > o_player`
  * Evento `Create`: Parámetros `gr_max` (alcance), `gr_fly_speed`, `gr_reel`, `gr_pull`, `gr_push` y `gr_hang_max`.
  * Evento `Step`: Cálculo vectorial, colisiones y dinámica pendular.
  * Evento `Draw`: Renderizado visual de la línea de cable de acero.

### 🛠️ ¿Cómo modificar las físicas de la cuerda?
* **Aumentar el alcance del gancho:** En `Objects > Player > o_player > Create`, cambia `gr_max = 300;` por el alcance deseado (por ejemplo `450`).
* **Hacer que suba más rápido:** Cambia `gr_reel = 4;` por `6` u `8`.
* **Ajustar la fatiga de colgado:** Cambia `gr_hang_max = 240;` (para 6 segundos pon `360`, o pon `999999` si quieres tiempo infinito).

---

## 4. Inteligencia Artificial y Robots Enemigos

### 🎯 ¿Cómo funciona la jerarquía en el proyecto?
Los enemigos no están aislados en el código; siguen una **arquitectura orientada a objetos (Parent-Child)**:

```
                  ┌───────────────────────────────┐
                  │   Objects > Enemies           │
                  │   └── o_enemy_body            │  (Objeto Padre)
                  │   - Físicas y Gravedad        │
                  │   - Máquina de Estados (IA)   │
                  │   - Salud y Daño Recibido     │
                  └──────────────┬────────────────┘
                                 │
                 ┌───────────────┴───────────────┐
                 ▼                               ▼
       ┌───────────────────┐           ┌───────────────────┐
       │ Objects > Enemies │           │ Objects > Enemies │
       │   > EnemyC        │           │   > EnemyC        │
       │   └── o_enemy_1   │           │   └── o_enemy_2   │  (Objetos Hijos)
       │ - Robot Bípedo    │           │ - Robot Araña     │
       │ - Sprite:         │           │ - Sprite:         │
       │   s_enemy_1       │           │   s_enemy_2       │
       │ - Patrulla firme  │           │ - Salto simulado  │
       └───────────────────┘           └───────────────────┘
```

### Comportamiento de cada autómata:
1. **Robot Bípedo Patrullero (`o_enemy_1`):**
   * **Sprite:** `Sprites > Enemies > s_enemy_1` (6 fotogramas de caminata).
   * Tiene un reactor central en el pecho. Emite luz cian suave durante su patrulla (`IDLE` / `WANDER`) y conmuta a luz roja de alarma intensa al iniciar persecución (`CHASE`).
2. **Robot Araña Acechador (`o_enemy_2`):**
   * **Sprite:** `Sprites > Enemies > s_enemy_2` (6 fotogramas de paso arácnido).
   * Cuenta con un sensor óptico frontal y resplandor neón inferior que baña el suelo a su paso.
   * Si encuentra un desnivel o trampa persiguiendo al jugador, ejecuta cinemática de salto predictivo (`c_enemy_sim_jump`) para trepar plataformas.
3. **Orientación automática:**
   * En `o_enemy_body > Step`, detecta el sentido de avance: `facing = (hsp != 0) ? sign(hsp) : facing;`.
   * En `Draw`, invierte el sprite con `image_xscale = facing`, permitiendo caminar hacia ambos lados sin requerir sprites duplicados.
4. **Prevención de Suicidios en Pinchos:**
   * En el script de patrulla `c_enemy_wander`, los robots evalúan las baldosas mediante `c_tile_damage` para evitar caminar sobre pinchos o ácido.

### 📁 Recursos de GameMaker involucrados:
* Objeto Padre: `Objects > Enemies > o_enemy_body`
* Objeto Bípedo: `Objects > Enemies > EnemyC > o_enemy_1`
* Objeto Araña: `Objects > Enemies > EnemyC > o_enemy_2`
* Sprites:
  * `Sprites > Enemies > s_enemy_1`
  * `Sprites > Enemies > s_enemy_2`
* Scripts de IA:
  * `Functions > Enemies > c_enemy_wander`
  * `Functions > Enemies > Detection > DetecPlayer > c_enemy_detect`
  * `Functions > Enemies > c_enemy_chase`
  * `Functions > Enemies > c_enemy_sim_jump`

### 🛠️ ¿Cómo modificar la IA o los robots?
* **Colocar enemigos en el nivel:** Abre `Rooms > Room1` y arrastra `o_enemy_1` u `o_enemy_2` sobre la capa `Instances`.
* **Modificar velocidad de caminata:** En `Objects > Enemies > o_enemy_body > Create`, ajusta `spd_wander = 1.2;` (patrulla) y `spd_chase = 2.8;` (persecución).
* **Modificar distancia de visión:** En `Functions > Enemies > Detection > DetecPlayer > c_enemy_detect`, ajusta `detect_distance = 260;`.

---

## 5. Sistema de Escondite y Rejilla Industrial

### 🎯 ¿Cómo funciona?
* **Sprite temático:** `Sprites > Terrain > s_hiding_spot` representa una rejilla de ventilación industrial blindada con persianas metálicas horizontales y ranuras transparentes.
* **Profundidad de renderizado (`depth = 200`):**
  * La rejilla tiene asignada profundidad `depth = 200` en su evento `Create`.
  * Como los personajes operan en la capa `Instances` (`depth = 250`), **la rejilla se dibuja por delante del jugador y de los robots**.
  * Al pasar el robot araña por delante del escondite, **su silueta y sus ojos de neón se aprecian perfectamente a través de las ranuras abiertas de la rejilla**, creando un efecto cinematográfico de sigilo.
* **Mecánica de interacción:**
  * Al acercarse el jugador (`reach = 40`), el sprite pasa a su Frame 1 mostrando un LED verde y la tecla en pixel art **`[ E ]`**.
  * Al pulsar `E`, el jugador entra en estado `is_hidden = true`.
  * Mientras está escondido:
    * La linterna del jugador se apaga automáticamente para no delatar su posición.
    * Los enemigos no pueden detectarlo visualmente.
    * El jugador es inmune a daño por contacto.
    * Al pulsar `E` nuevamente, el jugador sale de la rejilla.

### 📁 Recursos de GameMaker involucrados:
* Objeto: `Objects > Terrain > o_hiding_spot`
* Sprite: `Sprites > Terrain > s_hiding_spot`
* Jugador: `Objects > Player > o_player > Step` (Control del input de teclado y estado `is_hidden`).

### 🛠️ ¿Cómo colocar o calibrar escondites?
* **Colocar en el mapa:** Abre `Rooms > Room1` y arrastra `o_hiding_spot` a la zona donde quieras habilitar una zona de sigilo.
* **Ajustar el radio para entrar:** En `Objects > Terrain > o_hiding_spot > Create`, cambia `reach = 40;` por el radio deseado (por ejemplo `60`).

---

## 6. Sistema de Iluminación Dinámica y Linterna

### 🎯 ¿Cómo funciona?
* Todo el sistema de sombras, linterna y neones es administrado por un único gestor:
  * **Objeto:** `Objects > Control > Effects > DynamicL > o_light_ctrl`
* **Ajuste fino de la Linterna del Jugador:**
  * El origen del haz de luz se encuentra en `y - 12` (centrado en el pecho del sprite del jugador de 20 px).
  * Oclusión realista con muros del escenario (`c_light_cone` contra `ts_mundo_prueba`).
  * Halo suave en los pies (`42 px`) para no perder de vista al personaje en oscuridad total.
  * Destello de fogonazo (*muzzle flash*) al disparar armas.
  * Bruma volumétrica cónica en la dirección del cursor.
  * **Apagado en sigilo:** Se apaga automáticamente si el jugador entra a una rejilla de ventilación (`is_hidden`).
* **Luces de Neón Emisivas:**
  * Checkpoints activos: Luz cian pulsante con oscilación senoidal.
  * Checkpoints inactivos: Luz roja tenue.
  * Robots enemigos: Luz de visores y reactores en el pecho y resplandor bajo el chasis.

### 📁 Recursos de GameMaker involucrados:
* Objeto: `Objects > Control > Effects > DynamicL > o_light_ctrl`
  * Evento `Create`: Superficie de luz y color ambiental base (`ambient = make_color_rgb(8, 12, 18)`).
  * Evento `Draw_73`: Conos de luz, halo volumétrico y luces de neón de enemigos y checkpoints.
* Scripts auxiliares:
  * `Functions > Control > c_light_draw`
  * `Functions > Control > c_light_cast`

### 🛠️ ¿Cómo calibrar la linterna o la oscuridad?
* **Cambiar apertura o alcance de la linterna:** En `o_light_ctrl > Draw_73`:
  * Ángulo de apertura: Modifica el valor `62` en la llamada a `c_light_cone` (ejemplo: `80` para haz más ancho).
  * Alcance: Modifica `lerp(170, 290, _f)` para aumentar la longitud del haz.
* **Aclarar la oscuridad general:** En `o_light_ctrl > Create`, cambia `ambient = make_color_rgb(18, 24, 34);` para mayor visibilidad general.

---

## 7. Fondo Escénico con Efecto de Profundidad y Relieve

### 🎯 ¿Cómo funciona técnicamente?
* **Capa nativa de Tilemap en `Rooms > Room1`:**
  * La capa se llama **`ts_background`** y está configurada con **`depth = 700`** (se dibuja detrás de las instancias y del terreno sólido).
* **El Tileset (`TileSets > ts_background`):**
  * Se alimenta del sprite de textura `Sprites > TileSets > s_bg_tileset` (256x256 px en cuadrículas de **32x32 px**).
* **Variedad de baldosas diseñadas:**
  1. Placas de mamparo metálico con biseles de relieve 3D.
  2. Placas blindadas con remaches en las esquinas.
  3. Tuberías de conducción horizontal y vertical con uniones de bridas y reflejos especulares de acero.
  4. Rejillas de ventilación secundarias y paneles con luces de circuito.
* **¿Por qué genera sensación de relieve 2.5D?**
  * Al no ser un fondo negro plano, la luz dinámica de la linterna ilumina gradualmente las zonas de sombra y brillo ya pintadas en las baldosas metálicas, simulando volumen y relieve tridimensional en tiempo real.

### 🛠️ ¿Cómo cambiar el fondo de manera detallada?

#### Método 1: Mover, borrar o pintar bloques en la sala (Diseño de nivel)
1. En el Asset Browser, abre **`Rooms > Room1`**.
2. En el panel **Layers** (a la izquierda del Room Editor), selecciona la capa de tipo Tilemap llamada **`ts_background`**.
3. En la ventana **Tileset Palette** que se abre en GameMaker, verás todas las baldosas de 32x32 disponibles:
   * **Para pintar:** Haz clic en la baldosa que quieras (por ejemplo, una tubería) y haz clic o arrastra con el ratón sobre cualquier celda del escenario.
   * **Para borrar:** Haz clic con el **botón derecho** sobre cualquier celda para borrarla (o selecciona la primera casilla transparente de la paleta).
   * **Para hacer tuberías continuas:** Arrastra el ratón manteniendo pulsado el botón izquierdo para trazar líneas de conductos completas.

#### Método 2: Cambiar el dibujo, colores o texturas de las baldosas (Pixel Art)
1. En el Asset Browser, ve a **`Sprites > TileSets > s_bg_tileset`**.
2. Haz clic en el botón **Edit Image**.
3. Se abrirá el editor de pixel art de GameMaker:
   * Puedes retocar los colores con la paleta de GameMaker, cambiar el tono de las tuberías o añadir detalles.
   * Si usas herramientas externas como **Aseprite** o **Photoshop**, puedes modificar el archivo PNG y luego presionar el botón **Import** en la ventana de `s_bg_tileset`.
4. Al pulsar **`Ctrl + S`** para guardar, **todas las salas que usen el fondo se actualizarán automáticamente en tiempo real**.

---

## 8. Preguntas Frecuentes y Solución de Problemas (Troubleshooting)

### ❓ ¿Qué significa el icono de la "X Roja" en el Asset Browser sobre algunos sprites?
* **Causa:** Cuando se reemplazan sprites externamente mientras GameMaker está en ejecución, la caché visual del IDE (`GMS2IDE/Cache/.../Icons`) puede guardar temporalmente una miniatura de sustitución con una "X roja".
* **Solución:**
  1. Haz clic en el botón de la **escoba (Clean)** en la barra superior de GameMaker, o presiona **`Ctrl + F7`**.
  2. O bien colapsa y vuelve a abrir la carpeta en el Asset Browser (o pulsa `Ctrl + S` en la ventana del sprite).
  3. Los archivos de miniatura en caché ya han sido regenerados y corregidos.

### ❓ El robot araña no se mueve o no salta
* Asegúrate de que el objeto colocado en la sala sea `Objects > Enemies > EnemyC > o_enemy_2`.
* La araña solo inicia persecución activa si el jugador entra en su campo de visión sin muros de por medio y el jugador **no** está dentro de un escondite.

### ❓ La linterna no se enciende
* Verifica si el jugador está en estado escondido (`is_hidden = true`). Por diseño de sigilo, la linterna se apaga automáticamente dentro de la rejilla de ventilación para proteger al jugador. Pulsa `E` para salir.

---

## 9. Roadmap: Mejoras Planificadas para la Siguiente Versión

- [ ] **Efectos de Sonido Atmosféricos (SFX):**
  - Pasos mecánicos y servos de los robots (`s_enemy_1` y `s_enemy_2`).
  - Tensión y zumbido del cable del gancho (`Grapple Hook`).
  - Sonido metálico al abrir/cerrar la rejilla de ventilación.
  - Alarma sónica de alerta al pasar a persecución.
- [ ] **Shader de Mapa de Normales (Normal Mapping) en Tiempo Real:**
  - Soporte de relieve dinámico calculado por pixel shader interactuando con la linterna.
- [ ] **Indicador Visual de Estamina para la Cuerda:**
  - Barra de energía o aviso visual sobre el jugador indicando cuánto tiempo le queda antes de soltarse por fatiga.
- [ ] **Guardado Persistente en Disco (Save / Load):**
  - Guardado del último `spawn_order` alcanzado en archivo local (`savegame.json`) para continuar tras cerrar el juego.
- [ ] **Nuevas Variantes de Enemigos y Trampas:**
  - Dron aéreo con foco de luz cenital móvil.
  - Barreras láser de seguridad desactivables.
