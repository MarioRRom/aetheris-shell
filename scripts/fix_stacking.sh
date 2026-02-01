#!/bin/sh

# Espera para que quickshell inicie y cree sus ventanas completamente.
sleep 2

ESCRITORIO_CLASE='("root" "Bspwm")'
TOLERANCIA=50

# 1. Obtener información de monitores para detectar wallpapers fullscreen
MONITOR_SIZES=$(xrandr --current | grep ' connected' | grep -o '[0-9]\+x[0-9]\+' | sort -u)

# 2. Obtener IDs de ventanas quickshell con _NET_WM_STATE_BELOW
BAR_DATA=""
WALLPAPER_DATA=""

BAR_IDS_FUNCIONALES=$(xwininfo -root -tree | grep ' "quickshell"' | awk '{print $1}' | grep -o '0x[0-9a-f]\+')

for ID in $BAR_IDS_FUNCIONALES; do
    # Filtrar solo las ventanas configuradas como 'below'
    if xprop -id "$ID" | grep -q "_NET_WM_STATE_BELOW"; then
        # Obtener dimensiones de la ventana
        WIN_INFO=$(xwininfo -id "$ID")
        WIN_WIDTH=$(echo "$WIN_INFO" | grep "Width:" | awk '{print $2}')
        WIN_HEIGHT=$(echo "$WIN_INFO" | grep "Height:" | awk '{print $2}')
        X_COORD=$(echo "$WIN_INFO" | grep "Absolute upper-left X:" | awk '{print $NF}' | tr -d '[:space:]')
        
        # Verificar si el tamaño coincide con algún monitor (es wallpaper)
        IS_WALLPAPER=false
        for SIZE in $MONITOR_SIZES; do
            MON_WIDTH=$(echo "$SIZE" | cut -d'x' -f1)
            MON_HEIGHT=$(echo "$SIZE" | cut -d'x' -f2)
            
            if [ "$WIN_WIDTH" = "$MON_WIDTH" ] && [ "$WIN_HEIGHT" = "$MON_HEIGHT" ]; then
                IS_WALLPAPER=true
                break
            fi
        done
        
        if [ -n "$X_COORD" ] && [ "$X_COORD" -ge 0 ] 2>/dev/null; then
            if [ "$IS_WALLPAPER" = true ]; then
                # Es wallpaper (fullscreen)
                WALLPAPER_DATA="$WALLPAPER_DATA $ID"
            else
                # Es barra (no fullscreen)
                BAR_DATA="$BAR_DATA $ID:$X_COORD"
            fi
        fi
    fi
done

# 3. Obtener IDs y Coordenadas X de los Escritorios bspwm
ESCRITORIO_DATA=$(
    xwininfo -root -tree | \
    grep "$ESCRITORIO_CLASE" | \
    awk '{
        id=$1; 
        offset=$NF; 
        sub(/^\+/, "", offset); 
        split(offset, a, "+");
        x_coord=a[1];
        printf "%s:%s ", id, x_coord;
    }'
)

# 4. Aplicar Apilamiento para BARRAS: Mapear Barra a su Escritorio y Elevar ABOVE
for BAR_ENTRY in $BAR_DATA; do
    BAR_ID=$(echo "$BAR_ENTRY" | cut -d: -f1)
    BAR_X=$(echo "$BAR_ENTRY" | cut -d: -f2 | tr -d '[:space:]') 
    CORRECT_DESK_ID=""
    
    if ! [ "$BAR_X" -ge 0 ] 2>/dev/null; then
        continue
    fi
    
    for DESK_ENTRY in $ESCRITORIO_DATA; do
        DESK_ID=$(echo "$DESK_ENTRY" | cut -d: -f1)
        DESK_X=$(echo "$DESK_ENTRY" | cut -d: -f2 | tr -d '[:space:]')
        
        if ! [ "$DESK_X" -ge 0 ] 2>/dev/null; then
            continue
        fi
        
        if [ "$BAR_X" -ge "$DESK_X" ] && [ "$BAR_X" -le "$((DESK_X + TOLERANCIA))" ]; then
            CORRECT_DESK_ID="$DESK_ID"
            break
        fi
    done
    
    if [ ! -z "$CORRECT_DESK_ID" ]; then
        # Elevar la barra SOBRE el escritorio
        xdo above -t "$CORRECT_DESK_ID" "$BAR_ID"
        sleep 0.01
    fi
done

# 5. Aplicar Apilamiento para WALLPAPERS: Colocar debajo del root
for WALL_ID in $WALLPAPER_DATA; do
    # Colocar directamente debajo del root
    xdo lower "$WALL_ID"
    sleep 0.01
done